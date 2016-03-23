#!/bin/bash

## Setup script for automated mediawiki .xml-dumps
## Automation via cron

## Setting variables
SCRIPTDIR=$HOME/.bin
SCRIPTNAME="wiki_xml_backup.sh"
CRONSTRING='15 3 * * * '"$DESTINATION/$SCRIPTNAME" # Note: ' ' around text string, " " around variables
WIKIDIR=/var/www/html/MediaWiki
OUTDIR=$HOME/backups/mediawiki

# Check to see that we have the right install directory for MediaWiki
if [ ! -f $WIKIDIR/maintenance/dumpBackup.php ]; then
	printf "\ndumpBackup.php missing, stopping script.";
	exit 1
else
	printf "\ndumpBackup.php exists, proceeding with script\n";
	fi

## Check to see that we have a directory to store backups
if [ ! -d "$OUTDIR" ]; then
	printf "\nNo existing backup directory. Creating directory.";
	mkdir -p $OUTDIR;
else
	printf "\nBackup directory at: $OUTDIR"
fi

if [ ! -f $SCRIPTDIR ]; then
    printf "\nNo $HOME/.bin directory, creating...";
    mkdir -p $SCRIPTDIR
else
    printf "Placing scripts in ~/.bin/\n"
fi

echo "Changing script to executable"
chmod +x $SCRIPTNAME

echo "Moving script..."
mv $SCRIPTNAME $SCRIPTDIR/$SCRIPTNAME

#Clone current crontab to keep old jobs
echo "Cloning crontab..."
crontab -l > tmpcron

if [[ $(grep -F "$SCRIPTNAME" tmpcron) ]] ; then
    echo "Cron entry for .xml-dumps exists";
    echo "Not adding entry"
    exit 1;
else
    echo "$SCRIPTNAME"
    echo "$CRONSTRING" >> tmpcron;
    echo "Cron entry added:";
    tail -2 tmpcron;
    crontab tmpcron;
    rm tmpcron;
fi
