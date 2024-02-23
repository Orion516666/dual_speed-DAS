% clear
% addpath('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data')
% load('boundary_coordinates.mat');
% % show boundary
% % 提取 x 和 y 坐标
% xv = boundary_coords(:, 1);
% yv = boundary_coords(:, 2);
% 
% xq = [516; 400];
% yq = [600; 400];
% 
% tic;
% [in,on] = inpolygon(xq,yq,xv,yv);
% time = toc
% 
% figure
% 
% plot(xv,yv) % polygon
% 
% hold on
% plot(xq(in&~on),yq(in&~on),'r+') % points strictly inside
% plot(xq(on),yq(on),'k*') % points on edge
% plot(xq(~in),yq(~in),'bo') % points outside
% hold off

%%
% clear
% addpath('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\saved_data')
% load('boundary_coordinates.mat');
% % show boundary
% % 提取 x 和 y 坐标
% boundary_x = boundary_coords(:, 1);
% boundary_y = boundary_coords(:, 2);
% 
% 
% % 生成一组测试点坐标
% [X, Y] = meshgrid(1:1:1200, 1:1:1200);
% test_points = [X(:) Y(:)];
% 
% tic
% % 使用 inpolygon 函数测试点是否在多边形内部
% in_polygon = inpolygon(test_points(:,1), test_points(:,2), boundary_x, boundary_y);
% 
% % 创建一个与测试点坐标数量相同的数组，并将其初始化为0
% values = zeros(size(test_points, 1), 1);
% 
% % 将内部点设置为1
% values(in_polygon) = 1;
% time=toc
% % % 将测试点和对应的值进行可视化
% scatter(test_points(:,1), test_points(:,2), [], values, 'filled');
% colormap([0 0 1; 1 0 0]); % 设置蓝色和红色的颜色映射


%% 
clear
addpath('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\fm2d')
load('saved_data/boundary_coordinates.mat');
% show boundary
% 提取 x 和 y 坐标
boundary_x = boundary_coords(:, 1);
boundary_y = boundary_coords(:, 2);

point = [472, 601];
tic
point_in_polygon = is_point_in_polygon(point, boundary_coords)
time = toc


%%
% clear
% addpath('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\fm2d');
% load('saved_data/boundary_coordinates.mat');
% source_point = [516, 600];
% sensor_point = [318, 318];
% tic
% a = one_point_tof(source_point, sensor_point, boundary_coords);
% time = toc



