clear;
% load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\ROI_TOF.mat');

medium_speed = 1556;
load(sprintf('E:\\联影\\2023_12_USPA_imaging\\dual_speed-DAS\\saved_data\\ROI_tof_%d.mat', medium_speed));
load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\transducer_order.mat');
load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\sensor_data.mat');
load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\medium.mat');
load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\in_ROI.mat');

medium = medium(401:800, 401:800);

sample_interval = 17.2913e-9;
ROI_size = [400, 400];

% tic
[reconstruction_image, CF, in_out_ratio] = dual_speed_das(in_ROI, ROI_TOF, ROI_size, transducer_order, sensor_data, sample_interval);
% time = toc

figure;
imagesc(reconstruction_image);

title_name = sprintf('ROI tof %d  CF=%d  ratio=%d', medium_speed, CF, in_out_ratio);
title(title_name);
colorbar;
