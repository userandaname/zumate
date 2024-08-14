#!/bin/bash
# Startup command for Zumate nodes running Minecraft.
# by @zayaanar on Discord or @userandaname on GitHub

mkdir -p /home/container/zumate && curl -Lo /home/container/zumate/zumate-mc.sh https://raw.githubusercontent.com/userandaname/zumate/main/scripts/zumate-mc.sh && mv /home/container/zumate/zumate-mc.sh /home/container/zumate/startup.sh && chmod +x /home/container/zumate/startup.sh && exec /home/container/zumate/startup.sh {{ PLAYIT_STATUS }} {{ server.build.default.port }} {{ SERVER_JARFILE }} {{ server.hostname }}