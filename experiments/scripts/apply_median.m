addpath("matlib")
input_folders = dir(fullfile("../output/downscale_noise/set*"));

output_path = "../output/downscale_noise_median";
disp("Creating " + output_path);
mkdir(output_path);

for i=1:length(input_folders)
   input_folder = fullfile(input_folders(i).folder, input_folders(i).name);
   output_folder = fullfile(output_path, input_folders(i).name);
   r_median(input_folder, output_folder);
end