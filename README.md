# Dofus Linux
## Standalone wineprefix

Le script utilise la version Wine de Lutris qui inclue les patchs proton de Valve ainsi que d'autres fix créés par la communauté.

Ajouts/corrections:
- le problème du jeu bloqué à 56% au lancement
- le plantage de wineserver de temps en temps (jeu figé)
- jeu plus fluide
- support de DXVK

NB: Le script doit être relancé après chaque MAJ !

## Utilisation
### Wine
- copier le script dans le répertoire du jeu, par défaut : ~/.config/Ankama/Dofus (ctrl+h pour voir les fichiers cachés)
- ouvrir un terminal et lancer ```./dofus-linux.sh configure```
- patienter puis lancer le jeu via Ankama Launcher :)

### DXVK
Si votre matériel est compatible avec vulkan, le script permet de configurer DXVK pour Dofus. 
- fermer le jeu 
- lancer ```./dofus-linux.sh dxvk```
- relancer le jeu via Ankama Launcher :)