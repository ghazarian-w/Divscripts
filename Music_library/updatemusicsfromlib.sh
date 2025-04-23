#Copies file into files of the same name in target folder

find ~/Musique/Level_1/ -type f | while read fichier
do cp -uv "~/Musique/Novocals/${fichier#~/Musique/Level_1/}" "$fichier"
done