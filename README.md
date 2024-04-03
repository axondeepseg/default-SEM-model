# model_seg_rat_axon-myelin_sem
---

## Model overview
![image of segmentation obtained from this model](sem_model_preview.png)

AxonDeepSeg default SEM model and testing image. This model works at a resolution of 0.1 micrometer per pixel and was trained on rat spinal cord data collected via a Scanning Electron Microscope (SEM).

## Segment (ADS)
To segment an image using this model, use the following command in an `axondeepseg` virtual environment:
```
axondeepseg -t SEM -i <IMG_PATH> -s <PIXEL_SIZE>
```
The `-m` option can be omitted in this case because this is a default built-in model.

## Train and test (ivadomed)
<details>
  <summary>Instructions </summary>

This model was trained and tested with [ivadomed](https://ivadomed.org). We recommend you install ivadomed in a virtual environment to reproduce the original training steps. The specific revision hash of the version used for training is documented in the *version_info.log* file.

### Clone this repository
You will need the *model_seg_rat_axon-myelin_sem.json* configuration file located in this repo.
```
git clone https://github.com/axondeepseg/default-SEM-model
```

### Get the data
The SEM dataset used to train this model is hosted on GitHub [here](https://github.com/axondeepseg/data_axondeepseg_sem). The specific dataset revision hash used for training is documented in the *version_info.log* file.

### Train this model
    
To train the model, please first update the following fields in the aforementioned JSON configuration file:
- `gpu_ids`: specific to your hardware
- `path_output`: where the model will be saved
- `loader_parameters:path_data`: path to training data
- `loader_parameters:bids_config`: path to the custom bids config located in `ivadomed/config/config_bids.json`
- `split_dataset:fname_split`: path to the split_dataset.joblib file

Then, you can train the model with
```
ivadomed --train -c path/to/model_seg_rat_axon-myelin_sem.json
```
The trained model file will be saved under the `path_output` directory. For more information about training models in `ivadomed`, please refer to the following [tutorial](https://ivadomed.org/tutorials/two_class_microscopy_seg_2d_unet.html).

### Evaluate this model
To test the performance of this model, use
```
ivadomed --test -c path_to_config_file.json
```
The evaluation results will be saved in `"path_output"/results_eval/evaluation_3Dmetrics.csv`

</details>

## Train and test with nnUNetv2

<details>
  <summary>Instructions </summary>

### Structure of the `nn_unet_scripts` Directory

This directory contains the following components:

- **Conversion Script**: This script, `convert_from_bids_to_nnunetv2_format.py`, is responsible for converting the SEM segmentation dataset from the BIDS format to the format expected by nnUNetv2. The script requires two arguments: the path to the original dataset and the target directory for the new dataset. Here is an example of how to run the script:
```bash
python scripts/convert_from_bids_to_nnunetv2_format.py <PATH/TO/ORIGINAL/DATASET> --TARGETDIR <PATH/TO/NEW/DATASET>
```
For more information about the script and its additional arguments, run the script with the `-h` flag:
```bash
python scripts/convert_from_bids_to_nnunetv2_format.py -h
```
- **Setup Script**: This script sets up the nnUNet environment and runs the preprocessing and dataset integrity verification. To run execute the following command: 
```bash
source nn_unet_scripts/setup_nnunet.sh <PATH/TO/ORIGINAL/DATASET> <PATH/TO/SAVE/RESULTS> [DATASET_ID] [LABEL_TYPE] [DATASET_NAME]
```
- **Training Script**: This script is used to train the nnUNet model. It requires four arguments:
    - `DATASET_ID`: The ID of the dataset to be used for training. This should be an integer.
    - `DATASET_NAME`: The name of the dataset. This will be used to form the full dataset name in the format "DatasetNUM_DATASET_NAME".
    - `DEVICE`: The device to be used for training. This could be a GPU device ID or 'cpu' for CPU, 'mps' for M1/M2 or 'cuda' for any GPU.
    - `FOLDS`: The folds to be used for training. This should be a space-separated list of integers.
To run the training script, execute the following command:
```bash
./nn_unet_scripts/train_nnunet.sh <DATASET_ID> <DATASET_NAME> <DEVICE> <FOLDS...>
```


- **Train Test Split File**: This file is a JSON file that contains the training and testing split for the dataset. It is used by the conversion script above. The file should be named `train_test_split.json` and placed in the same directory as the dataset.



### Setting Up Conda Environment

To set up the environment and run the scripts, follow these steps:

1. Create a new conda environment:
```bash
conda create --name sem_seg
```
2. Activate the environment:
```bash
conda activate sem_seg
```
3. Install PyTorch, torchvision, and torchaudio. For NeuroPoly lab members using the GPU servers, use the following command:
```bash
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
```
For others, please refer to the PyTorch installation guide at https://pytorch.org/get-started/locally/ to get the appropriate command for your system.

4. Update the environment with the remaining dependencies:
```bash
conda env update --file environment.yaml
```
### Setting Up nnUNet
1. Activate the environment:
```bash
conda activate sem_seg
```

2. To train the model, first, you need to set up nnUNet and preprocess the dataset. This can be done by running the setup script:
```bash
source nn_unet_scripts/setup_nnunet.sh <PATH/TO/ORIGINAL/DATASET> <PATH/TO/SAVE/RESULTS> [DATASET_ID] [LABEL_TYPE] [DATASET_NAME]
```

### Training nnUNet

After setting up the nnUNet and preprocessing the dataset, you can train the model using the training script. The script requires the following arguments:
- `DATASET_ID`: The ID of the dataset to be used for training. This should be an integer.
- `DATASET_NAME`: The name of the dataset. This will be used to form the full dataset name in the format "DatasetNUM_DATASET_NAME".
- `DEVICE`: The device to be used for training. This could be a GPU device ID or 'cpu' for CPU, 'mps' for M1/M2 or 'cuda' for any GPU.
- `FOLDS`: The folds to be used for training. This should be a space-separated list of integers.
To run the training script, execute the following command:
```bash
./nn_unet_scripts/train_nnunet.sh <DATASET_ID> <DATASET_NAME> <DEVICE> <FOLDS...>
```

</details>

## Inference

After training the model, you can perform inference using the following command:
```bash
python scripts/nn_unet_inference.py --path-dataset ${RESULTS_DIR}/nnUNet_raw/Dataset<FORMATTED_DATASET_ID>_<DATASET_NAME>/imagesTs --path-out <WHERE/TO/SAVE/RESULTS> --path-model ${RESULTS_DIR}/nnUNet_results/Dataset<FORMATTED_DATASET_ID>_<DATASET_NAME>/nnUNetTrainer__nnUNetPlans__2d/ --use-gpu --use-best-checkpoint
```
The `--use-best-checkpoint` flag is optional. If used, the model will use the best checkpoints for inference. If not used, the model will use the latest checkpoints. Based on empirical results, using the `--use-best-checkpoint` flag is recommended.

Note: `<FORMATTED_DATASET_ID>` should be a three-digit number where 1 would become 001 and 23 would become 023.
