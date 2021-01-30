#!/bin/sh
dir="$PWD"

# change version number to downgrade to another old build
winever="6.0"

# use for dxvk
dxvkver="1.7.3"

# create new script
script=$(cat <<EOF
#!/bin/sh
WINEPREFIX=$dir/.wine $dir/lutris-$winever-x86_64/bin/wine Dofus.exe --port=\$ZAAP_PORT --gameName=\$ZAAP_GAME --gameRelease=\$ZAAP_RELEASE --instanceId=\$ZAAP_INSTANCE_ID --hash=\$ZAAP_HASH --canLogin=\$ZAAP_CAN_AUTH > /dev/null 2>&1
exit \$?
EOF
)

# user action to perform
action="$1"

# install wine prefix
if [ "$action" == "--install" ]; then
    # download lutris wine build
    if [ ! -d "lutris-$winever-x86_64" ]; then
        wget https://github.com/lutris/wine/releases/download/lutris-$winever/wine-lutris-$winever-x86_64.tar.xz
        tar -xf wine-lutris-$winever-x86_64.tar.xz
        rm wine-lutris-$winever-x86_64.tar.xz
    fi

    # create wine environment
    if [ ! -d ".wine" ]; then
        mkdir .wine
    fi

    # fix game won't start after update
    if [ -f ".wine/.update-timestamp" ]; then
        rm .wine/.update-timestamp
    fi

    # backup current script
    if [ ! -f "zaap-start.old" ]; then
        cp zaap-start.sh zaap-start.old
    fi

    echo "$script" | tee zaap-start.sh

    # add execute to script
    chmod +x zaap-start.sh

    ./zaap-start.sh
fi

# configure dxvk
if [ "$action" == "--dxvk" ]; then
    wget https://github.com/doitsujin/dxvk/releases/download/v$dxvkver/dxvk-$dxvkver.tar.gz
    tar -xf dxvk-$dxvkver.tar.gz
    WINEPREFIX=$dir/.wine $dir/dxvk-$dxvkver/setup_dxvk.sh install
    rm dxvk-$dxvkver.tar.gz
fi