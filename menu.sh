#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

BOT_DIR="/root/allinone-bot"

show_menu() {
    clear
    echo -e "${PURPLE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "     🎬 ALL IN ONE BIG BOSS BOT - MENU     "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
    echo ""
    echo -e "${CYAN}1.${NC}  ${GREEN}Start Bot${NC}          - Start the bot"
    echo -e "${CYAN}2.${NC}  ${RED}Stop Bot${NC}           - Stop the bot"
    echo -e "${CYAN}3.${NC}  ${YELLOW}Restart Bot${NC}        - Restart the bot"
    echo -e "${CYAN}4.${NC}  ${BLUE}Bot Status${NC}         - Check bot status"
    echo -e "${CYAN}5.${NC}  ${PURPLE}View Logs${NC}          - View bot logs"
    echo -e "${CYAN}6.${NC}  ${CYAN}View Stats${NC}         - View statistics"
    echo -e "${CYAN}7.${NC}  ${YELLOW}Edit Config${NC}        - Edit configuration"
    echo -e "${CYAN}8.${NC}  ${BLUE}Update Bot${NC}         - Update from GitHub"
    echo -e "${CYAN}9.${NC}  ${GREEN}Install Service${NC}    - Install systemd service"
    echo -e "${CYAN}10.${NC} ${PURPLE}Live Stats${NC}         - Live statistics dashboard"
    echo -e "${CYAN}0.${NC}  ${RED}Exit${NC}               - Exit menu"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

start_bot() {
    echo -e "${GREEN}🚀 Starting bot...${NC}"
    cd "$BOT_DIR"
    pkill -f instagram_bot.py
    nohup python3 instagram_bot.py > output.log 2>&1 &
    sleep 2
    if pgrep -f instagram_bot.py > /dev/null; then
        echo -e "${GREEN}✅ Bot started successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to start bot!${NC}"
    fi
    read -p "Press Enter to continue..."
}

stop_bot() {
    echo -e "${RED}⏹️  Stopping bot...${NC}"
    pkill -f instagram_bot.py
    sleep 1
    if ! pgrep -f instagram_bot.py > /dev/null; then
        echo -e "${GREEN}✅ Bot stopped successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to stop bot!${NC}"
    fi
    read -p "Press Enter to continue..."
}

restart_bot() {
    echo -e "${YELLOW}🔄 Restarting bot...${NC}"
    stop_bot
    sleep 2
    start_bot
}

bot_status() {
    echo -e "${BLUE}📊 Bot Status:${NC}"
    echo ""
    if pgrep -f instagram_bot.py > /dev/null; then
        echo -e "${GREEN}✅ Bot is RUNNING${NC}"
        echo ""
        echo "Process Info:"
        ps aux | grep instagram_bot.py | grep -v grep
    else
        echo -e "${RED}❌ Bot is STOPPED${NC}"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

view_logs() {
    echo -e "${PURPLE}📋 Viewing logs (Press Ctrl+C to exit)...${NC}"
    echo ""
    cd "$BOT_DIR"
    tail -f output.log
}

view_stats() {
    echo -e "${CYAN}📊 Statistics:${NC}"
    echo ""
    if [ -f "$BOT_DIR/bot_stats.json" ]; then
        cat "$BOT_DIR/bot_stats.json"
    else
        echo -e "${YELLOW}No statistics available yet.${NC}"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

edit_config() {
    echo -e "${YELLOW}⚙️  Editing configuration...${NC}"
    cd "$BOT_DIR"
    nano config.py
    echo ""
    echo -e "${GREEN}✅ Configuration saved!${NC}"
    echo -e "${YELLOW}Do you want to restart the bot? (y/n)${NC}"
    read -r restart_choice
    if [[ "$restart_choice" == "y" || "$restart_choice" == "Y" ]]; then
        restart_bot
    fi
}

update_bot() {
    echo -e "${BLUE}🔄 Updating bot from GitHub...${NC}"
    echo ""
    
    # Stop bot
    echo -e "${YELLOW}Stopping bot...${NC}"
    pkill -f instagram_bot.py
    sleep 2
    
    # Backup
    echo -e "${YELLOW}Creating backup...${NC}"
    cp instagram_bot.py instagram_bot.py.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null
    
    # Pull from GitHub
    echo -e "${YELLOW}Pulling latest changes...${NC}"
    cd /root/social-media-bot
    git pull origin main
    
    # Copy to working directory
    echo -e "${YELLOW}Copying files...${NC}"
    cp instagram_bot.py "$BOT_DIR/"
    cp *.sh "$BOT_DIR/" 2>/dev/null
    
    # Start bot
    cd "$BOT_DIR"
    echo -e "${YELLOW}Starting bot...${NC}"
    nohup python3 instagram_bot.py > output.log 2>&1 &
    sleep 2
    
    if pgrep -f instagram_bot.py > /dev/null; then
        echo -e "${GREEN}✅ Bot updated and restarted successfully!${NC}"
    else
        echo -e "${RED}❌ Bot failed to start!${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

install_service() {
    echo -e "${GREEN}📦 Installing systemd service...${NC}"
    echo ""
    
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

    systemctl daemon-reload
    systemctl enable allinone-bot
    systemctl start allinone-bot
    
    echo -e "${GREEN}✅ Service installed and started!${NC}"
    echo ""
    echo "Service commands:"
    echo "  systemctl status allinone-bot   - Check status"
    echo "  systemctl start allinone-bot    - Start service"
    echo "  systemctl stop allinone-bot     - Stop service"
    echo "  systemctl restart allinone-bot  - Restart service"
    echo "  journalctl -u allinone-bot -f   - View logs"
    echo ""
    read -p "Press Enter to continue..."
}

live_stats_menu() {
    clear
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📊 Live Statistics Options${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}1.${NC} Live Dashboard       - Real-time stats dashboard"
    echo -e "${CYAN}2.${NC} Simple Stats         - Simple statistics view"
    echo -e "${CYAN}3.${NC} Summary              - Quick statistics summary"
    echo -e "${CYAN}4.${NC} Live Monitor         - Monitor downloads in real-time"
    echo -e "${CYAN}0.${NC} Back to Main Menu    - Return to main menu"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    read -p "Enter choice [0-4]: " stats_choice
    
    case $stats_choice in
        1) 
            if [ -f "$BOT_DIR/live-stats.sh" ]; then
                "$BOT_DIR/live-stats.sh"
            else
                echo -e "${RED}❌ live-stats.sh not found!${NC}"
                sleep 2
            fi
            ;;
        2) 
            if [ -f "$BOT_DIR/stats-simple.sh" ]; then
                "$BOT_DIR/stats-simple.sh"
            else
                echo -e "${RED}❌ stats-simple.sh not found!${NC}"
                sleep 2
            fi
            ;;
        3) 
            if [ -f "$BOT_DIR/stats-summary.sh" ]; then
                "$BOT_DIR/stats-summary.sh"
                read -p "Press Enter to continue..."
            else
                echo -e "${RED}❌ stats-summary.sh not found!${NC}"
                sleep 2
            fi
            ;;
        4) 
            if [ -f "$BOT_DIR/live-monitor.sh" ]; then
                "$BOT_DIR/live-monitor.sh"
            else
                echo -e "${RED}❌ live-monitor.sh not found!${NC}"
                sleep 2
            fi
            ;;
        0) 
            return
            ;;
        *)
            echo -e "${RED}❌ Invalid option!${NC}"
            sleep 1
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [0-10]: " choice
    case $choice in
        1) start_bot ;;
        2) stop_bot ;;
        3) restart_bot ;;
        4) bot_status ;;
        5) view_logs ;;
        6) view_stats ;;
        7) edit_config ;;
        8) update_bot ;;
        9) install_service ;;
        10) live_stats_menu ;;
        0) 
            echo -e "${GREEN}👋 Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option!${NC}"
            sleep 1
            ;;
    esac
done
