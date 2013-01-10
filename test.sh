#!/bin/bash

TESTPATH=src/com/artemis/test

# save working directory
DIR=$( pwd )

cd $TESTPATH
haxe test.hxml
neko test.n

# go back
cd $DIR
