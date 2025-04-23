#!/bin/bash

#Rename image files based on the geometric size

for filename in *.jpg* *.JPG* *.jpeg*;
do
inname=`convert $filename -format "%t" info:`
size=`convert $filename -format "%wx%h" info:`
mv $filename "${size}_${inname}.jpg";
done