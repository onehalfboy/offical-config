#!/bin/bash
num=0
while(($num < 7))
do
#echo $num;
mkdir $num;
let "num++";
done
