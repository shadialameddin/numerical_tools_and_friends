#!/usr/bin/env bash

export TEXINPUTS=.:.//.:$TEXINPUTS

rm=true
for args in "$@"; do
    case "$1" in 
        -k | --keep) # keep the tex debugging files
        rm=false
        shift
    esac
    case "$1" in
        -h | --help) # user option, help file
        echo "Usage: $( basename $0) [options...] {optional tex files....} "
        echo 
        echo "options:"
        echo "  -k --keep,      Keep the debugging files after compiling (aux, out, log... see 'rm_textrail.sh' to view which files are deleted)"
        echo "  -h --help,      I don't need to explain, you're already here"
        echo
        echo "This script requires 'rm_textrail.sh' in the same folder to function properly"
        echo "If no files are given as input, it tries to compile every tex file in the current directory"
        echo "The script does simply continue going through the inputs if one file did not successfully compile"
        echo "With specified input: only the given files are compiled."
        echo
        echo "All subdirectories of the current folder are added in the \$TEXINPUTS -> figures in subfolders will be detected without path specification"
        echo "Compiles each file with xelatex -> bibtex -> xelatex -> xelatex"
        exit
    esac
done

# xelatex compiler is not compatible to EPS, replace all graphics with pdf files

if [ -z "$1" ]; then
    for file in *.tex; do
    	fname=${file/.tex/} 
    	xelatex "$file" || continue
    	bibtex "$fname.aux"
    	xelatex "$file" 
    	xelatex "$file" 
    
    
    done
else
    for file in "$@"; do
    	fname=${file/.tex/} 
    	xelatex "$file" || continue
    	bibtex "$fname.aux"
    	xelatex "$file" 
    	xelatex "$file" 
    done
fi

if $rm ; then
    rm_textrail.sh
fi
