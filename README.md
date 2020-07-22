## Dofus avec wineprefix

Cette version de Wine est créée par Lutris et inclue les patchs proton de Valve ainsi que d'autres fix créés par la communauté.

Ce script corrige :
- le problème du jeu bloqué à 56% au lancement
- le plantage de wineserver de temps en temps (jeu figé)
- jeu plus fluide

NB: Le script sera peut-être à relancer après les MAJ.

### Prérequis
- winetricks (souvent déjà installé)

**Debian / Ubuntu**
```$ sudo apt-get install winetricks```

**Arch / Manjaro**
```$ sudo pacman -S winetricks```

### Utilisation
- copier le script dans le répertoire du jeu, par défaut : ~/.config/Ankama/zaap/dofus (ctrl+h pour voir les fichiers cachés)
- ouvrir un terminal et lancer ./configure-wine.sh
- patienter 
- lancer le jeu via Ankama Launcher :)