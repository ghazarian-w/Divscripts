#!/bin/bash

source $scriptsFolder/SharedFunctions
scoreTask=60

#Main tagging function
tag_current() {

  type=( "Inbox" "Ordinateur" "Onglets" "Scripting" "Programming" "Installations" "Fichiers" "Recherches" "Organisation" "Menage" "Achats" "Administration" "Soin" "Boulot" "Bricolage" "Hobbys" "Slam" "Game_design" "Graphisme" "Articles" "Pyrotechnie" "Jeux_Videos" "Chanson" "Mangas" "Biblio" "Social" "Vente")

  device=( "AnyComputer" "NoDevice" "Gluttony" "Vanity" "Greed" "Despair")
  place=( "Anywhere" "Maison" "Ville" "Boulot" "HS")
  share=( "Unshareable" "InPerson" "Shareable" "Depending")

  #avoids repeating a tag over multiple tasks in a list
  coins=""; cate=""; appareil=""; location=""; partage=""; temps=""; priorite=""; extra=""

  cate=$(zenity --list "${type[@]}" "Projet" --column "" --text "$taskname" --title="Category" $zenityTall)
  if [ "$cate" == "Projet" ]; then
    cate=$(zenity --list "${projects[@]}" --column "" --text "$taskname" --title="Category" $zenityTall)
  fi
  if [ "$cate" == "Organisation" ]; then
    appareil="AnyComputer"; location="Anywhere"; partage="Shareable"
  fi
  if [ "$cate" == "Onglets" ]; then
    appareil="AnyComputer"; location="Anywhere"; partage="Unshareable"; temps="20"; priorite=" *p3"
  fi
  if [ "$cate" == "Scripting" ]; then
    appareil="Gluttony"; location="Maison"; partage="Shareable"
  fi
  if [[ "$cate" == "Recherches" ]]; then
    partage="Unshareable"
  fi
  if [[ "$cate" == "Articles" || "$cate" == "Slam" ]]; then
    appareil="AnyComputer"; location="Anywhere"; partage="Unshareable"
  fi
  if [[ "$cate" == "Boulot" || "$cate" == "Administration" ]]; then
    partage="Shareable"
  fi
  if [[ "$cate" == "Bricolage" || "$cate" == "Menage" ]]; then
    location="Maison"
  fi
  if [ "$cate" == "Graphisme" ]; then
    appareil="Gluttony"
  fi


  if [[ -z "$appareil" ]]; then
  appareil=$(zenity --list "${device[@]}" --column "" --text "$taskname" --title="Appareil" $zenitySmall)
  fi
  if [[ "$appareil" == "Gluttony" || "$appareil" == "Despair" ]]; then
    location="Maison"
  fi
  if [[ "$appareil" == "Vanity" || "$appareil" == "Greed" ]]; then
    location="Anywhere"
  fi

  if [[ -z "$location" ]]; then
  location=$(zenity --list "${place[@]}" --column "" --text "$taskname" --title="Location" $zenitySmall)
  fi

  if [[ -z "$partage" ]]; then
  partage=$(zenity --list "${share[@]}" --column "" --text "$taskname" --title="Partage" $zenitySmall)
  fi

  if [ "$partage" == "Depending" ]; then
    extra=$extra" @Delayed"
  fi

  if [[ -z "$temps" ]]; then
    temps=$(zenity --title "Temps estimé" --entry --text "$taskname")
  fi

  if [[ -z "$priorite" ]]; then
    selection=$(zenity --list "ASAP" "Si possible" "Peut attendre" "Pas le feu au lac" --column "" --text "$taskname" --title="Urgence" $zenitySmall)
    case "$selection" in
      "ASAP")
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
  fi

  while true; do
    selection=$(zenity --list "Rien" "Récompense particulière" "Ajouter à la liste du jour" "Ajouter pour demain" "Ajouter pour plus tard" "SuperImportant" "Excluded" "Delayed" "Done" "Avec une note" --column "" --text "$taskname" --title="En plus" $zenityTall)
    case "$selection" in
      "Rien")
        break
        ;;
      "Récompense particulière")
        reward=$(zenity --title "Récompense" --entry --text "$taskname")
        if [[ ! -z "$reward" ]]; then
          coins=" \$$reward"
        fi
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
        break
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
        addToTemp $scoreTask
    done < "$list_file"
}


processListSimilar() {
    echo "Processing list"

    taskname=$(head -n 1 $list_file)
    taskname="Exemple de tâche : $taskname"
    tag_current

    # Read the file and process each line
    while IFS= read -r line; do
        sleep 2
        ~/Ressources/marvin-cli-linux add "$line $tagging"
        addToTemp $scoreTask
    done < "$list_file"

}

processSelection() {
    echo "Processing selection"
    taskname=$(xsel)
    tag_current
    ~/Ressources/marvin-cli-linux add "$taskname $tagging"
    addToTemp $scoreTask
}

processPrompt() {
    echo "Processing prompt"
    taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    while [[ ! -z "$taskname" ]]; do
        tag_current
        ~/Ressources/marvin-cli-linux add "$taskname $tagging"
        echo $(($timeTemp + $scoreTask)) > $tempCount
        taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    done
}

processUnique () {
    taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    tag_current
    ~/Ressources/marvin-cli-linux add "$taskname $tagging"
    addToTemp $scoreTask
}

processProject () {
    taskname=$(zenity --title "Nom de tâche" --entry --text "La tache apparaitra dans Marvin.")
    tag_current
    ~/Ressources/marvin-cli-linux add project "$taskname $tagging"
    addToTemp $scoreTask
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
