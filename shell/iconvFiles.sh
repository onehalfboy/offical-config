#!/bin/bash
files=$1
fromEnc=$2
toEnc=$3
opt=$4


function isEnc()
{
  local temp=`iconv -f $2 $1 1>/dev/null 2>/dev/null && echo 'true'`;
  if [ "$temp" = 'true' ]; then
#echo 'true';
    return 0;
  fi;
#echo 'false'
  return 1;
}

function iconvFile()
{
	local right=`isEnc $1 $fromEnc && echo 'true'`
#echo "$right";
	if [ "$right" == "true" ]; then
#echo "right";
		return `iconv -f $fromEnc -t $toEnc $opt $1 -o $1`
	fi
#echo "error";
	return 1;
}

#tmp=$(isEnc $files $fromEnc);
#echo "$tmp";
#exit 0
if [ -f "$files" ]; then
	iconvFile "$files"
	exit 0
fi

