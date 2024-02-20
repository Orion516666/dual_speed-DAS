clear;
load('saved_data\boundary_coordinates.mat');
x = boundary_coords(:, 1);
y = boundary_coords(:, 2);


F2 = 1600e4;
F1 = 1500e4;

m = 600;
n = 600;
a = 200;
b = 600;

tic; 
tof = sqrt((x - m).^2 + (y - n).^2) / F2 + sqrt((x - a).^2 + (y - b).^2) / F1;
min_tof = min(tof(:));
tof_time = toc


% x = [2, 3]';
% x = repmat(x, 1, 2);
% 
% y = [3, 1]';
% y = repmat(y, 1, 2);
% 
% F2 = 2;
% F1 = 1;
% 
% m = [0, 1]';
% % m = repmat(m, 1, 2);
% 
% n = [0, 1]';
% a = [5, 6]';
% b = [6, 6]';
% 
% tic; 
% tof = sqrt((x - m).^2 + (y - n).^2) / F2 + sqrt((x - a).^2 + (y - b).^2) / F1;
% min_tof = min(tof(:));
% tof_time = toc

