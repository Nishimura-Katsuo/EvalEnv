#!/bin/bash
SRC="$@/eval.lua"
RUN="timeout 3s lua5.3 $SRC"
[ ! -d $@ ] && mkdir $@
cat > $SRC
$RUN &> $@/log
[ $? == 124 ] && echo Execution timed out!
sed -e "s|$SRC|<source>|g" $@/log
rm $@ -r
exit 0
