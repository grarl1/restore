#!/bin/sh

arg=${1:-.}
exts="acn aux bbl bcf blg brf glo idx ilg ist ind lof log lol lot out run.xml toc synctex.gz"

if [ -d $arg ]; then
    for ext in $exts; do
         rm -f $arg/*.$ext
    done
else
    for ext in $exts; do
         rm -f $arg.$ext
    done
fi
