## F-Droid Backup Script, to be used with bash scripts.
## TODO: Grab package sources. Currently this script is capable of re-creating the entire binary repo to be used with F-Droid client... but it doesn't grab the source tarballs.
import pycurl
from xml.dom import minidom
import re
import time

regex_line_start = r"(?:^|\n)\s*"
regex_line_end = r"(?:$)"

repo_url = "https://f-droid.org/repo/"

## Begin Download of F-Droid Repo Files for backup.
with open('index.xml', 'wb') as f:
    c = pycurl.Curl()
    c.setopt(c.URL, (repo_url + 'index.xml'))
    c.setopt(c.WRITEDATA, f)
    c.perform()
    c.close()


with open('index.jar', 'wb') as f:
    c = pycurl.Curl()
    c.setopt(c.URL, (repo_url + 'index.jar'))
    c.setopt(c.WRITEDATA, f)
    c.perform()
    c.close()

with open('categories.txt', 'wb') as f:
    c = pycurl.Curl()
    c.setopt(c.URL, (repo_url + 'categories.txt'))
    c.setopt(c.WRITEDATA, f)
    c.perform()
    c.close()

with open('latestapps.dat', 'wb') as f:
    c = pycurl.Curl()
    c.setopt(c.URL, (repo_url + 'latestapps.dat'))
    c.setopt(c.WRITEDATA, f)
    c.perform()
    c.close()

time.sleep(120) ## Eventually internet might be fast enough so we don't need to wait 2 mins before continuing. lulz.


## Parse index.xml for APK Names to download and make the download list.
def getAPK(xml):
    """
    Print out all apk found in xml
    """
    doc = minidom.parse(xml)
    node = doc.documentElement
    fdroidNode = doc.firstChild
    counter = 0
    app = fdroidNode.getElementsByTagName("apkname")

    apknames = []
    for application in app:
        apkObj = app[counter].firstChild.data.encode('ascii', 'ignore')
	counter += 1
        apknames.append(apkObj)
	list(set(apknames))
        ## print '\n'.join(apknames) ## Only needed for debugging the list or piping manually to a file.
    ## f.write("%s\n" % apknames) ## literally write list to file
    

    f = open( 'download_apk.txt', 'w' )
    ## Magical Regex to create downloadable url's
    add_fdroid_url = [re.sub(regex_line_start, repo_url, string) for string in apknames]
    append_asc_extension = [re.sub(regex_line_end, '.asc', string) for string in add_fdroid_url]
    ##
    f.write("\n".join(add_fdroid_url)) ## Convert list to line breaks, prepend the url, and print to file.
    f.close()
    
    with open("download_apk.txt", "a") as f:
      f.write("\n".join(append_asc_extension)) ## Append .asc signatures to same file.
      f.close()

    f = open( 'apk.txt', 'w' )
    f.write("\n".join(apknames)) ## Print only apk names (useful for grepping during re-dump)
    f.close()
    f = open( 'apk.txt', 'a' )
    f.write('\n' + "\n".join([re.sub(regex_line_end, '.asc', string) for string in apknames])) ## Append .asc signatures to same file.
    f.close()



def getIcons(xml):
    """
    Print out all icons found in xml
    """
    doc = minidom.parse(xml)
    node = doc.documentElement
    fdroidNode = doc.firstChild
    counter = 0
    icon = fdroidNode.getElementsByTagName("icon")

    iconsnames = []
    for iconlication in icon:
        iconsObj = icon[counter].firstChild.data.encode('ascii', 'ignore')
	counter += 1
        iconsnames.append(iconsObj)
	list(set(iconsnames))
    ## Magical Regex to create downloadable url's
    add_fdroid_url = [re.sub(regex_line_start, (repo_url + 'icons/'), string) for string in iconsnames]
    ##
    f = open( 'download_icons.txt', 'w' ) ## TIP: change this line to 'with open("download_apk.txt", "a") as f:' if you want all url's in single file.
    f.write("\n".join(add_fdroid_url)) ## Convert list to line breaks, prepend the url, and print to file.
    f.close()

    f = open( 'icons.txt', 'w' )
    f.write("\n".join(iconsnames)) ## Print only icon names (useful for grepping during re-dump)
    f.close()

if __name__ == "__main__":
    document = 'index.xml'
    getAPK(document)
    getIcons(document)




