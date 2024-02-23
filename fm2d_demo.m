% Time comparison C++ code vs Matlab code
clear;
addpath('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\tof');
%% Setup
% Allow for non-semicolon-ended output
%#ok<*NOPTS>

m = 1200; % Num of y nodes
n = m;   % Num of x nodes

% Grid distances
dx = 1e-4;
dy = 1e-4;

% % Speed map
% % 创建一个大小为 1200x1200 的矩阵，初始值设为 1500
% F = 1500 * ones(m);
% 
% % 假设 circle_x 和 circle_y 是圆的坐标
% % 将圆心坐标映射到矩阵的索引
% x_center = 600; % 圆心 x 坐标在矩阵中的索引
% y_center = 600; % 圆心 y 坐标在矩阵中的索引
% 
% % 计算圆的半径
% % radius = 400; % 假设圆的半径为 400
% 
% % 根据圆的坐标信息，将圆内的点设为 1600
% for i = 1:1200
%     for j = 1:1200
%         if ((i - x_center)^2 + (j - y_center)^2) <= 150^2
%             F(i, j) = 1550;
%         end
%     end
% end

% 创建F
load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\boundary_coordinates.mat');

% show boundary
% 提取 x 和 y 坐标
boundary_x = boundary_coords(:, 1);
boundary_y = boundary_coords(:, 2);

point = [450, 600];

% [x, y] = ndgrid(563:563, 727:727);
[x, y] = ndgrid(401:800, 401:800);

coords = [x(:), y(:)];
[num_points, ~] = size(coords);

% point_result = zeros(num_points, 1);
F = 1500 * ones(1200, 1200);

for i = 1:num_points
    % 获取当前行的坐标
    current_point = coords(i, :);
    point_in_polygon = is_point_in_polygon(current_point, boundary_coords);
    if  point_in_polygon
        F(current_point(1), current_point(2)) = 1550;
        % point_result(i) = point_in_polygon;
    end
end


% Source points
SPs = [450, 600]' * 1e-4;


%% Solve for T (distance map)
% Matlab version (with class heap implementation)
tic; 
% T1 = fm(F,SPs,[dx dy],'imp','mat','order',1); 
T1 = fm2d(F,SPs,dx,dy,int32(1)); 
T1time = toc 

load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\sensor_pos_2d.mat');
rows = sensor_pos(:, 1);
cols = sensor_pos(:, 2);

% 使用子索引从 grid 中提取对应位置的值
values = T1(sub2ind(size(T1), rows, cols));

