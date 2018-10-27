## this script creates automatic .xml backups and .sql datadumps
## of contents of mediawiki databases. An additional compressed
## tar.gz archive of the wiki datadir (images and such) is created
## weekly.
## the backups done daily are of the current state of the database
## weekly backups are --full with complete revision history.

## both weekly and daily backups are replaced every time those scripts are
## executed.

## monthly backups are not replaced, each backup stored permanently.

## $USER to find current users path
## dayofweek to check if the script should run a --full xml-dump
## dayofmonth to check if a monthly dated xml-dump should be made
## currentdate to name monthly files
## outdir for destination directory
## wikidir for mediawiki installation directory
## php to use current php
## .sqlpwd contains database username/password for a backup user
## backup user has grants to select * from wiki database

## directories assumes a mediawiki installation on a raspberry pi with default paths

outdir=$HOME/backups/mediawiki
dayofmonth=$(date +%d)
currentdate=$(date +%y%m)
dayofweek=$(date +"%u")
wikidir=/var/www/html/wiki
php=$(which php)

## daily backups: current .xml, .sql, assets and images as .tar.gz
printf "\nperforming daily current .xml-dump."
$php $wikidir/maintenance/dumpBackup.php --current > $outdir/dailycurrent.xml
printf "\nperforming .sql-dump.\n"
mysqldump --defaults-extra-file=/etc/mysql/sqlbu wikidb > $outdir/"$(date '+%y-%m').wiki.sql"
tar -czf $outdir/images.tar.gz /var/www/html/wiki/images /var/www/html/wiki/resources/assets

## weekly full backups to be run on mondays (-eq 1)
## also makes a weekly tar archive of the install directory (pictures, settings, etc)
if [ "${dayofweek}" -eq 1 ]; then
    printf "\ndoing full weekly backup...";
    $php $wikidir/maintenance/dumpBackup.php --full > $outdir/fullweekly.xml
    printf "\nbackup created: $outdir/fullweekly.xml\n"
    /bin/tar czfh $outdir/mediawiki.tar.gz $wikidir
fi

## fullbackups to be run on the 25th of each month, or if no monthly_dump exist
if [ "${dayofmonth}" -eq 25 ] || [ ! -f $outdir/monthly_dump_$currentdate.xml ]; then
    printf "\nrunning full monthly .xml-dump";
    $php $wikidir/maintenance/dumpBackup.php --full > $outdir/monthly_dump_$currentdate.xml;
    printf "\nbackup created: $outdir/monthly_dump_$currentdate.xml";
fi
