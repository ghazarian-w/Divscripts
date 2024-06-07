#!/bin/bash
    while [[ -n "$1" ]]; do
    	#if a file and not a dir
    	if [[ -f "$1" ]]; then
    		jhead -nf%m.%d.%Y_%H:%M "$1"
    		fi
    	shift
    done

    for i in *.JPG; 
    do mv $i `basename $i JPG`jpg; 
    done