# 🎬 ALL IN ONE BIG BOSS Bot

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Telegram Bot](https://img.shields.io/badge/Telegram-Bot-blue?logo=telegram)](https://telegram.org/)

Powerful Telegram bot for downloading videos and converting to MP3 from 9+ social media platforms.

## 🌟 Features

- ✨ Download videos from 9+ platforms
- 🎵 Automatic MP3 conversion
- 📹 High-quality downloads
- 🚀 Fast and reliable
- 💯 No watermarks
- 🔒 No login required

## 📱 Supported Platforms

📸 Instagram | 📘 Facebook | 🎵 TikTok | 🐦 Twitter/X | 📺 YouTube | 👻 Snapchat | 🤖 Reddit | 📌 Pinterest | 💼 LinkedIn

## 🚀 Quick Installation

### One-Line Install (Recommended)
```bash
bash <(curl -sL https://github.com/AndamAziz/social-media-bot/raw/main/auto-install.sh)
```

### Alternative Methods

**Method 1: wget**
```bash
wget https://github.com/AndamAziz/social-media-bot/raw/main/auto-install.sh
chmod +x auto-install.sh
sudo bash auto-install.sh
```

**Method 2: Manual Clone**
```bash
git clone https://github.com/AndamAziz/social-media-bot.git
cd social-media-bot
chmod +x auto-install.sh
sudo bash auto-install.sh
```

## ⚙️ Configuration

The installer will ask for:

1. **Telegram Bot Token** - Get from [@BotFather](https://t.me/BotFather)
2. **RapidAPI Key** - Get from [RapidAPI](https://rapidapi.com/social-api1-instagram/api/social-download-all-in-one)
3. **Your Telegram User ID** - Get from [@userinfobot](https://t.me/userinfobot)

## 📖 Usage

1. Start a chat with your bot
2. Send `/start` to see welcome message
3. Send any supported social media link
4. Receive video and MP3 instantly!

### Commands

- `/start` - Start the bot
- `/help` - Show help message
- `/stats` - View statistics (Admin only)

## 🛠️ Management
```bash
# Start the bot
cd /root/allinone-bot && ./start.sh

# Stop the bot
cd /root/allinone-bot && ./stop.sh

# View logs
tail -f /root/allinone-bot/output.log

# View statistics
cat /root/allinone-bot/bot_stats.json
```

## 📊 Project Structure
```
allinone-bot/
├── instagram_bot.py      # Main bot code
├── config.py             # Configuration
├── start.sh              # Start script
├── stop.sh               # Stop script
└── output.log            # Bot logs
```

## 🐛 Troubleshooting

### Bot not responding?
```bash
ps aux | grep instagram_bot
tail -100 /root/allinone-bot/output.log
```

### FFmpeg not found?
```bash
sudo apt install ffmpeg -y
```

### Need to reconfigure?
```bash
cd /root/allinone-bot
nano config.py
./start.sh
```

## 🔄 Auto-Start on Reboot
```bash
cat > /etc/systemd/system/allinone-bot.service << 'SERVICEEOF'
[Unit]
Description=ALL IN ONE BIG BOSS Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/allinone-bot
ExecStart=/usr/bin/python3 /root/allinone-bot/instagram_bot.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICEEOF

systemctl daemon-reload
systemctl enable allinone-bot
systemctl start allinone-bot
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License.

## 👨‍💻 Author

**Andam Aziz**
- Telegram: [@AndamAziz](https://t.me/AndamAziz)
- GitHub: [@AndamAziz](https://github.com/AndamAziz)

## ⭐ Show Your Support

Give a ⭐️ if this project helped you!

## 📞 Support

For support, contact [@AndamAziz](https://t.me/AndamAziz) on Telegram.

---

Made with ❤️ by Andam Aziz
