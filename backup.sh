#!/bin/bash
#### Variables ####
current_directory="/usr/local/bin/backup"
config_file="$current_directory/backup.conf"
log_file="/var/log/backup-$(date +%H).log"

#### Function ####
verify_privileges() {
  if [ $UID -ne 0 ]
  then
    echo "You must be root to execute this script! Bye Bye."
    exit 22
  fi
}

create_target() {
  target="/srv/backup/$hostname/$(date +%A)"
  if ! [ -d $target ]
  then
    if ! mkdir -p $target
    then
      message="ERROR: Cannot create $target"
      write_log
    fi
  fi
}

rsync_data() {
  for source in $sources
  do
    if rsync -av -e 'ssh' --rsync-path='sudo rsync' $user@$ip:$source $target
    then
      message="Rsync done: $source from $hostname"
    else
      message="ERROR while synchronizing $source from $hostname"
    fi
    write_log
  done
}

write_log() {
  echo "$message"
  date_formated=$(date +%d-%m-%Y_%H:%M.%S)
  echo "$date_formated - $message" 1>> $log_file
}

#### Main code ####
verify_privileges

echo "**** Synchroning files with rsync ****" 1> $log_file

# 10.77.20.5:srv5:22:tux:/etc /home /root /srv /var/log:
while read line
do
  ip=$(echo $line | cut -d: -f1)
  hostname=$(echo $line | cut -d: -f2)
  port=$(echo $line | cut -d: -f3)
  user=$(echo $line | cut -d: -f4)
  sources=$(echo $line | cut -d: -f5)
  create_target
  rsync_data
done 0< $config_file
