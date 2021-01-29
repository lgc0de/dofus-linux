#!/bin/sh
currentpath="$PWD"

# change version number to downgrade to another old build
winever="6.0"

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

# create new script
script=$(cat <<EOF
#!/bin/sh
WINEPREFIX=$currentpath/.wine $currentpath/lutris-$winever-x86_64/bin/wine Dofus.exe --port=\$ZAAP_PORT --gameName=\$ZAAP_GAME --gameRelease=\$ZAAP_RELEASE --instanceId=\$ZAAP_INSTANCE_ID --hash=\$ZAAP_HASH --canLogin=\$ZAAP_CAN_AUTH > /dev/null 2>&1
exit \$?
EOF
)

echo "$script" | tee zaap-start.sh

# add exec to script
chmod +x zaap-start.sh
