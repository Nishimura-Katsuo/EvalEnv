#!/bin/bash
SRC="$@/eval.py"
RUN="timeout 3s python3.5 $SRC"
[ ! -d $@ ] && mkdir $@
cat > $SRC
$RUN &> $@/log
[ $? == 124 ] && echo Execution timed out!
sed -e "s|\"$SRC\"|<source>|g" $@/log
rm $@ -r
exit 0
