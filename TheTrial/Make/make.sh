#!/usr/bin/env bash

build () {
    cd ../$1
    python ./Make/make.py Debug $2 $3
    r=$?
    echo "Exit code: $r"
    if [ "$r" -ne "0" ]; then
        cd ../TheTrial
        exit $r
    fi;
}

build SCAMM $1 $2
build Screen8 $1 $2
build TheTrial $1 $2

