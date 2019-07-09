#!/bin/bash

REPOROOT=/home/rual/workspace/master/tfm/restore/
S5D2=set5_downscale2
S14D2=set14_downscale2

function downscale() {
    python ${REPOROOT}/experiments/scripts/resize.py -i ${REPOROOT}/datasets/Test/Set5 -o ${REPOROOT}/experiments/$S5D2 -s 2 --downsample
    python ${REPOROOT}/experiments/scripts/resize.py -i ${REPOROOT}/datasets/Test/Set14 -o ${REPOROOT}/experiments/$S14D2 -s 2 --downsample
}

function apply_noise() {
    python ${REPOROOT}/CNN_Keras/noise.py -i ${REPOROOT}/experiments/$S5D2 -o ${REPOROOT}/experiments/${S5D2}_$1 -n $1 
    python ${REPOROOT}/CNN_Keras/noise.py -i ${REPOROOT}/experiments/$S14D2 -o ${REPOROOT}/experiments/${S14D2}_$1 -n $1
}

function apply_noise_ratio() {
    python ${REPOROOT}/CNN_Keras/noise.py -i ${REPOROOT}/experiments/$S5D2 -o ${REPOROOT}/experiments/${S5D2}_$1$2 -n $1 -r $2
    python ${REPOROOT}/CNN_Keras/noise.py -i ${REPOROOT}/experiments/$S14D2 -o ${REPOROOT}/experiments/${S14D2}_$1$2 -n $1 -r $2
}

function apply_noise_stdev() {
    python ${REPOROOT}/CNN_Keras/noise.py -i ${REPOROOT}/experiments/$S5D2 -o ${REPOROOT}/experiments/${S5D2}_$1$2 -n $1 -s $2
    python ${REPOROOT}/CNN_Keras/noise.py -i ${REPOROOT}/experiments/$S14D2 -o ${REPOROOT}/experiments/${S14D2}_$1$2 -n $1 -s $2
}

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
