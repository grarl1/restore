% Reduce noise using imbilatfilt
function [psnr_v, ssim_v, names_v] = metrics(input_ref_path, input_test_path)

    % Get lists of files
    ref_files = dir(fullfile(input_ref_path,'*'));
    test_files = dir(fullfile(input_test_path,'*'));
    if length(ref_files) ~= length(test_files)
        disp("Warning: Directories don't have the same number of files");
    end
    
    % Process
    for i = 1:length(ref_files)
        if ref_files(i).name ~= test_files(i).name
            disp("Warning: Comparing " + ref_files(i).name + " with " + test_files(i).name);
        end
        
        in_ref_file_name = ref_files(i).name;
        in_ref_abs_path = fullfile(input_ref_path, in_ref_file_name);
        in_test_file_name = test_files(i).name;
        in_test_abs_path = fullfile(input_test_path, in_test_file_name);
        
        % Process only files
        if isfile(in_ref_abs_path) && isfile(in_test_abs_path)
            %disp("Processing " + in_ref_abs_path + " vs " + in_test_abs_path);
            % Read images
            in_ref_image = imread(in_ref_abs_path);
            in_test_image = imread(in_test_abs_path);
            
            % Crop remainder
            if isequal(size(in_ref_image), size(in_test_image)) == 0
                disp("Cropping " + mat2str(in_ref_file_name))
                [r, c, ch] = size(in_test_image);
                in_ref_image = imcrop(in_ref_image, [1 1 c-1 r-1]);
            end

            % Test
            psnr_v(i-2) = psnr(in_test_image, in_ref_image);
            ssim_v(i-2) = ssim(in_test_image, in_ref_image);
            names_v(i-2) = string(in_test_abs_path);
        else
            disp("Skipping " + in_ref_abs_path + " and " + in_test_abs_path);
        end
    end

end
