#!/bin/bash

source $scriptsFolder/SharedFunctions

#Define a default for all variables needed later
sortedSize=0
toSortSize=0
filesToSort=0
spToSort=0
fProjects=0
aProjects=0
finTasks=0
finNRTasks=0
NRTasks=0
SNRTasks=0
ActTasks=0
sortedMusic=0
toSortMusic=0

#Variables needed by the rest
europeanDate=$(date +"%d/%m/%Y")
europeanDateFile=$(date +"%d-%m-%Y")

#Extract most recent archive from Amazing Marvin

echo "Extracting Marvin backup..."
most_recent_file=$(ls -t $archiveMarvinFolder/AmazingMarvinBackup_*.json.lzma | head -n 1)
xz -dk "$most_recent_file"
jsonMarvin=$(ls -t $archiveMarvinFolder/*.json | head -n 1)

#Marvin tasks from json extraction

echo "Extracting data from Marvin json..."
#Finished projects
fProjects=$(jq '.[] | select(.type == "project" and .done == true and (.recurring == false or .recurring == null) ) | .title' $jsonMarvin | wc -l)
#All projects
aProjects=$(jq '.[] | select(.type == "project" and (.done == false or .done == null) and (.recurring == false or .recurring == null) ) | .title' $jsonMarvin | wc -l)
#Finished
finTasks=$(jq '.[] | select(.db == "Tasks" and .done == true) | .title' $jsonMarvin | wc -l)
#Finished (non recurring)
finNRTasks=$(jq '.[] | select(.db == "Tasks" and .done == true and (.recurring == false or .recurring == null) ) | .title' $jsonMarvin | wc -l)
#All tasks (non recurring)
NRTasks=$(jq '.[] | select(.db == "Tasks" and (.done == false or .done == null) and (.recurring == false or .recurring == null) ) | .title' $jsonMarvin | wc -l)
#Tasks (non recurring)
SNRTasks=$(jq '.[] | select(.db == "Tasks" and (.done == false or .done == null) and (.recurring == false or .recurring == null) and (.isReward == false or .isReward == null) and (.labelIds? | index("sJFBapxx9xEc4") | not) ) | .title' $jsonMarvin | wc -l)
#Actionnable tasks
ActTasks=$(jq '.[] | select(.db == "Tasks" and (.done == false or .done == null) and .backburner == false and (.recurring == false or .recurring == null) and (.isReward == false or .isReward == null) and (.labelIds? | index("sJFBapxx9xEc4") | not) and (.labelIds? | index("Yq67mHzMXfiBD") | not) ) | .title' $jsonMarvin | wc -l)

#Delete json file when done
rm $archiveMarvinFolder/*.json

# Get the line count
sortedMusic=$(grep -E '^uri' $sortedPlaylist | wc -l)
toSortMusic=$(grep -E '^uri' $sortingPlaylist | wc -l)

#Folder sizes and number of files
echo "Finding out sizes of relevant folders..."
sortedSize=$(du -s /home/storage/WARES/ | awk '{ printf("%.1f\n", $1/1024/1024) }' | tr '.' ',')
toSortSize=$(du -s /home/storage/INLET/ | awk '{ printf("%.1f\n", $1/1024/1024) }' | tr '.' ',')
echo "Finding out file counts of relevant folders..."
filesToSort=$(find /home/storage/INLET/ -type f | wc -l)
spToSort=$(find $spFolder -type f | wc -l)
filesToSort=$((filesToSort - spToSort))

#Create Metrics CSV from data
{ printf ";$europeanDate\nFichiers triés (GB in WARES);$sortedSize\nFichiers à trier (GB in Inlet);$toSortSize\nNombre de fichiers à trier (N);$filesToSort\nNombre de fichiers à trier (Sp);$spToSort\nMusique triée;$sortedMusic\nMusique à trier (en cours);$toSortMusic\nProjets Terminés;$fProjects\nProjets en cours;$aProjects\nTâches Finies;$finTasks\nTâches Finies (Non récurrentes);$finNRTasks\nToutes les tâches (Non récurrentes);$NRTasks\nTâches (Non récurrentes);$SNRTasks\nTâches pertinentes;$ActTasks"; } > Metrics$europeanDateFile.csv

echo done
