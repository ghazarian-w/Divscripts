#!/bin/bash

for repo in *; 
do
7z a -mx=6 "$repo.7z" "$repo" ;
done