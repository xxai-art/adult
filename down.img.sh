#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
echo $$ >.run.pid

nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890
./build.sh
./lib/index.js
