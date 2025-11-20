#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${PURPLE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "     🎬 ALL IN ONE BIG BOSS BOT INSTALLER     "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}"
echo ""
echo -e "${CYAN}Multi-platform Video Downloader with MP3 Conversion${NC}"
echo -e "${CYAN}Developer: @AndamAziz${NC}"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Please run as root!${NC}"
    echo -e "${YELLOW}Use: sudo bash auto-install.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Running as root${NC}"
echo ""

echo -e "${BLUE}[1/6]${NC} ${YELLOW}Updating system...${NC}"
apt update -qq > /dev/null 2>&1
echo -e "${GREEN}✅ System updated${NC}"
echo ""

echo -e "${BLUE}[2/6]${NC} ${YELLOW}Installing dependencies...${NC}"
apt install -y python3 python3-pip ffmpeg git wget curl -qq > /dev/null 2>&1
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

echo -e "${BLUE}[3/6]${NC} ${YELLOW}Installing Python packages...${NC}"
pip3 install python-telegram-bot requests --break-system-packages -qq > /dev/null 2>&1
echo -e "${GREEN}✅ Python packages installed${NC}"
echo ""

echo -e "${BLUE}[4/6]${NC} ${YELLOW}Setting up bot directory...${NC}"
INSTALL_DIR="/root/allinone-bot"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
echo -e "${GREEN}✅ Directory created: $INSTALL_DIR${NC}"
echo ""

echo -e "${BLUE}[5/6]${NC} ${YELLOW}Cloning from GitHub...${NC}"
git clone https://github.com/AndamAziz/social-media-bot.git temp-clone > /dev/null 2>&1
if [ -f "temp-clone/instagram_bot.py" ]; then
    cp temp-clone/instagram_bot.py .
    cp temp-clone/config.py.example .
    rm -rf temp-clone
    echo -e "${GREEN}✅ Bot files downloaded${NC}"
else
    echo -e "${RED}❌ Failed to download bot files${NC}"
    exit 1
fi
echo ""

echo -e "${BLUE}[6/6]${NC} ${YELLOW}Configuration...${NC}"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Please provide the following information:${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}📱 Telegram Bot Token:${NC}"
echo -e "${CYAN}   (Get it from @BotFather)${NC}"
read -p "   Token: " TELEGRAM_TOKEN
echo ""

echo -e "${YELLOW}🔑 RapidAPI Key:${NC}"
echo -e "${CYAN}   (Get it from rapidapi.com)${NC}"
read -p "   API Key: " RAPIDAPI_KEY
echo ""

echo -e "${YELLOW}👤 Your Telegram User ID:${NC}"
echo -e "${CYAN}   (Get it from @userinfobot)${NC}"
read -p "   User ID: " ADMIN_ID
echo ""

cat > config.py << CONFIGEOF
# Telegram Bot Configuration
TELEGRAM_TOKEN = "$TELEGRAM_TOKEN"

# RapidAPI Configuration
SOCIAL_API_KEY = "$RAPIDAPI_KEY"
SOCIAL_API_HOST = "social-download-all-in-one.p.rapidapi.com"
CONFIGEOF

sed -i "s/ADMIN_USER_ID = 144068979/ADMIN_USER_ID = $ADMIN_ID/" instagram_bot.py

echo -e "${GREEN}✅ Configuration saved${NC}"
echo ""

cat > start.sh << 'STARTEOF'
#!/bin/bash
echo "🚀 Starting bot..."
pkill -f instagram_bot.py
nohup python3 instagram_bot.py > output.log 2>&1 &
sleep 2
if pgrep -f instagram_bot.py > /dev/null; then
    echo "✅ Bot started!"
else
    echo "❌ Failed to start!"
fi
STARTEOF

chmod +x start.sh

cat > stop.sh << 'STOPEOF'
#!/bin/bash
echo "⏹️  Stopping bot..."
pkill -f instagram_bot.py
echo "✅ Bot stopped!"
STOPEOF

chmod +x stop.sh

clear
echo -e "${GREEN}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    ✅ INSTALLATION COMPLETED SUCCESSFULLY!    "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}"
echo ""
echo -e "${CYAN}📂 Installed in: ${YELLOW}$INSTALL_DIR${NC}"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🚀 Commands:${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}Start:${NC} cd $INSTALL_DIR && ./start.sh"
echo -e "${RED}Stop:${NC}  cd $INSTALL_DIR && ./stop.sh"
echo -e "${YELLOW}Logs:${NC}  tail -f $INSTALL_DIR/output.log"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}🤖 Starting bot...${NC}"
echo ""

cd "$INSTALL_DIR"
./start.sh

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}✨ Bot is running!${NC}"
echo -e "${CYAN}👨‍💻 @AndamAziz${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
