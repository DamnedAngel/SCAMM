#!/usr/bin/env bash

cd ../SCAMM
r=$(python ./Make/make.py Debug $1 $2)
if [ "$r" -ne "0" ]; then
    cd ../TheTrial
    exit;
fi;

cd ../Screen8
r=$(python ./Make/make.py Debug $1 $2)
if [ "$r" -ne "0" ]; then
    cd ../TheTrial
    exit;
fi;

cd ../TheTrial
python ./Make/make.py Debug $1 $2
