#!/bin/bash
SRC="$@/eval.java"
RUN="timeout 3s java $SRC"
[ ! -d $@ ] && mkdir $@
cat > $SRC
$RUN &> $@/log
[ $? == 124 ] && echo Execution timed out!
sed -e "s|$SRC|<source>|g" $@/log
rm $@ -r
exit 0
