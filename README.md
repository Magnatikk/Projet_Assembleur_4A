# Keylogger MASM pour Windows 10

Ce projet avait pour but de créer un Keylogger en MASM (Microsoft Assembler) sur Windows.

## Objectifs primaires
Le programme se déplace et s'éxécute au branchement de la clé usb, dans le dossier Appdata/Startup (dossier caché)

Création d'un fichier txt dans un dossier caché

Ecriture dans le fichier des touches sans ouverture du fichier visible

Récupérer les différentes touches / Touches spéciales et touches des lettres 

## Objectifs scondaires

Persistence

Envoi ftp du fichier

## Défis

Apprendre le fonctionnement du MASM

Très peu de documentation disponible 

La récupération des touches de manière fluide

Trouver un éditeur de code MASM qui marche 


## Fichiers présents :

- persistence.ps1 (script permettant de lancer le programme au démarrage de Windows)
- hook.asm (programme utilisant le hook censé repérer les touches tapées)
- KEYLOGavecCtrlC (Keylog qui marche tant que le focus est sur le cmd, ne pas faire attention au nom)
- touchesspéOK (Keylog qui marche uniquement sur les touches spéciales )
