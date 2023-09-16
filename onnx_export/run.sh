#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

rtx local python@3.10.13
direnv allow
direnv exec . ./rtdetr_onnx.sh
