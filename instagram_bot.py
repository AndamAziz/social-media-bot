import requests
import time
import logging
import re
import json
import os
import subprocess
from datetime import datetime
from telegram import Update
from telegram.ext import Application, MessageHandler, filters, ContextTypes, CommandHandler

from config import TELEGRAM_TOKEN, SOCIAL_API_KEY, SOCIAL_API_HOST

logging.basicConfig(
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.INFO,
    handlers=[
        logging.FileHandler('bot.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

ADMIN_USER_ID = 144068979

def save_stats(platform, success=True):
    try:
        try:
            with open('bot_stats.json', 'r') as f:
                stats = json.load(f)
        except:
            stats = {
                'total': 0, 'instagram': 0, 'facebook': 0, 'tiktok': 0,
                'twitter': 0, 'snapchat': 0, 'youtube': 0, 'reddit': 0,
                'pinterest': 0, 'linkedin': 0, 'success': 0, 'failed': 0,
                'started': datetime.now().isoformat()
            }
        
        stats['total'] = stats.get('total', 0) + 1
        stats[platform] = stats.get(platform, 0) + 1
        
        if success:
            stats['success'] = stats.get('success', 0) + 1
        else:
            stats['failed'] = stats.get('failed', 0) + 1
        
        stats['last_update'] = datetime.now().isoformat()
        
        with open('bot_stats.json', 'w') as f:
            json.dump(stats, f, indent=2)
        
        logger.info(f"📊 Total: {stats['total']}")
    except Exception as e:
        logger.error(f"Stats error: {e}")

def convert_to_mp3(video_path, user_id):
    try:
        audio_path = f"/tmp/audio_{user_id}_{int(time.time())}.mp3"
        subprocess.run(['ffmpeg', '-i', video_path, '-vn', '-acodec', 'libmp3lame', '-q:a', '2', audio_path, '-y'], check=True, capture_output=True, timeout=60)
        logger.info("MP3 converted!")
        return audio_path
    except Exception as e:
        logger.error(f"MP3 error: {e}")
        return None

class SocialDownloader:
    def __init__(self):
        self.api_key = SOCIAL_API_KEY
        self.host = SOCIAL_API_HOST
        
    def download(self, url):
        try:
            logger.info("Social Download API...")
            headers = {'x-rapidapi-key': self.api_key, 'x-rapidapi-host': self.host, 'Content-Type': 'application/json'}
            data = {"url": url}
            response = requests.post(f"https://{self.host}/v1/social/autolink", headers=headers, json=data, timeout=30)
            logger.info(f"API Status: {response.status_code}")
            
            if response.status_code == 200:
                result = response.json()
                video_url = None
                if 'medias' in result and isinstance(result['medias'], list) and len(result['medias']) > 0:
                    video_url = result['medias'][0].get('url')
                elif 'url' in result:
                    video_url = result['url']
                elif 'download_url' in result:
                    video_url = result['download_url']
                
                if video_url:
                    logger.info("Success!")
                    return {'success': True, 'source': 'social_api', 'data': {'video_url': video_url, 'type': 'video'}}
                else:
                    return {'success': False, 'error': 'No video found'}
            else:
                return {'success': False, 'error': f'API Error: {response.status_code}'}
        except Exception as e:
            logger.error(f"API error: {e}")
            return {'success': False, 'error': str(e)}

social_downloader = SocialDownloader()

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    text = update.message.text
    
    is_instagram = 'instagram.com' in text
    is_facebook = 'facebook.com' in text or 'fb.watch' in text or 'fb.com' in text
    is_tiktok = 'tiktok.com' in text or 'vm.tiktok.com' in text
    is_twitter = 'twitter.com' in text or 'x.com' in text
    is_snapchat = 'snapchat.com' in text or 'snap.com' in text
    is_youtube = 'youtube.com' in text or 'youtu.be' in text
    is_reddit = 'reddit.com' in text
    is_pinterest = 'pinterest.com' in text
    is_linkedin = 'linkedin.com' in text
    
    if not (is_instagram or is_facebook or is_tiktok or is_twitter or is_snapchat or is_youtube or is_reddit or is_pinterest or is_linkedin):
        return
    
    # دیاریکردنی پلاتفۆرم
    if is_instagram:
        platform = 'instagram'
        emoji = '📸'
    elif is_facebook:
        platform = 'facebook'
        emoji = '📘'
    elif is_tiktok:
        platform = 'tiktok'
        emoji = '🎵'
    elif is_twitter:
        platform = 'twitter'
        emoji = '🐦'
    elif is_snapchat:
        platform = 'snapchat'
        emoji = '👻'
    elif is_youtube:
        platform = 'youtube'
        emoji = '📺'
    elif is_reddit:
        platform = 'reddit'
        emoji = '🤖'
    elif is_pinterest:
        platform = 'pinterest'
        emoji = '📌'
    elif is_linkedin:
        platform = 'linkedin'
        emoji = '💼'
    else:
        platform = 'other'
        emoji = '🌐'
    
    user = update.message.from_user
    user_id = user.id
    logger.info(f"Request: {platform} - {text[:50]}")
    
    status = await update.message.reply_text(f"{emoji} Please Wait...⏳❤️\n\nتکایە چاوەڕێ بکە")
    
    try:
        result = social_downloader.download(text)
        
        if result['success']:
            video_url = result['data']['video_url']
            await update.message.reply_video(video_url, caption=f"{emoji} Video")
            await status.edit_text("⏳ گۆڕین بۆ MP3...")
            
            temp_video = f"/tmp/temp_{user_id}_{int(time.time())}.mp4"
            response = requests.get(video_url, timeout=60)
            with open(temp_video, 'wb') as f:
                f.write(response.content)
            
            audio_path = convert_to_mp3(temp_video, user_id)
            if audio_path:
                with open(audio_path, 'rb') as f:
                    await update.message.reply_audio(f, caption="🎵 MP3")
                os.remove(audio_path)
            
            os.remove(temp_video)
            await status.delete()
            save_stats(platform, success=True)
        else:
            await status.edit_text("❌ نەتوانرا داونلۆد بکرێت")
            save_stats(platform, success=False)
    except Exception as e:
        try:
            await status.edit_text("❌ هەڵە")
        except:
            pass
        save_stats(platform, success=False)
        logger.error(f"Exception: {e}")

async def stats_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.message.from_user.id != ADMIN_USER_ID:
        await update.message.reply_text("⛔ Admin only!")
        return
    
    try:
        with open('bot_stats.json', 'r') as f:
            stats = json.load(f)
        
        message = f"📊 *Stats*\n\n🔢 Total: *{stats.get('total', 0)}*\n📸 Instagram: *{stats.get('instagram', 0)}*\n📘 Facebook: *{stats.get('facebook', 0)}*\n🎵 TikTok: *{stats.get('tiktok', 0)}*\n\n✅ Success: *{stats.get('success', 0)}*\n❌ Failed: *{stats.get('failed', 0)}*"
        await update.message.reply_text(message, parse_mode='Markdown')
    except:
        await update.message.reply_text("📊 No stats!")

async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_name = update.message.from_user.first_name
    await update.message.reply_text(
        f"👋 *سڵاو {user_name}!*\n"
        f"بەخێربێیت بۆ\n\n"
        f"🎬 *ALL IN ONE BIG BOSS BOT* 🎬\n"
        f"━━━━━━━━━━━━━━━━━━━━\n\n"
        f"*📱 پشتگیری بۆ 9+ پلاتفۆرم:*\n\n"
        f"📸 Instagram  │  📘 Facebook\n"
        f"🎵 TikTok  │  🐦 Twitter/X\n"
        f"👻 Snapchat  │  📺 YouTube\n"
        f"🤖 Reddit  │  📌 Pinterest\n"
        f"💼 LinkedIn\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n"
        f"*⚡ تایبەتمەندییەکان:*\n\n"
        f"✨ داونلۆدی خێرا و بێ سنوور\n"
        f"📹 ڤیدیۆ بە کوالیتی بەرز\n"
        f"🎵 گۆڕین بۆ MP3 ئۆتۆماتیکی\n"
        f"🚀 بێ پێویستی بە لۆگین\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n"
        f"*📝 چۆنیەتی بەکارهێنان:*\n\n"
        f"تەنها لینکی میدیا بنێرە!\n\n"
        f"*بۆ یارمەتی:* /help\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n"
        f"👨‍💻 *Developer:* @AndamAziz\n"
        f"💫 *Made with ❤️ for you!*",
        parse_mode='Markdown'
    )

async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "*📖 HELP*\n━━━━━━━━━━\n\n*How to use:*\n1️⃣ Copy link\n2️⃣ Send to bot\n3️⃣ Get video & MP3!\n\n"
        "*Platforms:*\nInstagram | Facebook | TikTok\nTwitter | YouTube | Snapchat\nReddit | Pinterest | LinkedIn\n\n"
        "👨‍💻 @AndamAziz",
        parse_mode='Markdown'
    )

def main():
    app = Application.builder().token(TELEGRAM_TOKEN).build()
    app.add_handler(CommandHandler("start", start_command))
    app.add_handler(CommandHandler("help", help_command))
    app.add_handler(CommandHandler("stats", stats_command))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    logger.info("Bot started!")
    app.run_polling()

if __name__ == '__main__':
    main()
