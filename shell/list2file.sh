#!/bin/bash

#init
curPath=`pwd`
targetPath="${curPath}/case"
sourcePath=".."
listFile="./file.txt"
targetFile="$targetPath/file.txt"
cpFile="$targetPath/cp.log"
nextIsFile=0
mkdir "${targetPath}" -p
 
#clear
rm $targetPath/* -rf

for line in $(<$listFile); 
do
	if [ ${#line} == 1 ] ;then 
		nextIsFile=1;
		continue;
	fi;

	if [ $nextIsFile != 1 ] || [ ${line:0:1} != "/" ] ; then
		nextIsFile=0;
		continue;
	fi;

	exist=0;
	if [ -f "$targetFile" ]; then
		for targetLine in $(<$targetFile);
		do
			if [ "$targetLine" == "$line" ]; then
				exist=1;	
				break;
			fi;	
		done;
	fi;
	if [ "$exist" == "0" ]; then
		echo $line >> $targetFile;
	fi;

	nextIsFile=0;
	
done; 
 
if [ -f "$targetFile" ]; then
	cd $sourcePath;

	for targetLine in $(<$targetFile);
	do
		cp "${targetLine:1}" --parents "${targetPath}/" -rv >> $cpFile; 
	done;
fi;
