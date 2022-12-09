#!/bin/sh

for dir in AIO/*
do
    if [ -d "$dir" ]
    then
	for subdir in $dir/*
	do
	    echo $subdir
	    cd $subdir
	    if [ -e "Makefile" ]
	    then
		make
	    fi
	    cd -
	done

    fi
done
