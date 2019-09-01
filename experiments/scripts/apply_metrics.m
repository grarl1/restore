addpath("matlib")

ref_dir = "../../datasets/Test/Set5";
test_dirs = dir(fullfile("../output/downscale_noise_ircnn_fsrcnn/set5*"));
[psnrs5, ssims5, names5] = apply_metrics_set(ref_dir, test_dirs);

ref_dir = "../../datasets/Test/Set14";
test_dirs = dir(fullfile("../output/downscale_noise_ircnn_fsrcnn/set14*"));
[psnrs14, ssims14, names14] = apply_metrics_set(ref_dir, test_dirs);

clear ref_dir test_dirs

psnr_set5 = mean(psnrs5, 2);
ssim_set5 = mean(ssims5, 2);
psnr_set14 = mean(psnrs14, 2);
ssim_set14 = mean(ssims14, 2);

clear names5 names14
clear psnrs5 psnrs14
clear ssims5 ssims14

all = [psnr_set5 ssim_set5 psnr_set14 ssim_set14];

function [psnrs, ssims, names] = apply_metrics_set(ref_dir, test_dirs)
    psnrs = [];
    ssims = [];
    names = [];

    for i=1:length(test_dirs)
        test_dir = fullfile(test_dirs(i).folder, test_dirs(i).name);
        [psnr_v, ssim_v, names_v] = metrics(ref_dir, test_dir);
        psnrs = [psnrs; psnr_v];
        ssims = [ssims; ssim_v];
        names = [names; names_v];
    end
end
