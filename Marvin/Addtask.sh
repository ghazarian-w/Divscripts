#!/bin/bash

source ~/Ressources/Divscripts/timersVariables

#Main tagging function
tag_current() {

  type=( "Inbox" "Organisation" "Menage" "Achats" "Administration" "Boulot" "Hobbys" "Slam" "Game_design" "Graphisme" "Brainshit" "Watchlist" "Bricolage" "Pyrotechnie" "Jeux_Videos" "Chanson" "Mangas" "Biblio" "Jobbing" "Medical" "Ordinateur" "Onglets" "Scripting" "Programming" "Installations" "Files" "Recherches" "Vente" "Soin")

  device=( "Any" "NoDevice" "Gluttony" "Vanity" "Sloth" "Despair")
  place=( "Anywhere" "Maison" "Ville" "Boulot")
  share=( "Unshareable" "InPerson" "Shareable" "Depending")


  #avoids repeating a reward over multiple tasks in a list
  coins=""

  cate=$(zenity --list "${type[@]}" "Projet" --column "" --text "$taskname" --title="Category" $zenityTall)
  if [ "$cate" == "Projet" ]; then
    cate=$(zenity --list "${projects[@]}" --column "" --text "$taskname" --title="Category" $zenityTall)
  fi
  appareil=$(zenity --list "${device[@]}" --column "" --text "$taskname" --title="Appareil" $zenitySmall)
  location=$(zenity --list "${place[@]}" --column "" --text "$taskname" --title="Location" $zenitySmall)
  partage=$(zenity --list "${share[@]}" --column "" --text "$taskname" --title="Partage" $zenitySmall)
  temps=$(zenity --title "Temps estimé" --entry --text "$taskname")
  reward=$(zenity --title "Récompense" --entry --text "$taskname")
  if [[ ! -z "$reward" ]]; then
  coins=" \$$reward"
  fi
  selection=$(zenity --list "Urgent" "Si possible" "Peut attendre" "Pas le feu au lac" --column "" --text "$taskname" --title="Priorité" $zenitySmall)
  case "$selection" in
  "Urgent")
  priorite=" *p1"
  ;;
  "Si possible")
  priorite=" *p2"
  ;;
  "Peut attendre")
  priorite=" *p3"
  ;;
  "Pas le feu au lac")
  priorite=""
  ;;
  esac

  extra=""

  while true; do
    selection=$(zenity --list "Rien" "Ajouter à la liste du jour" "Ajouter pour demain" "Ajouter pour plus tard" "SuperImportant" "Excluded" "Delayed" "Done" "Avec une note" --column "" --text "$taskname" --title="En plus" $zenityTall)
    case "$selection" in
      "Rien")
        break
        ;;
      "Ajouter à la liste du jour")
        extra=$extra" +today"
        ;;
      "Ajouter pour demain")
        extra=$extra" +tomorrow"
        ;;
      "Ajouter pour plus tard")
        detail=$(zenity --title "Dans combien de jours ?" --entry --text "$taskname")
        extra=$extra" +"$detail"d"
        ;;
      "Avec une note")
        detail=$(zenity --title "Note à ajouter" --entry --text "$taskname")
        extra=$extra" --"$detail
        ;;
      "SuperImportant")
        extra=$extra" @SuperImportant"
        ;;
      "Excluded")
        extra=$extra" @Excluded"
        ;;
      "Delayed")
        extra=$extra" @Delayed"
        ;;
      "Done")
        extra=$extra" @Done"
        ;;
    esac
  done
    tagging="#$cate @Untouched @$appareil @$location @$partage ~$temps$priorite$extra$coins"
}


# Define functions to handle different modes
processList() {
    echo "Processing list"

    # Read the file and process each line
    while IFS= read -r line; do
        taskname="$line"
        tag_current
        ~/Ressources/marvin-cli-linux add "$line $tagging"
    done < "$list_file"
}


processListSimilar() {
    echo "Processing list"

    taskname=$(head -n 1 $list_file)
    taskname="Exemple de tâche : $taskname"
    tag_current
    line="$1"

    # Read the file and process each line
    while IFS= read -r line; do
        ~/Ressources/marvin-cli-linux add "$line $tagging"
    done < "$list_file"

}

processSelection() {
    echo "Processing selection"
    taskname=$(xsel)
    tag_current
    ~/Ressources/marvin-cli-linux add "$taskname $tagging"
}

processPrompt() {
    echo "Processing prompt"
    taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    while [[ ! -z "$taskname" ]]; do
        tag_current
        ~/Ressources/marvin-cli-linux add "$taskname $tagging"
        taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    done
}

processUnique () {
    taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    tag_current
    ~/Ressources/marvin-cli-linux add "$taskname $tagging"
}

processProject () {
    taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    tag_current
    ~/Ressources/marvin-cli-linux add project "$taskname $tagging"
}

extractJson () {
  most_recent_file=$(ls -t $archiveMarvinFolder/AmazingMarvinBackup_*.json.lzma | head -n 1)
  xz -dk "$most_recent_file"
  jsonMarvin=$(ls -t $archiveMarvinFolder/*.json | head -n 1)

  echo "$archiveMarvinFolder"
  echo "$most_recent_file"
  echo "$jsonMarvin"
  

  # Utiliser mapfile/readarray pour stocker la sortie dans le tableau
  readarray -t projects < <(jq '.[] | select(.type == "project" and (.done == false or .done == null) and .backburner == false and (.recurring == false or .recurring == null) ) | .title' $jsonMarvin)

  rm $archiveMarvinFolder/*.json
  echo "${projects[@]}"


}

# Main script

# Check connection and exits if not online
check_internet
# Créer un tableau pour stocker les projets actuels
declare -a projects
extractJson

echo "${projects[@]}"

if $connected; then
  # Parse command-line options
  case "$1" in
    -l) processList ;;
    -L) processListSimilar ;;
    -s) processSelection ;;
    -p) processPrompt ;;
    -u) processUnique ;;
    -P) processProject ;;
  esac
fi
