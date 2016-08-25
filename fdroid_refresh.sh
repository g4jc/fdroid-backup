#!/bin/sh
echo "Make sure you are in desired folder (e.g. ~/f-droid.org/) prior to running this script."
echo "You may also want to modify 'repo_url' on fdroid_backup_aio.py if you wish to mirror a site besides f-droid.org"
echo "Downloading latest F-Droid files to current directory..."
python fdroid_backup_aio.py
wait
ls repo/ > downloaded_apk.txt ## Get list of existing files to save time.
wait
grep -Fxv -f downloaded_apk.txt apk.txt > apk_to_download.txt ## Compare against new files
wait
sed -i 's|^|https://f-droid.org/repo/|' apk_to_download.txt ## Create download urls
wait
cd repo/
wget -nc --content-disposition --trust-server-names -i ../apk_to_download.txt ## Download unsynced apk to repo/
wait
cd icons
ls  > ../../downloaded_icons.txt ## Get list of existing icons to save time.
wait
grep -Fxv -f ../../downloaded_icons.txt ../../icons.txt > ../../icons_to_download.txt ## Compare against new files
wait
sed -i 's|^|https://f-droid.org/repo/icons/|' ../../icons_to_download.txt ## Create download urls
wait
wget -nc --content-disposition --trust-server-names -i ../../icons_to_download.txt ## Download unsynced icons to repo/
wait
cd ../..
wait
ls sources/ > downloaded_sources.txt ## Get list of existing sources to save time.
wait
grep -Fxv -f downloaded_sources.txt sources.txt > sources_to_download.txt ## Compare against new files
wait
sed -i 's|^|https://f-droid.org/repo/|' sources_to_download.txt ## Create download urls
wait
cd sources/
wait
wget -nc --content-disposition --trust-server-names -i ../sources_to_download.txt ## Download unsynced source tarballs to repo/
wait
cd ../
wait
##Begin File Integrity Check##
sed -i -r 's/\s+/ \*/g' hash.txt
wait
sed -i 's|.apk \*|.apk\n|g' hash.txt
wait
cd repo/
echo "Checking file integrity please wait..."
wait
sha256sum -c ../hash.txt | grep FAILED > ../failed_integrity.txt
wait
sed -i "s|: FAILED||g" ../failed_integrity.txt
wait
xargs rm -v < ../failed_integrity.txt
wait
cd ../
echo "Note: If any files failed integrity and were removed, re-run this script as you have had a corrupt download of the repo."
wait
mv -t repo/ index.xml index.jar categories.txt latestapps.dat
wait
## Cleanup working directory.
rm download_apk.txt apk.txt download_icons.txt icons.txt apk_to_download.txt icons_to_download.txt downloaded_icons.txt downloaded_apk.txt downloaded_sources.txt sources_to_download.txt download_sources.txt sources.txt hash.txt failed_integrity.txt
wait
echo "Downloads finished, you should have a working backup of the f-droid mirror"

