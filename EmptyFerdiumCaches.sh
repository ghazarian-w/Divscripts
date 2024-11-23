#!/bin/bash

# Base directory where service folders are located
base_dir="/home/$USER/.config/Ferdium/Partitions"

# Find all service directories using regular expressions and delete their Cache and Code Cache contents
find "$base_dir" -maxdepth 1 -type d -regextype posix-extended -regex "$base_dir/service-[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}" | while read -r service_dir; do
    rm -rf "$service_dir/Cache"/*
    rm -rf "$service_dir/Code Cache"/* 
done

echo "Cache and Code Cache contents have been cleared for all service directories."
