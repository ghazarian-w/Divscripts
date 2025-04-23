#!/bin/bash

#Kills every memory consuming program to save the ram

pkill -f "firefox"
pkill -f "geeqie"
pkill signal-desktop
pkill -f "standard-notes"