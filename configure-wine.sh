#!/bin/sh
currentpath="$PWD"
winever="5.7-8"

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

# backup current script
if [ ! -f "zaap-start.old" ]; then
    mv zaap-start.sh zaap-start.old
else
    rm zaap-start.sh
fi

# create new script
touch zaap-start.sh
echo "#!/bin/sh" >> zaap-start.sh
echo "WINEPREFIX=$currentpath/.wine $currentpath/lutris-$winever-x86_64/bin/wine Dofus.exe --port=\$ZAAP_PORT --gameName=\$ZAAP_GAME --gameRelease=\$ZAAP_RELEASE --instanceId=\$ZAAP_INSTANCE_ID --hash=\$ZAAP_HASH --canLogin=\$ZAAP_CAN_AUTH > /dev/null 2>&1" >> zaap-start.sh
echo "exit \$?" >> zaap-start.sh

# add execute to script
chmod +x zaap-start.sh