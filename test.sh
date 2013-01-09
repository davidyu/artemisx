#!/bin/bash

TESTPATH=src/com/artemis/test

# copy files; hacky
TESTFILES=$TESTPATH/*.hx
for f in $TESTFILES
do
    cp $f $TESTPATH/..
done

# save working directory
DIR=$( pwd )

cd $TESTPATH
haxe test.hxml
neko test.n

# go back
cd $DIR

# cleanup
for f in $TESTFILES
do
    rm $TESTPATH/../$(basename $f)
done
