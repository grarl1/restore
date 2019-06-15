% Reduce noise using imbilatfilt

input_path = "~/Pictures";
output_path = "output";

disp("Creating " + output_path);
mkdir(output_path);

files = dir(fullfile(input_path,'*.bmp'));
for i = 1:length(files)
    in_file_name = files(i).name;
    disp("Processing " + in_file_name)
    in_abs_path = fullfile(input_path, in_file_name);
    in_image = imread(in_abs_path);
    out_image = imbilatfilt(in_image);
    %out_image = medfilt3(in_image);
    imwrite(out_image, fullfile(output_path, in_file_name));
end