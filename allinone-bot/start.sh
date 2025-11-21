#!/bin/bash
pkill -f instagram_bot.py
nohup python3 instagram_bot.py > output.log 2>&1 &
sleep 2
if pgrep -f instagram_bot.py > /dev/null; then
    echo "✅ Bot started!"
    echo "📊 Logs: tail -f output.log"
else
    echo "❌ Failed!"
fi
