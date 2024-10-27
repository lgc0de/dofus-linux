#!/bin/sh
dir="$PWD"
lutriswinepath="/home/$USER/.local/share/lutris/runners/wine"

# change version number to downgrade to another old build
winever="8-26"

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
WINEPREFIX=$dir/.wine WINEFSYNC=$fsync $dir/wine-ge-$winever-x86_64/bin/wine Dofus.exe --port=\$ZAAP_PORT --gameName=\$ZAAP_GAME --gameRelease=\$ZAAP_RELEASE --instanceId=\$ZAAP_INSTANCE_ID --hash=\$ZAAP_HASH --canLogin=\$ZAAP_CAN_AUTH > /dev/null 2>&1
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
  if [ -d $lutriswinepath ]; then
    if [ -d "$lutriswinepath/wine-ge-$winever-x86_64" ]; then
      if [ ! -d "$dir/wine-ge-$winever-x86_64" ]; then
        ln -s $lutriswinepath/wine-ge-$winever-x86_64 $dir
        wineinstall=true
      fi
      echo "Wine correctement installé"
    else
      echo "Télécharger wine depuis Lutris, version : wine-ge-$winever"
      echo "Puis relancer le script"
    fi
  else
    # download lutris wine build
    if [ ! -d "$dir/wine-ge-$winever-x86_64" ]; then
      #check lastest version
      wget -q https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton$winever/wine-lutris-GE-Proton$winever-x86_64.tar.xz
      tar -xf $dir/wine-lutris-GE-Proton$winever-x86_64.tar.xz
      mv $dir/lutris-GE-Proton$winever-x86_64 $dir/wine-ge-$winever-x86_64
      rm $dir/wine-lutris-GE-Proton$winever-x86_64.tar.xz
      wineinstall=true
      echo "Wine ge: install ok ($winever)"
    fi
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
