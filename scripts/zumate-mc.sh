#!/bin/bash
# Internal initialization script for Minecraft servers running on Zumate nodes, with embedded playit.gg support.
# by @zayaanar on Discord or @userandaname on GitHub.

playit_status=$1
server_port=$2
query_port=$2
jarfile=$3
hostname=$4
memory=$5
software=$6

agentURL="https://github.com/playit-cloud/playit-agent/releases/download/v0.15.23/playit-linux-amd64"
container="/home/container"
zumate="/home/container/zumate"
playit_pid=$(pgrep -f playit)
vernum="v1.0.8p"

if [ ! -z "$playit_pid" ]; then
    kill "$playit_pid"
fi

if [ "$playit_status" = 0 ]; then
    clear
    echo "Zumate Launcher - $vernum - @zayaanar"
    echo "--------------------------------------------------------------------------------"
    echo "playit.gg integration has been disabled."
    echo "Starting Minecraft..."
    echo "--------------------------------------------------------------------------------"
    echo " "
else
    clear
    echo "Zumate Launcher - $vernum - @zayaanar"
    echo "--------------------------------------------------------------------------------"
    echo " "
    echo "Verifying playit-agent, please wait..."
    echo "--------------------------------------------------------------------------------"
    curl -Lo playit $agentURL
    chmod +x playit
    mv $container/playit $zumate/playit
    cd $zumate
    echo "--------------------------------------------------------------------------------"
    echo " "

    if [ ! -f playit.toml ]; then
        clear
        echo "Zumate Launcher - $vernum"
        echo "--------------------------------------------------------------------------------"
        echo " "
        echo "playit.gg needs to be configured to remotely connect to your server."
        echo "Otherwise, turn off playit.gg integration to skip this."
        echo "Once Setup finishes, restart your server to continue."
        echo "For help, contact @zayaanar on Discord."
        echo " "
        echo "--------------------------------------------------------------------------------"
        echo "Grabbing setupURL..."
        echo "Please wait..."
        echo "--------------------------------------------------------------------------------"

        cd $zumate
        ./playit --secret_path=$zumate/playit.toml > setupLogs.log 2>&1 &

        while true; do
            url=$(grep -o 'https://[^ ]*' setupLogs.log)

            if [[ -n "$url" ]]; then
                clear
                echo "Zumate Launcher - $vernum"
                echo "--------------------------------------------------------------------------------"
                echo " "
                echo "playit.gg needs to be configured to remotely connect to your server."
                echo "Otherwise, turn off playit.gg integration to skip this."
                echo "Once Setup finishes, restart your server to continue."
                echo "For help, contact @zayaanar on Discord."
                echo " "
                echo "--------------------------------------------------------------------------------"
                echo "To setup this server with playit.gg, please visit $url"
                echo "Setup will continue once you've connected this server with playit.gg."
                echo "--------------------------------------------------------------------------------"
                break
            fi

            sleep 1
        done

        while true; do
            tunnelFound=$(grep -o 'TUNNELS' setupLogs.log)

            if [[ -n "$tunnelFound" ]]; then
                clear
                echo "Zumate Launcher - $vernum"
                echo "--------------------------------------------------------------------------------"
                echo " "
                echo "playit.gg needs to be configured to remotely connect to your server."
                echo "Otherwise, turn off playit.gg integration to skip this."
                echo "Once Setup finishes, restart your server to continue."
                echo "For help, contact @zayaanar on Discord."
                echo " "
                echo "--------------------------------------------------------------------------------"
                echo "Almost there! Create a minecraft-java tunnel pointing to 127.0.0.1:$server_port."
                echo "Waiting for valid tunnel..."
                echo "--------------------------------------------------------------------------------"
                break
            fi

            sleep 1
        done

        while true; do
            tunnelVerified=$(grep -o "127.0.0.1:$server_port" setupLogs.log)

            if [[ -n "$tunnelVerified" ]]; then
                clear
                echo "Zumate Launcher - $vernum"
                echo "--------------------------------------------------------------------------------"
                echo " "
                echo "playit.gg needs to be configured to remotely connect to your server."
                echo "Otherwise, turn off playit.gg integration to skip this."
                echo "Once Setup finishes, restart your server to continue."
                echo "For help, contact @zayaanar on Discord."
                echo " "
                echo "--------------------------------------------------------------------------------"
                echo "Tunnel verified! Setup is now complete."
                echo "Type anything in console to restart the server and finish setup."
                echo "--------------------------------------------------------------------------------"
                break
            fi

            sleep 1
        done

        read -p ""
        clear
        echo "Zumate Launcher - $vernum"
        echo "--------------------------------------------------------------------------------"
        echo " "
        echo "playit.gg needs to be configured to remotely connect to your server."
        echo "Otherwise, turn off playit.gg integration to skip this."
        echo "Once Setup finishes, restart your server to continue."
        echo "For help, contact @zayaanar on Discord."
        echo " "
        echo "--------------------------------------------------------------------------------"
        echo "Starting Minecraft..."
        echo "--------------------------------------------------------------------------------"
        echo " "
    else
        ./playit --secret_path=$zumate/playit.toml 1>/dev/null 2>/dev/null &
        clear
        echo "Zumate Launcher - $vernum"
        echo "--------------------------------------------------------------------------------"
        echo "Verified and started playit-agent!"
        echo "Starting Minecraft..."
        echo "--------------------------------------------------------------------------------"
        echo " "
    fi
fi

cd $container

if [ "$software" = "PaperMC" ]; then
    java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar $jarfile
elif [ "$software" = "Forge" ]; then
    java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true $( [[  ! -f unix_args.txt ]] && printf %s "-jar $jarfile" || printf %s "@unix_args.txt" )
elif [ "$software" = "Fabric" ]; then
    java -Xms128M -Xmx"$memory"M -jar $jarfile
fi