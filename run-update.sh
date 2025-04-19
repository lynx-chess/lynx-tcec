#!/bin/bash

# Scripts that mimics TCEC behavior

DATETIME=`date +%Y-%m-%dT%H_%M_%S`
SRC_DIR=${VERSION}__$DATETIME

mkdir $SRC_DIR
cp update.sh $SRC_DIR/
cd $SRC_DIR
ls -al
chmod +x update.sh
./update.sh