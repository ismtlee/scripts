#!/bin/sh
src=test
dst=test1
grep a=request $src |grep operator|awk '{print $1, $2, $7}'|awk -F '&' '{print $1, $2, $3, $4, $5}'> $dst
sed -i 's/\w*= /_ /g' $dst
sed -i 's/\w*=//g' $dst
