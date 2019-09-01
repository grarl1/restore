% Reduce noise using imbilatfilt
function [] = r_wavelet(input_path, output_path)

    % Create output dir
    disp("Creating " + output_path);
    mkdir(output_path);
    
    files = dir(fullfile(input_path,'*'));
    for i = 1:length(files)
        in_file_name = files(i).name;
        in_abs_path = fullfile(input_path, in_file_name);
	% Process only files
	if isfile(in_abs_path)
        disp("Processing " + in_file_name)
        in_image = imread(in_abs_path);
	    % Apply filter
        out_image = uint8(wdenoise2(in_image));
        imwrite(out_image, fullfile(output_path, in_file_name));
	else
        disp("Skipping " + in_file_name)
	end
    end

end
