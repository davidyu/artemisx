#!/bin/bash

TESTPATH=src/com/artemis/test

# copy files; hacky
TESTFILES=$TESTPATH/*.hx
for f in $TESTFILES
do
    cp $f $TESTPATH/..
done

haxe $TESTPATH/test.hxml
neko $TESTPATH/test.n

# cleanup
for f in $TESTFILES
do
    rm $TESTPATH/../$(basename $f)
done
