#!/bin/bash

source $scriptsFolder/SharedFunctions

rsync -a --delete --quiet ~/ $backupFolder