#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}/..
cd $DIR
set -ex
rtdert=rtdetr_hgnetv2_x_6x_coco_quant


if [ ! -d "model/$rtdert" ]; then
  mkdir -p model
  cd model
  wget -c https://bj.bcebos.com/v1/paddle-slim-models/act/$rtdert.tar
  tar -xvf $rtdert.tar
  rm -rf $rtdert.tar
  cd $DIR
fi

cd model
# https://github.com/nanmi/RT-DETR-Deploy

paddle2onnx --model_dir=./rtdetr_hgnetv2_x_6x_coco_quant/ \
  --model_filename model.pdmodel \
  --params_filename model.pdiparams \
  --opset_version 16 --save_file $rtdert.onnx

python -m onnxoptimizer $rtdert.onnx $rtdert.optimize.onnx

onnxsim $rtdert.optimize.onnx $rtdert.sim.onnx

rm $rtdert.onnx $rtdert.optimize.onnx
pv rtdetr_hgnetv2_x_6x_coco_quant.sim.onnx | zstd -z -19 -T0 -o rtdetr_hgnetv2_x_6x_coco_quant.sim.onnx.zst

# --overwrite-input-shape im_shape:1,2 image:1,3,640,640 scale_factor:1,2
