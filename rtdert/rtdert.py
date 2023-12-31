#!/usr/bin/env python
from imgbox import imgbox
from label import LABEL
import pillow_avif  # noqa
from PIL import Image
import onnxruntime as rt
import cv2
import numpy as np
from os.path import abspath, dirname, join

PWD = dirname(abspath(__file__))
ROOT = dirname(PWD)

ONNX = join(ROOT, 'model/rtdetr_hgnetv2_x_6x_coco_quant.sim.onnx')
sess = rt.InferenceSession(ONNX, providers=['CoreMLExecutionProvider'])


def rtdert(img):
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
  return result[0]


if __name__ == '__main__':
  img = join(PWD, "test.avif")
  org_img = Image.open(img)
  img = np.array(org_img.convert('RGB'))
  print(img.shape)

  boxli = []
  for value in rtdert(img):
    if value[1] > 0.5:
      label = LABEL[int(value[0])]
      boxli.append((label + ": %.2f " % (value[1] * 100), value[2:6]))

  imgbox(org_img, boxli)

  org_img.save(join(PWD, 'result.avif'), quality=80)
