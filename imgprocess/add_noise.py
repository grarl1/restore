import os
import argparse
import numpy as np
from PIL import Image

def uniform_noise(image, noise_ratio):
    '''Applies uniform noise to an image
    :param image: PIL.Image
    :param noise_ratio: Value between 0 and 1 indicating the percentage of noise to be added
    :return: Noisy image
    :rtype: PIL.Image
    '''
    # Get numpy array
    image_np = np.array(image)

    # Generate noise
    noise = np.random.uniform(0, 255, image_np.shape)

    # Apply noise
    noisy_image = image_np.copy()
    
    idx = np.random.rand(*noisy_image.shape) < noise_ratio
    noisy_image[idx] = noise[idx]

    return Image.fromarray(noisy_image.astype('uint8'))

def gaussian_noise(image, mean, stdev):
    '''Applies Gaussian noise to an image
    :param image: PIL.Image
    :param mean: Mean for Gauss distribution
    :param stdev: Standard deviation for Gauss distribution
    :return: Noisy image
    :rtype: PIL.Image
    '''
    # Log
    print ("{}: adding Gaussian noise with mean {} and stdev {}".format(__name__, mean, stdev))

    # Get numpy array
    image_np = np.array(image)

    # Generate noise
    noise = np.random.normal(mean, stdev, image_np.shape)

    # Apply noise
    noisy_image = np.clip(image_np + noise, 0, 255)

    return Image.fromarray(noisy_image.astype('uint8'))

def poisson_noise(image):
    '''Applies Poisson noise to an image
    :param image: PIL.Image
    :return: Noisy image
    :rtype: PIL.Image
    '''
    # Log
    print ("{}: adding Poisson noise".format(__name__))

    # Get numpy array
    image_np = np.array(image)

    # Generate noise
    noise = np.random.poisson(image_np, image_np.shape)

    # Apply noise
    noisy_image = np.clip(noise, 0, 255)

    return Image.fromarray(noisy_image.astype('uint8'))

def salt_and_pepper_noise(image, noise_ratio):
    '''Applies salt and pepper noise to an image
    :param image: PIL.Image
    :param noise_ratio: Value between 0 and 1 indicating the percentage of noise to be added
    :return: Noisy image
    :rtype: PIL.Image
    '''
    # Log
    print ("{}: adding salt and pepper noise with ratio {}".format(__name__, noise_ratio))

    # Get numpy array
    image_np = np.array(image)

    # Get dimensions
    nrows, ncols, _ = image_np.shape

    # Generate noise
    noise = np.random.randint(0, 2, (nrows, ncols)) * 255
    noise = np.repeat(noise[:, :, np.newaxis], 3, axis=2)

    # Apply noise
    noisy_image = image_np.copy()

    # Apply the noise to each channel
    idx = np.random.rand(nrows, ncols) < noise_ratio
    idx = np.repeat(idx[:, :, np.newaxis], 3, axis=2)
    noisy_image[idx] = noise[idx]

    return Image.fromarray(noisy_image.astype('uint8'))

def add_noise_to_images(input_dir, output_dir, noise_function, noise_args):
    for item in os.listdir(input_dir):
        # Get image path
        print("Procesing {}".format(item))
        path = os.path.join(input_dir, item)

        # Only process files
        if os.path.isfile(path):
            image = Image.open(path)
            
            # Process
            args = [image] + noise_args
            noisy_image = noise_function(*args)

            # Save images
            noisy_image.save(os.path.join(output_dir, item))


_noise_functions = {
    "uniform": uniform_noise,
    "gaussian": gaussian_noise,
    "poisson": poisson_noise,
    "salt_pepper": salt_and_pepper_noise
}

if __name__ == "__main__":
    # Define parser
    parser = argparse.ArgumentParser(description='Add noise to images in a directory')
    parser.add_argument('-i', '--input_dir', type=str, required=True, help='Input directory')
    parser.add_argument('-o', '--output_dir', type=str, required=True, help='Output directory')
    parser.add_argument('-n', '--noise_type', type=str, required=True, choices=_noise_functions.keys(), help='Type of noise to be added.')
    parser.add_argument('-r', '--ratio', type=float, default=0.1, help='Noise ratio. Only applicable to uniform or salt and pepper noises')
    parser.add_argument('-m', '--mean', type=float, default=0.0, help='Mean. Only applicable to gaussian noise')
    parser.add_argument('-s', '--stdev', type=float, default=1.0, help='Standard deviation. Only applicable to gaussian noise')

    # Parse args
    args = parser.parse_args()

    # Create output dir
    if not os.path.exists(args.output_dir):
        print("Creating {}".format(args.output_dir))
        os.makedirs(args.output_dir)

    # Prepare args
    noise_args = []
    if args.noise_type == "gaussian":
        noise_args.extend([args.mean, args.stdev])
    if args.noise_type in ("uniform", "salt_pepper"):
        noise_args.extend([args.ratio])

    # Add noise
    add_noise_to_images(args.input_dir, args.output_dir, _noise_functions[args.noise_type], noise_args)
