#!/bin/bash
SRC="$@/eval.pl"
RUN="timeout 3s perl $SRC"
[ ! -d $@ ] && mkdir $@
cat > $SRC
$RUN &> $@/log
[ $? == 124 ] && echo Execution timed out!
sed -e "s|$SRC|<source>|g" $@/log
rm $@ -r
exit 0
