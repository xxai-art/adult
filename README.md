
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

数据如何导出为 coco 格式
https://towardsdatascience.com/how-to-work-with-object-detection-datasets-in-coco-format-9bf4fb5848a4

```python
import glob
import fiftyone as fo

images_patt = "/path/to/images/*"

# Ex: your custom label format
annotations = {
    "/path/to/images/000001.jpg": [
        {"bbox": ..., "label": ...},
        ...
    ],
    ...
}

# Create dataset
dataset = fo.Dataset(name="my-detection-dataset")

# Persist the dataset on disk in order to
# be able to load it in one line in the future
dataset.persistent = True

# Add your samples to the dataset
for filepath in glob.glob(images_patt):
    sample = fo.Sample(filepath=filepath)

    # Convert detections to FiftyOne format
    detections = []
    for obj in annotations[filepath]:
        label = obj["label"]

        # Bounding box coordinates should be relative values
        # in [0, 1] in the following format:
        # [top-left-x, top-left-y, width, height]
        bounding_box = obj["bbox"]

        detections.append(
            fo.Detection(label=label, bounding_box=bounding_box)
        )

    # Store detections in a field name of your choice
    sample["ground_truth"] = fo.Detections(detections=detections)

    dataset.add_sample(sample)
export_dir = "/path/for/coco-detection-dataset"
label_field = "ground_truth"  # for example

# Export the dataset
dataset.export(
    export_dir=export_dir,
    dataset_type=fo.types.COCODetectionDataset,
    label_field=label_field,
)
```
