# Dofus avec wineprefix

Cette version de Wine est créée par Lutris et inclue les patchs proton de Valve ainsi que d'autres fix créés par la communauté.

Ce script corrige :
- le problème du jeu bloqué à 56% au lancement
- le plantage de wineserver de temps en temps (jeu figé)
- jeu plus fluide

NB: Le script doit être relancé après chaque MAJ !

## Utilisation
### Wine
- copier le script dans le répertoire du jeu, par défaut : ~/.config/Ankama/zaap/dofus (ctrl+h pour voir les fichiers cachés)
- ouvrir un terminal et lancer ```./configure-wine.sh --install```
- patienter puis fermer le jeu
- relancer le jeu via Ankama Launcher :)

### DXVK
Si votre matériel est compatible avec vulkan, le script permet de configurer DXVK pour Dofus. 
- fermer le jeu 
- lancer ```./configure-wine.sh --dxvk```