#!/usr/bin/env python

import pillow_avif  # noqa
from PIL import Image
import onnxruntime as rt
import cv2
import numpy as np
from os.path import abspath, dirname, join

PWD = dirname(abspath(__file__))
ROOT = dirname(PWD)

ONNX = join(ROOT, 'model/rtdetr_hgnetv2_x_6x_coco_quant.sim.onnx')
print(ONNX)
sess = rt.InferenceSession(ONNX, providers=['CoreMLExecutionProvider'])
img = join(PWD, "test.avif")
img = Image.open(img)
img = np.array(img.convert('RGB'))
print(img.shape)
org_img = img
im_shape = np.array([[float(img.shape[0]),
                      float(img.shape[1])]]).astype('float32')
img = cv2.resize(img, (640, 640))
scale_factor = np.array(
    [[float(640 / img.shape[0]),
      float(640 / img.shape[1])]]).astype('float32')
img = img.astype(np.float32) / 255.0
input_img = np.transpose(img, [2, 0, 1])
image = input_img[np.newaxis, :, :, :]

# https://github.com/PaddlePaddle/Paddle2ONNX
# 用 https://netron.app/ 查看模型，看最后reshape的name, 获取下面sess.run 的第一个参数
# 如图 https://i-01.eu.org/2023/09/LnHf9yv.webp

result = sess.run(['save_infer_model/scale_0.tmp_0'], {
    'im_shape': im_shape,
    'image': image,
    'scale_factor': scale_factor
})

print(np.array(result[0].shape))

for value in result[0]:
  if value[1] > 0.5:
    cv2.rectangle(org_img, (int(value[2]), int(value[3])),
                  (int(value[4]), int(value[5])), (255, 0, 0), 2)
    cv2.putText(org_img,
                str(int(value[0])) + ": " + str(value[1]),
                (int(value[2]), int(value[3])), cv2.FONT_HERSHEY_SIMPLEX, 0.5,
                (255, 255, 255), 1)
cv2.imwrite("./result.png", org_img)
