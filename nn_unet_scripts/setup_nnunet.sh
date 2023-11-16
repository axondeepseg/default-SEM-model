#!/bin/bash
# This script sets up the nnUNet environment and runs the preprocessing and dataset integrity verification
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 PATH_TO_ORIGINAL_DATASET RESULTS_DIR"
    exit 1
fi

config="2d"                     
dataset_id=1   

PATH_TO_ORIGINAL_DATASET=$1
RESULTS_DIR=$(realpath $2)

echo "-------------------------------------------------------"
echo "Converting dataset to nnUNetv2 format"
echo "-------------------------------------------------------"

# Run the conversion script
python nn_unet_scripts/convert_from_bids_to_nnunetv2_format.py $PATH_TO_ORIGINAL_DATASET --TARGETDIR $RESULTS_DIR

# Set up the necessary environment variables
export nnUNet_raw="$RESULTS_DIR/nnUNet_raw"
export nnUNet_preprocessed="$RESULTS_DIR/nnUNet_preprocessed"
export nnUNet_results="$RESULTS_DIR/nnUNet_results"

echo "-------------------------------------------------------"
echo "Running preprocessing and verifying dataset integrity"
echo "-------------------------------------------------------"

nnUNetv2_plan_and_preprocess -d ${dataset_id} --verify_dataset_integrity -c ${config}