# mediawiki backup script
Two scripts for making .xml backups of MediaWiki database.

Running `setup.sh` adds the backup script to the current users crontab, and places the script in a `~/.bin` folder.

The backup runs 03:15 every day and produces three types of backups:

+ Every day: a xml-dump of the current mediawiki database (no revision history)
+ Every monday: a full xml-dump of the mediawiki database (with revision history)
+ The 25th of every month: a full xml-dump with a unique name that is stored permanently.

Backups are stored at `~/backups/mediawiki`

I made the scripts for running the MediaWiki platform on a Raspberry Pi 3, so all paths assume default debain install directories.
Change accordingly if needed.
