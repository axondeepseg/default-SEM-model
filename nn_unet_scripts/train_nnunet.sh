#!/bin/bash
#
# Training nnUNetv2 on multiple folds
#
# NOTE: This is a template script, modify it as needed
#
# Modified from the script by Naga Karthik and Jan Valosek
# located in: https://github.com/ivadomed/utilities/blob/main/scripts/run_nnunet.sh
#

config="2d"                     
dataset_id=1   
dataset_name=Dataset001_SEM     
nnunet_trainer="nnUNetTrainer"
DEVICE=$1 # No default device

# Check if the optional argument (folds) is provided
if [ "$#" -eq 1 ]; then
    folds=()
else
    # Convert the argument to an array of folds
    folds=("${@:2}") # Skip the first argument (DEVICE)
fi

for fold in ${folds[@]}; do
    echo "-------------------------------------------"
    echo "Training on Fold $fold"
    echo "-------------------------------------------"

    # Check if CUDA is enabled
    if [[ $DEVICE =~ ^[0-9]+$ ]]; then
        # training
        CUDA_VISIBLE_DEVICES=$DEVICE nnUNetv2_train ${dataset_id} ${config} ${fold} -tr ${nnunet_trainer}

        echo ""
        echo "-------------------------------------------"
        echo "Training completed, Testing on Fold $fold"
        echo "-------------------------------------------"

        # inference
        CUDA_VISIBLE_DEVICES=$DEVICE nnUNetv2_predict -i ${nnUNet_raw}/${dataset_name}/imagesTs -tr ${nnunet_trainer} -o ${nnUNet_results}/${nnunet_trainer}__nnUNetPlans__${config}/fold_${fold}/test -d ${dataset_id} -f ${fold} -c ${config}
    else
        # training
        nnUNetv2_train ${dataset_id} ${config} ${fold} -tr ${nnunet_trainer} -device ${DEVICE}

        echo ""
        echo "-------------------------------------------"
        echo "Training completed, Testing on Fold $fold"
        echo "-------------------------------------------"

        # inference
        nnUNetv2_predict -i ${nnUNet_raw}/${dataset_name}/imagesTs -tr ${nnunet_trainer} -o ${nnUNet_results}/${nnunet_trainer}__nnUNetPlans__${config}/fold_${fold}/test -d ${dataset_id} -f ${fold} -c ${config} -device ${DEVICE}
    fi

    echo ""
    echo "-------------------------------------------"
    echo " Inference completed on Fold $fold"
    echo "-------------------------------------------"

done