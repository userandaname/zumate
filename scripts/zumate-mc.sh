#!/bin/bash
# Internal intialization script for Zumate nodes running Minecraft.
# by @zayaanar on Discord or @userandaname on GitHub

PLAYIT_PID=$(pgrep -f playit)

if [ ! -z "$PLAYIT_PID" ]; then
    kill "$PLAYIT_PID"
fi

if [ {{PLAYIT_STATUS}} = false ]; then
    echo "playit.gg has been disabled by the end-user. Skipping installation sequence..."
else
    if [ ! -f playit ]; then
        curl -Lo playit https://github.com/playit-cloud/playit-agent/releases/download/v0.15.19/playit-linux-amd64
        chmod +x playit
    fi

    if [ ! -f playit.toml ]; then
        clear
        echo "playit.gg needs to be configured to remotely connect to your server."
        echo "Ensure that your new tunnel is set to 127.0.0.1:"{{server.build.default.port}}
        echo "For help, contact @zayaanar on Discord."
        echo "Type anything in console to continue..."
        read choice
        ./playit
    else
        ./playit &
    fi
fi

java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar {{SERVER_JARFILE}}
