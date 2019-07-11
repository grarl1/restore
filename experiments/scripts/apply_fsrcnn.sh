# Check arguments
if [ $# != 1 ]
then
    echo "Usage: $0 input_dir"
    exit 1
fi

# Process arguments
INPUT_DIR=`readlink -f $1`
OUTPUT_DIR=${INPUT_DIR}_fsrcnn
mkdir -p $OUTPUT_DIR

# Go to repo
cd /home/rual/workspace/master/tfm/restore/CNN_Keras

# Set net
unlink checkpoint
unlink config.ini
ln -s saved_checkpoints/FSRCNN/checkpoint
ln -s saved_checkpoints/FSRCNN/config.ini

# Apply
ls $INPUT_DIR | xargs -I % sh -c "python main.py -i $INPUT_DIR/% -o $OUTPUT_DIR/%"

# Clean
unlink checkpoint
unlink config.ini

# Come back
cd -
