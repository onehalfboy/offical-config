#!/bin/bash
path=/root2/backup/var_www
dPath=/root2/backup/www
configPath=$path/config
dbPath=$path/db
webPath=$path/web
goPath=$path/go
dConfigPath=$dPath/config
dDbPath=$dPath/db
dWebPath=$dPath/web
dGoPath=$dPath/go

find "$path" -name *~ -type f | xargs rm -rf "{}"
find "$path" -name *.dump -type f | xargs rm -rf "{}"
find "$path" -name *.log -type f | xargs rm -rf "{}"
find "$path" -name *# -type f | xargs rm -rf "{}"
find "$path" -name .tags -type f | xargs rm -rf "{}"
find "$path" -name .tags_sorted_by_file -type f | xargs rm -rf "{}"
find "$path" -name %%*.html.php -type f | xargs rm -rf "{}"
find "$path" -name wrt* -type f | xargs rm -rf "{}"
find "$path" -name .svn -type d | xargs rm -rf "{}"
find "$path" -name .git -type d | xargs rm -rf "{}"
find "$path" -name .idea -type d | xargs rm -rf "{}"

mkdir -p "$dConfigPath"
mkdir -p "$dDbPath"
mkdir -p "$dWebPath"
mkdir -p "$dGoPath"
cd "$configPath"
ls "$configPath" | grep -v .zip | xargs -i zip -r "${dConfigPath}/{}.zip" "{}"
cd "$dbPath"
ls "$dbPath" | grep -v .zip | xargs -i zip -r "${dDbPath}/{}.zip" "{}"
cd "$webPath"
ls "$webPath" | grep -v .zip | xargs -i zip -r "${dWebPath}/{}.zip" "{}"
cd "$goPath"
ls "$goPath" | grep -v .zip | xargs -i zip -r "${dGoPath}/{}.zip" "{}"

