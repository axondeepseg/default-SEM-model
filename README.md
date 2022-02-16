# model_seg_rat_axon-myelin_sem
---

## Model overview
(image of segmentation obtained from this model)

AxonDeepSeg default SEM model and testing image. This model works at a resolution of 0.1 micrometer per pixel and was trained on rat spinal cord data collected via a Scanning Electron Microscope (SEM).

## Dependencies
- [ivadomed](https://ivadomed.org/) commit: 55fc2067cbb9c97a711e32cf8b5a377fb6d517be
- [axondeepseg](https://axondeepseg.readthedocs.io/en/latest/) commit: 805868e39eddf620c9f3d60d313cadffb1121bfb

## Clone this repository
```
git clone https://github.com/axondeepseg/default-SEM-model
```

## Get the data
The SEM dataset used to train this model is hosted on github:
- https://github.com/axondeepseg/data_axondeepseg_sem
- commit d7884f9ab6cd8f06cba4885e752988a7706f0ede

```
git clone https://github.com/axondeepseg/data_axondeepseg_sem
```

## Train this model
To train the model, please first update the following fields in the training config file:
- `fname_split`: full path to the split_dataset.joblib file
- `path_data`: full path to training data
- `gpu_ids`: specific to your hardware
- `path_output`: where the model will be saved
Then, you can train the model with
```
ivadomed --train -c path/to/model_seg_rat_axon-myelin_sem.json
```

## Test this model
To test the model, use
```
ivadomed --test -c path_to_config_file.json
```

## Segment with this model
To segment an image using this model, use
```
axondeepseg -t SEM -i <IMG_PATH> -m <path_to_model_folder> -s <PIXEL_SIZE>
```
