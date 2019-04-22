#!/bin/bash
SRC="$@/eval.cs"
OUT="$@/eval"
COMPILE="timeout 60s mcs $SRC -out:$OUT"
RUN="timeout 3s mono $OUT"

[ ! -d $@ ] && mkdir $@
cat > $SRC
$COMPILE 2> $@/log 1> /dev/null
sed -e "s|$SRC|<source>|g" $@/log | sed -e "s|$OUT|<program>|g"
[ -f $OUT ] && $RUN
[ $? == 124 ] && echo Execution timed out!
rm $@ -r
exit 0
