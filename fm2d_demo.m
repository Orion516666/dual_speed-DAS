% Time comparison C++ code vs Matlab code
clear;
addpath('E:\联影\2023_12_USPA_imaging\dual_speed-DAS\fm2d');
%% Setup
% Allow for non-semicolon-ended output
%#ok<*NOPTS>

m = 1200; % Num of y nodes
n = m;   % Num of x nodes

% Grid distances
dx = 1e-4;
dy = 1e-4;

% Speed map
% 创建一个大小为 1200x1200 的矩阵，初始值设为 1500
F = 1500 * ones(m);

% 假设 circle_x 和 circle_y 是圆的坐标
% 将圆心坐标映射到矩阵的索引
x_center = 600; % 圆心 x 坐标在矩阵中的索引
y_center = 600; % 圆心 y 坐标在矩阵中的索引

% 计算圆的半径
% radius = 400; % 假设圆的半径为 400

% 根据圆的坐标信息，将圆内的点设为 1600
for i = 1:1200
    for j = 1:1200
        if ((i - x_center)^2 + (j - y_center)^2) <= 150^2
            F(i, j) = 1600;
        end
    end
end


% Source points
SPs = [600 600]' * 1e-4;


%% Solve for T (distance map)
% Matlab version (with class heap implementation)
tic; 
% T1 = fm(F,SPs,[dx dy],'imp','mat','order',1); 
T1 = fm2d(F,SPs,dx,dy,int32(1)); 
T1time = toc 

