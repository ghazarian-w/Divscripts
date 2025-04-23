#!/bin/bash

#Petit script pour prendre une note que j'ai fait générer. Rien de bien complexe.

# Demande à l'utilisateur de saisir une note avec Zenity
note=$(zenity --entry --title "Ajouter une note" --text "Saisissez votre note :")

# Vérifie si l'utilisateur a appuyé sur "OK" ou a saisi une note
if [ $? -eq 0 ] && [ -n "$note" ]; then
    # Spécifie le chemin complet du fichier où vous souhaitez ajouter la note
    fichier="~/Ressources/notes.txt"

    # Ajoute la note à la prochaine ligne du fichier
    echo "$note" >> "$fichier"
else
    # Affiche un message d'annulation si aucune note n'a été saisie
    zenity --info --title "Annulé" --text "Aucune note n'a été ajoutée."
fi