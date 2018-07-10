#!/bin/bash

if [ "$1" == "" ]; then
	echo "Usage: $0 file.pml"
else
    # ECHO ON
    set -x
    spin -a $1
    gcc  -DBFS  -w -o pan pan.c
    ./pan
    spin -t $1
fi
