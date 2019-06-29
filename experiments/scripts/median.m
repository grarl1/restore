% Reduce noise using imbilatfilt
function [] = denoise_bilat(input_path, output_path)

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
        R = in_image(:,:,1);
		G = in_image(:,:,2);
		B = in_image(:,:,3);
		out_image(:,:,1) = medfilt2(R);
		out_image(:,:,2) = medfilt2(G);
		out_image(:,:,3) = medfilt2(B);
        imwrite(out_image, fullfile(output_path, in_file_name));
	else
        disp("Skipping " + in_file_name)
	end
    end

end
