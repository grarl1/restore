import os
import sys
import argparse
from PIL import Image

def resize_image(image, scale, downsample=True):
    ''' Resizes an image
    :param image: PIL.Image to rescale
    :param scale: resize scale factor
    :param downsample: if true, the image will be reduced
    :return: resized image
    :rtype: PIL.Image
    '''
    # Get current size
    (width, height) = image.size

    # Process sampling
    if downsample:
        image = image.crop((0, 0, width - width % scale, height - height % scale))
        (new_width, new_height) = width // scale, height // scale
        filter_ = Image.LANCZOS
    else:
        (new_width, new_height) = width * scale, height * scale
        filter_ = Image.BICUBIC

    # Resize 
    return image.resize((new_width, new_height), filter_)


def resize_images(input_dir, output_dir, scale, downsample):
    ''' Resize a set of images
    :param input_dir: input directory containing images
    :param output_dir: output directory to store images (will be created if not existing)
    :param scale: resize scale factor
    :param downsample: if true, the image will be reduced
    '''
    for item in os.listdir(input_dir):
        # Get image path
        print("Procesing {}".format(item))
        image_path = os.path.join(input_dir, item)

        # Only process files
        if os.path.isfile(image_path):

            # Open image and get size
            image = Image.open(image_path)
            scaled_image = resize_image(image, scale, downsample)
            scaled_image.save(os.path.join(output_dir, item))
            
if __name__ == "__main__":
    # Create parser
    parser = argparse.ArgumentParser(description='Resize images in a directory')
    parser.add_argument('-i', '--input_dir', required=True, help='Input directory')
    parser.add_argument('-o', '--output_dir', required=True, help='Output directory')
    parser.add_argument('-s', '--scale', required=True, help='Scale')
    parser.add_argument('--downsample', action='store_true', help='If specified the image will be reduced according to the scale')

    # Parse args
    args = parser.parse_args()

    # Create output dir
    if not os.path.exists(args.output_dir):
        print("Creating {}".format(args.output_dir))
        os.makedirs(args.output_dir)

    # Resize
    resize_images(args.input_dir, args.output_dir, int(args.scale), bool(args.downsample))

