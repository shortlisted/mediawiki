# MediaWiki Backup script
Backup folder contains two scripts for making backups of MediaWiki-content.

Written for hosting the MediaWiki platform on a Raspberry Pi 3.

The scripts are run via cron, and make three different backups.

* A daily current .xml-dump without revision history
* A weekly full .xml-dump, with revision history
* A monthly full .xml-dump, that is permanently stored

Both the daily and weekly backups are replaced with the most recent content each time the script is executed.

Monthly backups are named with YYYY/MM, and stored permanently.

The scripts assume standard debian install paths, `/var/www/html/...`

Change script paths as needed in `setup.sh` if you installed it somewhere else.
