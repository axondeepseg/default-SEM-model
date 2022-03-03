# model_seg_rat_axon-myelin_sem
---

## Model overview
![image of segmentation obtained from this model](sem_model_preview.png)

AxonDeepSeg default SEM model and testing image. This model works at a resolution of 0.1 micrometer per pixel and was trained on rat spinal cord data collected via a Scanning Electron Microscope (SEM).

## Dependencies
- [ivadomed](https://ivadomed.org/) commit: e6554281d07b5afef9e68ce8b02e86b02bd68363
- [axondeepseg](https://axondeepseg.readthedocs.io/en/latest/) commit: 805868e39eddf620c9f3d60d313cadffb1121bfb

## Segment (ADS)
To segment an image using this model, use the following command in an `axondeepseg` virtual environment:
```
axondeepseg -t SEM -i <IMG_PATH> -s <PIXEL_SIZE>
```
The `-m` option can be omitted in this case because this is a default built-in model.

## Train and test (ivadomed)
This model was trained and tested with `ivadomed` on commit **e65542**. We recommand to install ivadomed in a separate virtual environment to reproduce the original training steps. Inside your venv, make sure you are on the right commit:
```
git clone https://github.com/neuropoly/ivadomed.git
cd ivadomed
git checkout e6554281d07b5afef9e68ce8b02e86b02bd68363
pip install -e .
```

### Clone this repository
You will need the *model_seg_rat_axon-myelin_sem.json* configuration file located in this repo.
```
git clone https://github.com/axondeepseg/default-SEM-model
```

### Get the data
The SEM dataset used to train this model is hosted on github:
- https://github.com/axondeepseg/data_axondeepseg_sem
- commit d7884f9ab6cd8f06cba4885e752988a7706f0ede

```
git clone https://github.com/axondeepseg/data_axondeepseg_sem
cd data_axondeepseg_sem
git checkout d7884f9ab6cd8f06cba4885e752988a7706f0ede
```

### Train this model
To train the model, please first update the following fields in the aforementioned json configuration file:
- `gpu_ids`: specific to your hardware
- `path_output`: where the model will be saved
- `loader_parameters:path_data`: path to training data
- `loader_parameters:bids_config`: path to the custom bids config located in `ivadomed/config/config_bids.json`
- `split_dataset:fname_split`: path to the split_dataset.joblib file

Then, you can train the model with
```
ivadomed --train -c path/to/model_seg_rat_axon-myelin_sem.json
```
The trained model file will be saved under the `path_output` directory.

### Evaluate this model
To test the performance of this model, use
```
ivadomed --test -c path_to_config_file.json
```
The evaluation results will be saved in `"path_output"/results_eval/evaluation_3Dmetrics.csv`
