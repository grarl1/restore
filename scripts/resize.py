import os
import sys
import argparse
from PIL import Image

def resize(scale, downsample, input_dir, output_dir):
    for item in os.listdir(input_dir):
        print("Procesing {}".format(item))
        f = os.path.join(input_dir, item)
        if os.path.isfile(f):
            image = Image.open(f)
            (width, height) = image.size
            if downsample:
                image = image.crop((0, 0, width - width % scale, height - height % scale))
                (new_width, new_height) = width // scale, height // scale
            else:
                (new_width, new_height) = width * scale, height * scale
            scaled_image = image.resize((new_width, new_height), Image.BICUBIC)
            if not os.path.exists(output_dir):
                print("Creating {}".format(output_dir))
                os.makedirs(output_dir)
            scaled_image.save(os.path.join(output_dir, item))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Resize images in a directory')
    parser.add_argument('-i', '--input_dir', required=True, help='Input directory')
    parser.add_argument('-o', '--output_dir', required=True, help='Output directory')
    parser.add_argument('-s', '--scale', required=True, help='Scale')
    parser.add_argument('--downsample', action='store_true', help='If specified the image will be reduced according to the scale')
    args = parser.parse_args()
    resize(int(args.scale), bool(args.downsample), args.input_dir, args.output_dir)
