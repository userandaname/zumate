#!/bin/bash
# Internal initialization script for Zumate nodes running Minecraft, with embedded playit.gg support.
# by @zayaanar on Discord or @userandaname on GitHub

playit_status=$1
server_port=$2
query_port=$2
jarfile=$3
hostname=$4

container="/home/container"
zumate="/home/container/zumate"
playit_pid=$(pgrep -f playit)
vernum="v1.0.2p"

if [ ! -z "$playit_pid" ]; then
    kill "$playit_pid"
fi

if [ "$playit_status" = false ]; then
    clear
    echo "playit.gg integration - $vernum - @zayaanar"
    echo "------------------------------------------------------------------------------"
    echo "playit.gg integration has been disabled. Skipping installation sequence..."
    echo "------------------------------------------------------------------------------"
    echo " "
else
    clear
    echo "playit.gg integration - $vernum - @zayaanar"
    echo "------------------------------------------------------------------------------"
    echo " "
    echo "Verifying authenticity of playit-agent..."
    echo "------------------------------------------------------------------------------"
    curl -Lo playit https://github.com/playit-cloud/playit-agent/releases/download/v0.15.19/playit-linux-amd64
    chmod +x playit
    mv $container/playit $zumate/playit
    cd $zumate
    echo "------------------------------------------------------------------------------"
    echo " "

    if [ ! -f playit.toml ]; then
        clear
        echo "playit.gg integration - $vernum - @zayaanar"
        echo "------------------------------------------------------------------------------"
        echo " "
        echo "playit.gg needs to be configured to remotely connect to your server."
        echo "Otherwise, turn off playit.gg integration to skip this."
        echo "Once Setup finishes, restart your server to continue."
        echo "For help, contact @zayaanar on Discord."
        echo " "
        echo "------------------------------------------------------------------------------"
        echo "Grabbing setupURL..."
        echo "Please wait..."
        echo "------------------------------------------------------------------------------"

        cd $zumate
        ./playit --secret_path=$zumate/playit.toml > setupLogs.log 2>&1 &

        while true; do
            url=$(grep -o 'https://[^ ]*' setupLogs.log)

            if [[ -n "$url" ]]; then
                clear
                echo "playit.gg integration - $vernum - @zayaanar"
                echo "------------------------------------------------------------------------------"
                echo " "
                echo "playit.gg needs to be configured to remotely connect to your server."
                echo "Otherwise, turn off playit.gg integration to skip this."
                echo "Once Setup finishes, restart your server to continue."
                echo "For help, contact @zayaanar on Discord."
                echo " "
                echo "------------------------------------------------------------------------------"
                echo "To setup this server with playit.gg, please visit $url"
                echo "Setup will continue once you've connected this server with playit.gg."
                echo "------------------------------------------------------------------------------"
                break
            fi

            sleep 1
        done

        while true; do
            tunnelFound=$(grep -o 'TUNNELS' setupLogs.log)

            if [[ -n "$tunnelFound" ]]; then
                clear
                echo "playit.gg integration - $vernum - @zayaanar"
                echo "------------------------------------------------------------------------------"
                echo " "
                echo "playit.gg needs to be configured to remotely connect to your server."
                echo "Otherwise, turn off playit.gg integration to skip this."
                echo "Once Setup finishes, restart your server to continue."
                echo "For help, contact @zayaanar on Discord."
                echo " "
                echo "------------------------------------------------------------------------------"
                echo "Almost there! Create a minecraft-java tunnel pointing to 127.0.0.1:$server_port."
                echo "Waiting for valid tunnel..."
                echo "------------------------------------------------------------------------------"
                break
            fi

            sleep 1
        done

        while true; do
            tunnelVerified=$(grep -o "127.0.0.1:$server_port" setupLogs.log)

            if [[ -n "$tunnelVerified" ]]; then
                clear
                echo "playit.gg integration - $vernum - @zayaanar"
                echo "------------------------------------------------------------------------------"
                echo " "
                echo "playit.gg needs to be configured to remotely connect to your server."
                echo "Otherwise, turn off playit.gg integration to skip this."
                echo "Once Setup finishes, restart your server to continue."
                echo "For help, contact @zayaanar on Discord."
                echo " "
                echo "------------------------------------------------------------------------------"
                echo "Tunnel verified! Setup is now complete."
                echo "Type anything in console to restart the server and finish setup."
                echo "------------------------------------------------------------------------------"
                break
            fi

            sleep 1
        done

        read -p ""
        clear
        echo "playit.gg integration - $vernum - @zayaanar"
        echo "------------------------------------------------------------------------------"
        echo " "
        echo "playit.gg needs to be configured to remotely connect to your server."
        echo "Otherwise, turn off playit.gg integration to skip this."
        echo "Once Setup finishes, restart your server to continue."
        echo "For help, contact @zayaanar on Discord."
        echo " "
        echo "------------------------------------------------------------------------------"
        echo "Finishing Setup..."
        echo "------------------------------------------------------------------------------"
        echo " "
    else
        ./playit --secret_path=$zumate/playit.toml 1>/dev/null 2>/dev/null &
    fi
fi

cd $container
java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar $jarfile