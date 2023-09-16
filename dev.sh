#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))

cd $DIR
echo $$ >.dev.pid

rm -rf lib
set -ex

exec watchexec --shell=none \
  --no-project-ignore \
  --exts coffee,js,mjs,json,wasm,txt,yaml \
  -w src/ \
  -r -- ./run.sh $@
