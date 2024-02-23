% clear
% load('saved_data/boundary_coordinates.mat');
% % show boundary
% % 提取 x 和 y 坐标
% boundary_x = boundary_coords(:, 1);
% boundary_y = boundary_coords(:, 2);
% 
% point = [472, 601];
% tic
% point_in_polygon = is_point_in_polygon(point, boundary_coords)
% time = toc

clear
% 创建一个 120x120 的网格
grid_size = 1200;
grid = zeros(grid_size, grid_size);

% 射线的斜率
sensor_x = 201;
sensor_y = 601;
grid(sensor_x, sensor_y) = 1;


% 从 (0, 0) 点开始移动

source_x = 455;
source_y = 601;

grid(source_x, source_y) = 1;


sensor_x = sensor_x - source_x;
sensor_y = sensor_y - source_y;

x = 0;
y = 0;

slope = sensor_y / sensor_x;


% 沿着射线移动并确定经过的格点

if  abs(slope) <= 1
    for i = 1:abs(sensor_x)
        y = round(x*slope);
        grid(x+source_x, y+source_y) = 1;
        x = x + sensor_x/abs(sensor_x);
    end
else
    for i = 1:abs(sensor_y)
        x = round(y/slope);
        grid(x+source_x, y+source_y) = 1;
        y = y + sensor_y/abs(sensor_y);
    end
end

% 显示网格
figure
imagesc(grid);
