#!/bin/sh
dir="$PWD"
lutriswinepath="/home/$USER/.local/share/lutris/runners/wine"

# change version number to downgrade to another old build
winever="8-17"

# fsync support (only work if you have a kernel with futex sync support)
# put 0 if you want to disable fsync ()
fsync=1

# use for dxvk
dxvkver=$(curl --silent "https://api.github.com/repos/doitsujin/dxvk/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | cut -d'v' -f2)

# check wine install
wineinstall=false

# create new script
script=$(cat <<EOF
#!/bin/sh
WINEPREFIX=$dir/.wine WINEFSYNC=$fsync $dir/lutris-GE-Proton$winever-x86_64/bin/wine Dofus.exe --port=\$ZAAP_PORT --gameName=\$ZAAP_GAME --gameRelease=\$ZAAP_RELEASE --instanceId=\$ZAAP_INSTANCE_ID --hash=\$ZAAP_HASH --canLogin=\$ZAAP_CAN_AUTH > /dev/null 2>&1
exit \$?
EOF
)

# user action to perform
action="$1"

case "$action" in
configure)
  ;;
dxvk)
  ;;
*)
  echo "Action inconnue: $action"
  echo "Usage: $0 [configure|dxvk]"
  exit 1
esac

# install wine prefix
configure() {
  if [ ! -d "$dir/lutris-GE-Proton$winever-x86_64" ]; then
    #clean old wine
    rm -rf $dir/lutris-GE-Proton*

    #check lastest version
    releasever=$(curl --silent "https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | cut -d'v' -f2)
    filename=$(curl --silent "https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest" | grep -Po '"name": "\K.*?(?=")' | tail -n1)

    #exclude LoL release
    checktype=${releasever:0:9}
    if [ $checktype == "GE-Proton" ]; then
        echo "Wine GE: téléchargement de la version $releasever ..."
        wget -q https://github.com/GloriousEggroll/wine-ge-custom/releases/download/$releasever/$filename
        tar -xf $filename
        rm $filename
        wineinstall=true
        echo "Wine GE: install ok ($releasever)"
    fi
  else
    echo "Wine GE: déjà à jour ($winever)"
  fi

  if [ "$wineinstall" = true ]; then
    # create wine environment
    if [ ! -d ".wine" ]; then
        mkdir .wine
    fi

    # backup current script
    if [ ! -f "zaap-start.old" ]; then
      cp zaap-start.sh zaap-start.old
    fi

    echo "$script" | tee zaap-start.sh

    # add execute to script
    chmod +x zaap-start.sh

    #./zaap-start.sh
  fi

  # fix game won't start after update
  if [ -f ".wine/.update-timestamp" ]; then
      rm .wine/.update-timestamp
  fi
}

# configure dxvk
dxvk() {
    wget https://github.com/doitsujin/dxvk/releases/download/v$dxvkver/dxvk-$dxvkver.tar.gz
    tar -xf dxvk-$dxvkver.tar.gz
    mv -f $dir/dxvk-$dxvkver/x32/* $dir/.wine/drive_c/windows/system32/
    mv -f $dir/dxvk-$dxvkver/x64/* $dir/.wine/drive_c/windows/syswow64/
    rm dxvk-$dxvkver.tar.gz
    rm -r dxvk-$dxvkver
}

$action
