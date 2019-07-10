#!/bin/bash

RESIZE=/home/rual/workspace/master/tfm/restore/experiments/scripts/resize.py
NOISE=/home/rual/workspace/master/tfm/restore/CNN_Keras/noise.py

SET5=/home/rual/workspace/master/tfm/restore/datasets/Test/Set5
SET14=/home/rual/workspace/master/tfm/restore/datasets/Test/Set14

S5NAME=set5
S14NAME=set14

OUTPUT_DOWNSCALE_DIR=/home/rual/workspace/master/tfm/restore/experiments/output/downscale
OUTPUT_DOWNSCALE_NOISE_DIR=/home/rual/workspace/master/tfm/restore/experiments/output/downscale_noise

function downscale() {
    python $RESIZE -i $SET5 -o $OUTPUT_DOWNSCALE_DIR/$S5NAME -s 2 --downsample
    python $RESIZE -i $SET14 -o $OUTPUT_DOWNSCALE_DIR/$S14NAME -s 2 --downsample
}

function apply_noise() {
    python $NOISE -i $OUTPUT_DOWNSCALE_DIR/$S5NAME -o $OUTPUT_DOWNSCALE_NOISE_DIR/${S5NAME}_$1 -n $1 
    python $NOISE -i $OUTPUT_DOWNSCALE_DIR/$S14NAME -o $OUTPUT_DOWNSCALE_NOISE_DIR/${S14NAME}_$1 -n $1
}

function apply_noise_ratio() {
    python $NOISE -i $OUTPUT_DOWNSCALE_DIR/$S5NAME -o $OUTPUT_DOWNSCALE_NOISE_DIR/${S5NAME}_$1$2 -n $1 -r $2
    python $NOISE -i $OUTPUT_DOWNSCALE_DIR/$S14NAME -o $OUTPUT_DOWNSCALE_NOISE_DIR/${S14NAME}_$1$2 -n $1 -r $2
}

function apply_noise_stdev() {
    python $NOISE -i $OUTPUT_DOWNSCALE_DIR/$S5NAME -o $OUTPUT_DOWNSCALE_NOISE_DIR/${S5NAME}_$1$2 -n $1 -s $2
    python $NOISE -i $OUTPUT_DOWNSCALE_DIR/$S14NAME -o $OUTPUT_DOWNSCALE_NOISE_DIR/${S14NAME}_$1$2 -n $1 -s $2
}

mkdir -p $OUTPUT_DOWNSCALE_DIR
mkdir -p $OUTPUT_DOWNSCALE_NOISE_DIR

downscale
apply_noise_ratio uniform 0.05
apply_noise_ratio uniform 0.10
apply_noise_ratio uniform 0.15
apply_noise_ratio uniform 0.20
apply_noise_ratio salt_pepper 0.05
apply_noise_ratio salt_pepper 0.10
apply_noise_ratio salt_pepper 0.15
apply_noise_ratio salt_pepper 0.20
apply_noise_stdev gaussian 0.05
apply_noise_stdev gaussian 0.10
apply_noise_stdev gaussian 0.15
apply_noise poisson
