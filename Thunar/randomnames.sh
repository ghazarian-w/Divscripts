#!/bin/bash

#Old script, needs rewriting. Makes random names from sha512 sums and renames provided files.

for fname in *.jpg; do

	mv -n "$fname" $(echo "$fname" | sha512sum | cut -f1 -d' ').jpg;

done

for fhueio in *.JPG; do

	mv -n "$fhueio" $(echo "$fhueio" | sha512sum | cut -f1 -d' ').jpg;

done

for fh in *.jpeg; do

	mv -n "$fh" $(echo "$fh" | sha512sum | cut -f1 -d' ').jpg;

done

for dj in *.png; do

	mv -n "$dj" $(echo "$dj" | sha512sum | cut -f1 -d' ').png;

done


for tp in *.PNG; do

	mv -n "$tp" $(echo "$tp" | sha512sum | cut -f1 -d' ').png;

done 

for gt in *.gif; do

	mv -n "$gt" $(echo "$gt" | sha512sum | cut -f1 -d' ').gif;

done 

for web in *.webm; do

	mv -n "$web" $(echo "$web" | sha512sum | cut -f1 -d' ').webm;

done 

for gnrio in *.mp4; do

	mv -n "$gnrio" $(echo "$gnrio" | sha512sum | cut -f1 -d' ').mp4;

done 

for for in *.mov; do

	mv -n "$for" $(echo "$for" | sha512sum | cut -f1 -d' ').mov;

done 