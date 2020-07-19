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
        echo "Usage: $( basename $0) [options...] {optional tex/gp files....} "
        echo
        echo "options:"
        echo "  -k --keep,      Keep the debugging files after compiling (aux, out, log... see 'rm_textrail.sh' to view which files are deleted)"
        echo "  -h --help,      I don't need to explain, you're already here"
        echo
        echo "This script requires 'rm_textrail.sh' in the same folder to function properly"
        echo "If no files are given as input, it tries to compile every tex and gp file in the current directory"
        echo "The script does simply continue going through the inputs if one file did not successfully compile"
        echo "With specified input: only the given files are compiled."
        echo "It tries to compile matching pairs of tex and gp files, if only one gp file is given and there exist a tex file with the same filename, both will be compiled"
        echo
        echo "All subdirectories of the current folder are added in the \$TEXINPUTS -> figures in subfolders will be detected without path specification"
        echo "Compiles each tex file with 'latex -> dvips -> ps2pdf' "
        echo
        echo "!!!ATTENTION!!! upon request, another option can be added to choose the latex compiler"
        exit
    esac
done


if [ -z "$1" ]; then #default if no argument is passed, compile every file with the right ending
    for i in *.gp; do
    	gnuplot $i || continue
    done
    for i in *.tex; do
    	fname=${i/.tex/}
    	latex "$i" || continue

    	dvips  "$fname.dvi"
    	ps2pdf "$fname.ps"
    done
else #with arguments passed, compile only the arguments
    for i in "$@"; do
        if [[ "$i" =~ .*\.gp$ ]]; then
            fname=${i/.gp/}
            gnuplot $i || continue
            if [ -f "$fname.tex" ]; then
                latex  "$fname.tex" || continue
                dvips  "$fname.dvi"
                ps2pdf "$fname.ps"
            fi
        fi
        if [[ "$i" =~ .*\.tex$ ]]; then
            fname=${i/.tex/}
            if [ -f "$fname.gp" ]; then
                gnuplot "$fname.gp"
            fi
            latex $i || continue

            dvips  "$fname.dvi"
            ps2pdf "$fname.ps"
        fi
    done
fi

if $rm ; then
    rm_textrail.sh
fi
