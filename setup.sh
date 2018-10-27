#!/bin/bash

## Setup script setting up mediawiki backup
## Automation via cron

## Setting variables
scriptdir=/usr/local/bin
scriptname="wikibackup"
cronstring='15 3 * * * '"$scriptdir/$scriptname" # Note: ' ' around text string, " " around variables
outdir=$HOME/backups/mediawiki

## Check to see that we have a directory to store backups
if [ ! -d "$outdir" ]; then
  printf "\nNo existing backup directory. Creating directory.\n";
  mkdir -p $outdir;
else
  printf "\nBackup directory at: $outdir\n"
fi

printf "Placing script in /usr/local/bin/\n"
sudo cp $scriptname.sh $scriptdir/$scriptname

#Clone current crontab to keep old jobs
echo "Cloning crontab..."
crontab -l > tmpcron

if [[ $(grep -F "$scriptname" tmpcron) ]] ; then
    echo "Cron entry exists";
    echo "Not adding entry"
    exit 1;
else
    echo "$cronstring" >> tmpcron;
    echo "Cron entry added:";
    tail -2 tmpcron;
    crontab tmpcron
    rm tmpcron
fi
