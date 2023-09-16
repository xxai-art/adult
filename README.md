
## 目录

onnx_export 把 量化压缩过的 rtdert 导出为 onnx

rtdert 运行量化压缩过的模型

## 参考阅读

[加速 44%！RT-DETR 量化无损压缩优秀实战](https://ai.baidu.com/support/news?action=detail&id=3131)

模型下载 https://github.com/PaddlePaddle/PaddleSlim/tree/develop/example/auto_compression/detection#rt-detr

[RT-DETR Deploy with ONNX and TensorRT](https://github.com/nanmi/RT-DETR-Deploy)

导出的 onnx 用 https://netron.app/ 查看模型，看最后 reshape 的 name, 获取下面 onnx sess.run 的第一个参数

如下图

![](https://i-01.eu.org/2023/09/LnHf9yv.webp)
