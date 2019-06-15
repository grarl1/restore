import os
import argparse
import tensorlayer as tl
import numpy as np

def add_noise(image, noise_ratio):
    rows, cols, channels = image.shape
    noise_mask = np.ones((rows, cols, channels))
    sub_noise_sum = round(noise_ratio * cols)
    for k in range(channels):
        for i in range(rows):
            tmp = np.random.permutation(cols)
            noise_idx = np.array(tmp[:sub_noise_sum])
            noise_mask[i, noise_idx, k] = 0
    return image * noise_mask

def add_noise_to_dataset(input_dir, output_dir, noise_ratio):
    for item in os.listdir(input_dir):
        print("Procesing {}".format(item))
        f = os.path.join(input_dir, item)
        if os.path.isfile(f):
            image = tl.vis.read_image(f)
            noisy_image = add_noise(image, noise_ratio) 
            tl.vis.save_image(noisy_image, os.path.join(output_dir, item))

if __name__ == "__main__":
    # Create parser
    parser = argparse.ArgumentParser(description='Add noise to images in a directory')
    parser.add_argument('-i', '--input_dir', required=True, help='Input directory')
    parser.add_argument('-o', '--output_dir', required=True, help='Output directory')
    parser.add_argument('-r', '--ratio', required=True, help='Noise ratio')

    # Parse args
    args = parser.parse_args()

    # Create output dir
    if not os.path.exists(args.output_dir):
        print("Creating {}".format(args.output_dir))
        os.makedirs(args.output_dir)

    # Resize
    add_noise_to_dataset(args.input_dir, args.output_dir, float(args.ratio))
