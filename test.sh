#!/bin/bash

# save working directory
DIR=$( pwd )

haxe test.hxml
neko test.n

# go back
cd $DIR
