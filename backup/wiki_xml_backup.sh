## This script creates automatic .xml backups of MediaWiki databases.
## The backups done DAILY are of the CURRENT state of the database
## WEEKLY backups are --full with complete revision history.

## Both WEEKLY and DAILY backups are replaced every time those scripts are
## executed.

## MONTHLY backups are not replaced, each backup stored permanently.

## $USER to find current users path
## DAYOFWEEK to check if the script should run a --full xml-dump
## DAYOFMONTH to check if a monthly dated xml-dump should be made
## CURRENTDATE to name monthly files
## OUTDIR for destination directory
## WIKIDIR for MediaWiki installation directory
## PHP to use current PHP

## Directories assumes a MediaWiki installation on a Raspberry pi with default paths

OUTDIR=$HOME/backups/mediawiki
DAYOFMONTH=$(date +%d)
CURRENTDATE=$(date +%Y%m)
DAYOFWEEK=$(date +"%u")
WIKIDIR=/var/www/html/MediaWiki
PHP=$(which php)

printf "\nPerforming daily current .xml-dump."
$PHP $WIKIDIR/maintenance/dumpBackup.php --current > $OUTDIR/dailycurrent.xml

## Weekly full backups to be run on Mondays (-eq 1)
if [ "${DAYOFWEEK}" -eq 1 ]; then
	printf "\nDoing full weekly backup...";
	$PHP $WIKIDIR/maintenance/dumpBackup.php --full > $OUTDIR/fullweekly.xml
	printf "\nBackup created: $OUTDIR/fullweekly.xml"
fi

## Fullbackups to be run on the 25th of each month, or if no monthly_dump exist
if [ "${DAYOFMONTH}" -eq 25 ] || [ ! -f $OUTDIR/monthly_dump_$CURRENTDATE.xml ]; then
	printf "\nRunning full monthly .xml-dump";
	$PHP $WIKIDIR/maintenance/dumpBackup.php --full > $OUTDIR/monthly_dump_$CURRENTDATE.xml;
	printf "\nBackup created: $OUTDIR/monthly_dump_$CURRENTDATE.xml";
fi
