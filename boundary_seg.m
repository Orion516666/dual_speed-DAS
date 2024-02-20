clear;
% 
% load('transducer_order.mat');
% % load('demo_sensor_data.mat');
% load('phantom_sos.mat');
% % 5Mhz toneBurst, dt: 17.2913ns, t_end: 126.002us, time steps: 7288

% num_sensor_points = 256;
% sensor_radius = 400;
% % sample_freq = 1 / 17.2913e-9;
% 
% boundary_coords = zeros(256,2);
% 
% for channel_index = 1:num_sensor_points
%     % [channel_data, sample_freq, rowIndex, colIndex];
%     sensor_data_filename = sprintf('sensor_data/sensor%d_data.mat', channel_index);
%     load(sensor_data_filename);
% 
%     % temporal window  探头到phantom边界和到phantom的1/4
%     chan_data_aic = channel_data(transducer_order(channel_index), 1542:2313);
% 
%     % Akaike information criterion (AIC) picker algorithm
%     boundary_index = AIC_picker(chan_data_aic) + 1541;
% 
%     x_tx = 601 + (sensor_radius - 0.5e4 * boundary_index / sample_freq * 1500) * (colIndex-601) / sensor_radius;
%     boundary_coords(transducer_order(channel_index), 1) = round(x_tx);
% 
%     y_tx = 601 + (sensor_radius - 0.5e4 * boundary_index / sample_freq * 1500) * (rowIndex-601) / sensor_radius;
%     boundary_coords(transducer_order(channel_index), 2) = round(y_tx);
% 
% end


load('saved_data/boundary_coordinates.mat');
% show boundary
% 提取 x 和 y 坐标
x = boundary_coords(:, 1);
y = boundary_coords(:, 2);

% 使用 fitcircle 函数拟合一个圆形模型
[x0, y0, R] = fitcircle(x, y);

% 绘制原始数据
plot(x, y, 'bo'); % 原始数据
hold on;

% 生成圆上的点
theta = linspace(0, 2 * pi, 100); % 角度范围
circle_x = x0 + R * cos(theta);
circle_y = y0 + R * sin(theta);

% 绘制拟合的圆
plot(circle_x, circle_y, 'r-');

% 设置图形标题和轴标签
xlim([0 1200]); % 设置 x 轴范围
ylim([0 1200]); % 设置 y 轴范围
title('Fitted Circle');
xlabel('X Coordinate');
ylabel('Y Coordinate');


% % 创建一个大小为 1200x1200 的矩阵，初始值设为 1500
% image_matrix = 1500 * ones(1200);
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
%         if ((i - x_center)^2 + (j - y_center)^2) <= R^2
%             image_matrix(i, j) = 1600;
%         end
%     end
% end
% 
% % 显示图像
% imagesc(image_matrix);
% colormap('gray');
% colorbar;
% axis image;
% 








function [x0, y0, R] = fitcircle(x, y)
    % 圆的一般方程形式 x^2 + y^2 + a*x + b*y + c = 0
    % 求解 a b c 即可
    n = length(x);
    A = [x, y, ones(n, 1)];
    y = -(x.^2 + y.^2);
    x = A\y;
    a = x(1);
    b = x(2);
    c = x(3);
    % 圆心、半径
    x0 = -a/2;
    y0 = -b/2;
    R = sqrt((a^2 + b^2) / 4 - c);
end


% % flight_distance = 40e-3;
% flight_distance = 126.4911e-3;
% flight_distance = 60e-3;
% tof = flight_distance / 1500;
% 
% step = tof / 17.2913e-9