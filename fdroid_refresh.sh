#!/bin/sh
echo "Make sure you are in desired folder (e.g. ~/f-droid.org/) prior to running this script."
echo "You may also want to modify 'repo_url' on fdroid_backup_aio.py if you wish to mirror a site besides f-droid.org"
echo "Downloading latest F-Droid files to current directory..."
python fdroid_backup_aio.py
wait
ls repo/ > downloaded_apk.txt
wait
grep -Fxv -f downloaded_apk.txt apk.txt > apk_to_download.txt
wait
sed -i 's|^|https://f-droid.org/repo/|' apk_to_download.txt
wait
cd repo/
wget -nc --content-disposition --trust-server-names -i ../apk_to_download.txt
wait
cd icons
ls  > ../../downloaded_icons.txt
wait
grep -Fxv -f ../../downloaded_icons.txt ../../icons.txt > ../../icons_to_download.txt
wait
sed -i 's|^|https://f-droid.org/repo/icons/|' ../../icons_to_download.txt
wait
wget -nc --content-disposition --trust-server-names -i ../../icons_to_download.txt
wait
cd ../..
mv -t repo/ index.xml index.jar categories.txt latestapps.dat
wait
## Cleanup working directory.
rm download_apk.txt apk.txt download_icons.txt icons.txt apk_to_download.txt icons_to_download.txt downloaded_icons.txt downloaded_apk.txt
wait
echo "Downloads finished, you should have a working backup of the f-droid mirror"

