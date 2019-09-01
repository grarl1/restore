# Check arguments
if [ $# != 1 ]
then
    echo "Usage: $0 input_dir"
    exit 1
fi

# Process arguments
INPUT_DIR=`readlink -f $1`
OUTPUT_DIR=${INPUT_DIR}_bicubic
mkdir -p $OUTPUT_DIR

# Apply
ls $INPUT_DIR | xargs -I % sh -c "python resize.py -i $INPUT_DIR/% -o $OUTPUT_DIR/% -s 2"
