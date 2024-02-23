clear
load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\boundary_coordinates.mat');
load('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data\sensor_pos_2d.mat');

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
F = 1500e4 * ones(1200, 1200);

tic
for i = 1:num_points
    % 获取当前行的坐标
    current_point = coords(i, :);
    point_in_polygon = is_point_in_polygon(current_point, boundary_coords);
    if  point_in_polygon
        F(current_point(1), current_point(2)) = 1550e4;
        % point_result(i) = point_in_polygon;
    end
end
time = toc


TOF = one_point_tof(point, sensor_pos, F);

