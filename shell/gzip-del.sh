#!/bin/sh
dir=$1

find "$dir" -type f -printf '%p\n'| grep -iE '\.(gz)$'| awk '{

    system("rm -f " $1);
        print $1 " [deleted]";
	 
}'
