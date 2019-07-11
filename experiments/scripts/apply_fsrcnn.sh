# Go to repo
cd /home/rual/workspace/master/tfm/restore/CNN_Keras

# Set net
unlink checkpoint
unlink config.ini
ln -s saved_checkpoints/FSRCNN/checkpoint
ln -s saved_checkpoints/FSRCNN/config.ini

INPUT_DIR=/home/rual/workspace/master/tfm/restore/experiments/output/downscale_noise_ircnn
OUTPUT_DIR=/home/rual/workspace/master/tfm/restore/experiments/output/downscale_noise_ircnn_fsrcnn
mkdir -p $OUTPUT_DIR

ls $INPUT_DIR | xargs -I % sh -c "python main.py -i $INPUT_DIR/% -o $OUTPUT_DIR/%"

# Clean
unlink checkpoint
unlink config.ini

# Come back
cd -
