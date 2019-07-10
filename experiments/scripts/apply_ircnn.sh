# Go to repo
cd /home/rual/workspace/master/tfm/restore/CNN_Keras

# Set net
unlink checkpoint
unlink config.ini
ln -s saved_checkpoints/IRCNN/checkpoint
ln -s saved_checkpoints/IRCNN/config.ini

INPUT_DIR=/home/rual/workspace/master/tfm/restore/experiments/output/downscale_noise
OUTPUT_DIR=/home/rual/workspace/master/tfm/restore/experiments/output/downscale_noise_ircnn
mkdir -p $OUTPUT_DIR

ls $INPUT_DIR | xargs -I % sh -c "echo python main.py -i $INPUT_DIR/% -o $OUTPUT_DIR/%"

# Clean
unlink checkpoint
unlink config.ini

# Come back
cd -
