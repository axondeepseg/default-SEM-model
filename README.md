# model_seg_rat_axon-myelin_sem
---
## Model overview
(image of segmentation obtained from this model)

AxonDeepSeg default SEM model and testing image. This model works at a resolution of 0.1 micrometer per pixel and was trained on rat spinal cord data collected via a Scanning Electron Microscope (SEM).

## Dependencies
- [ivadomed](https://ivadomed.org/) commit: XXX
- [axondeepseg](https://axondeepseg.readthedocs.io/en/latest/) commit: XXX

## Clone this repository
```
git clone MODEL_REPO_URL
```

## Get the data
- git@data.neuro.polymtl.ca:datasets/dataset-used-to-train-the-model
- commit XXX

```
git clone git@data.neuro.polymtl.ca:datasets/dataset-used-to-train-the-model
cd dataset-used-to-train-the-model
git annex get .
```

## Train this model
To train the model, please first update the following fields in the training config file:
- `fname_split`: full path to the split_dataset.joblib file
- `path_data`: full path to training data
- `gpu_ids`: specific to your hardware
- `path_output`: where the model will be saved
Then, you can train the model with
```
ivadomed --train -c path_to_config_file.json
```

## Test this model
To test the model, use
```
ivadomed --test -c path_to_config_file.json
```

## Segment with this model
To segment an image using this model, use
```
axondeepseg -t <MODALITY> -i <IMG_PATH> -m <path_to_model_folder> -s <PIXEL_SIZE>
```

# OLD::::


# Steps to train this model
1. Get `ivadomed` version: [[55fc2067]](https://github.com/ivadomed/ivadomed/commit/55fc2067cbb9c97a711e32cf8b5a377fb6d517be)
2. Get the data: `data_axondeepseg_sem` (Dataset Annex version: 1cddcc6bef21782b22ff17f34502c6e90e22c504)
3. Copy the "model_seg_rat_axon-myelin_sem.json" and "split_dataset.joblib" files, and update the following fields: `fname_split`, `path_output`, `path_data` and `gpu_ids`.
4. Run ivadomed: `ivadomed -c path/to/the/config/file`
5. The trained model file will be saved under the `path_output` directory.
