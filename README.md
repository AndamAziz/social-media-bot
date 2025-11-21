<div align="center">

# 🎬 ALL IN ONE BIG BOSS Bot

### Multi-Platform Social Media Video Downloader

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Telegram Bot](https://img.shields.io/badge/Telegram-Bot-blue?logo=telegram)](https://telegram.org/)
[![GitHub Stars](https://img.shields.io/github/stars/AndamAziz/social-media-bot?style=social)](https://github.com/AndamAziz/social-media-bot)

**Download videos & convert to MP3 from 9+ platforms instantly via Telegram!**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Support](#-support)

</div>

---

## 🌟 Features

<table>
<tr>
<td>

### 📱 Multi-Platform Support
- 📸 **Instagram** (Posts, Reels, IGTV)
- 📘 **Facebook** (Videos, Reels)
- 🎵 **TikTok** (Videos)
- 🐦 **Twitter/X** (Videos)
- 👻 **Snapchat** (Stories)
- 📺 **YouTube** (Videos, Shorts)
- 🤖 **Reddit** (Videos)
- 📌 **Pinterest** (Videos)
- 💼 **LinkedIn** (Videos)

</td>
<td>

### ⚡ Key Benefits
- ✨ Fast & unlimited downloads
- 📹 High-quality video output
- 🎵 Automatic MP3 conversion
- 🚀 No login required
- 💯 No watermarks
- 🔒 Private & secure
- 📊 Admin statistics
- 🌐 Multi-language support

</td>
</tr>
</table>

---

## 🚀 Installation

### Quick Start (Public Repository)
```bash
git clone https://github.com/AndamAziz/social-media-bot.git
cd social-media-bot
sudo bash auto-install.sh
```

### Private Repository Installation
```bash
# Method 1: HTTPS with Personal Access Token
git clone https://YOUR_TOKEN@github.com/AndamAziz/social-media-bot.git
cd social-media-bot
sudo bash auto-install.sh

# Method 2: SSH Key
git clone git@github.com:AndamAziz/social-media-bot.git
cd social-media-bot
sudo bash auto-install.sh
```

<details>
<summary><b>🔐 How to Get Personal Access Token</b></summary>

1. Go to [GitHub Settings → Tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)**
3. Select scope: `repo` (Full control)
4. Click **Generate token**
5. Copy the token (shown only once!)

**Usage:**
```bash
git clone https://ghp_YOUR_TOKEN_HERE@github.com/AndamAziz/social-media-bot.git
```

</details>

<details>
<summary><b>🔑 How to Setup SSH Key</b></summary>
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub:
# https://github.com/settings/keys → New SSH key
```

</details>

---

## ⚙️ Configuration

### Prerequisites

Before installation, you need:

| Requirement | Description | Get It |
|-------------|-------------|--------|
| 🤖 **Telegram Bot Token** | Create a bot on Telegram | [@BotFather](https://t.me/BotFather) |
| 🔑 **RapidAPI Key** | Subscribe to Social Download API | [RapidAPI](https://rapidapi.com/social-api1-instagram/api/social-download-all-in-one) |
| 👤 **Telegram User ID** | Your Telegram user ID | [@userinfobot](https://t.me/userinfobot) |

### Installation Steps

1. **Clone Repository**
```bash
   git clone https://github.com/AndamAziz/social-media-bot.git
   cd social-media-bot
```

2. **Run Installer**
```bash
   sudo bash auto-install.sh
```

3. **Enter Configuration**
   - Telegram Bot Token
   - RapidAPI Key
   - Your Telegram User ID

4. **Done!** Bot starts automatically

---

## 📖 Usage

### Bot Commands

| Command | Description | Access |
|---------|-------------|--------|
| `/start` | Welcome message & features | Everyone |
| `/help` | Usage instructions | Everyone |
| `/stats` | View download statistics | Admin only |

### How to Download

1. **Start** your bot on Telegram
2. **Send** any video link from supported platforms
3. **Receive** video + MP3 instantly!

### Example
```
User: https://www.instagram.com/reel/XXXXX/
Bot:  📸 Please Wait...⏳❤️
Bot:  📹 Video (sent)
Bot:  🎵 Audio (MP3) (sent)
```

---

## 🛠️ Management

### Start/Stop Bot
```bash
# Navigate to bot directory
cd /root/allinone-bot

# Start bot
./start.sh

# Stop bot
./stop.sh

# View logs
tail -f output.log

# View statistics
cat bot_stats.json
```

### Manual Configuration
```bash
# Edit configuration
nano /root/allinone-bot/config.py

# Restart bot
cd /root/allinone-bot
./stop.sh
./start.sh
```

---

## 🔄 Auto-Start on Reboot

Make bot start automatically after server restart:
```bash
# Create systemd service
cat > /etc/systemd/system/allinone-bot.service << 'EOF'
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
EOF

# Enable and start service
systemctl daemon-reload
systemctl enable allinone-bot
systemctl start allinone-bot

# Check status
systemctl status allinone-bot

# View logs
journalctl -u allinone-bot -f
```

---

## 📊 Project Structure
```
allinone-bot/
├── instagram_bot.py       # Main bot code
├── config.py              # Configuration (tokens, API keys)
├── start.sh               # Start script
├── stop.sh                # Stop script
├── output.log             # Bot runtime logs
└── bot_stats.json         # Download statistics
```

---

## 🐛 Troubleshooting

<details>
<summary><b>Bot not responding?</b></summary>
```bash
# Check if bot is running
ps aux | grep instagram_bot

# Check logs for errors
tail -100 /root/allinone-bot/output.log

# Restart bot
cd /root/allinone-bot
./stop.sh
./start.sh
```

</details>

<details>
<summary><b>FFmpeg not found?</b></summary>
```bash
sudo apt update
sudo apt install ffmpeg -y
```

</details>

<details>
<summary><b>Python module errors?</b></summary>
```bash
pip3 install python-telegram-bot requests --break-system-packages
```

</details>

<details>
<summary><b>API errors (403/401)?</b></summary>

- Check your RapidAPI subscription is active
- Verify API key in `config.py`
- Ensure you haven't exceeded rate limits

</details>

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. 🍴 Fork the repository
2. 🌿 Create a feature branch (`git checkout -b feature/amazing-feature`)
3. 💾 Commit your changes (`git commit -m 'Add amazing feature'`)
4. 📤 Push to branch (`git push origin feature/amazing-feature`)
5. 🔃 Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

<div align="center">

**Andam Aziz**

[![Telegram](https://img.shields.io/badge/Telegram-@AndamAziz-blue?logo=telegram)](https://t.me/AndamAziz)
[![GitHub](https://img.shields.io/badge/GitHub-@AndamAziz-black?logo=github)](https://github.com/AndamAziz)

</div>

---

## ⭐ Show Your Support

Give a ⭐️ if this project helped you!

<div align="center">

### 📞 Support & Contact

For support, bug reports, or feature requests:
- 💬 Telegram: [@AndamAziz](https://t.me/AndamAziz)
- 🐛 Issues: [GitHub Issues](https://github.com/AndamAziz/social-media-bot/issues)

</div>

---

<div align="center">

**Made with ❤️ by [Andam Aziz](https://t.me/AndamAziz)**

*Download. Convert. Enjoy.* 🎬🎵

</div>
