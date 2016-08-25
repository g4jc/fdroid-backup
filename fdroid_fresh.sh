#!/bin/sh
echo "Make sure you are in desired folder (e.g. ~/f-droid.org/) prior to running this script."
echo "You may also want to modify 'repo_url' on fdroid_backup_aio.py if you wish to mirror a site besides f-droid.org"
echo "Downloading latest F-Droid files to current directory..."
python fdroid_backup_aio.py
wait
mkdir repo
wait
cd repo/
wget -nc --content-disposition --trust-server-names -i ../download_apk.txt
wait
mkdir icons
cd icons
wget -nc --content-disposition --trust-server-names -i ../../download_icons.txt
wait
cd ../..
wait
mkdir sources
wait
cd sources/
wait
wget -nc --content-disposition --trust-server-names -i ../download_sources.txt
wait
cd ../
wait
mv -t repo/ index.xml index.jar categories.txt latestapps.dat
wait
## Cleanup working directory.
rm download_apk.txt apk.txt download_icons.txt icons.txt download_sources.txt
wait
echo "Downloads finished, you should have a working backup of the f-droid mirror"

