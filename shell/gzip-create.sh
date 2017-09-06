#!/bin/sh
dir=$1

find "$dir" -type f -printf '%p\n'| grep -iE '\.(html|css|js|jpg|png|gif|log)$'| awk '{
 
origin_file=$1;
origin_stat_cmd="stat -c \"%Y\" " origin_file;
origin_stat_cmd | getline origin_last_modify_timestamp;

gz_file=origin_file ".gz";
stat_cmd="stat -c \"%Y\" " gz_file;
exist_cmd="[  -e \"" gz_file "\" ] && echo 1 || echo 0";
exist_cmd | getline gz_file_exist;
if (gz_file_exist) {
	    stat_cmd | getline last_modify_timestamp;
    } else {
        last_modify_timestamp=0;
}
 
if (last_modify_timestamp < origin_last_modify_timestamp) {
	    system("gzip -c9 " origin_file " > " gz_file);
	        print gz_file " [created]";
	}
	 
}'
