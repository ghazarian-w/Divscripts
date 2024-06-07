find ~/Musique/Level_1/ -type f | while read fichier
do cp -uv "~/Musique/Novocals/${fichier#~/Musique/Level_1/}" "$fichier"
done