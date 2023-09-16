#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

case $(uname -s) in
Darwin)
  pip install onnxruntime-silicon
  ;;
Linux*) ;;
*) ;;
esac


onnx=rtdetr_hgnetv2_x_6x_coco_quant.sim.onnx
if [ ! -f "../model/$onnx" ]; then
  cd ..
  mkdir -p model
  cd model
  wget -c https://huggingface.co/xxai-art/tar/resolve/main/$onnx.zst
  zstd -d $onnx.zst
  rm $onnx.zst
  cd $DIR
fi
