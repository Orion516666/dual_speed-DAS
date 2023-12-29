%% 这是kwave_circle的代码
% ABOUT:
%       author               - Fan Zhang, Xinlong Dong(shanghaitech university)
%       date                 - 2023
%       last update          - 2023
clear;
kwavePath = 'C:\Users\Evan\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\k-Wave\k-Wave';
addpath(kwavePath, '-begin');
% create the computational grid
Nx = 256;    % number of grid points in the x (row) direction
Ny = 256;    % number of grid points in the y (column) direction
dx = 50e-6;  % grid point spacing in the x direction [m]
dy = 50e-6;  % grid point spacing in the y direction [m]
kgrid = makeGrid(Nx,dx,Ny,dy);

% define the medium properties
medium.sound_speed = 1500*ones(Nx, Ny);  % [m/s]
medium.density = 1000;                   % [kg/m^3]

% define an initial pressure using makeDisc
disc_x_pos = 128;                        % [grid points]
disc_y_pos = 128;                        % [grid points]
disc_radius = 8;                         % [grid points]
disc_mag = 100;                           % [Pa]
source.p0 = disc_mag*makeDisc(Nx, Ny, disc_x_pos, disc_y_pos, disc_radius);

c0 = medium.sound_speed;
% define a Cartesian sensor mask of a centered circle with 50 sensor elements
sensor_radius = 0.005;                    % [m]
% sensor.frequency_response = [2e6, 70];
num_sensor_points = 128;
sensor.mask = makeCartCircle(sensor_radius, num_sensor_points);

% run the simulation

%% GPU
% % 用显卡跑kwave不写dataPath会报错h5文件不存在，因为kspaceFirstOrder2DG在c盘，但matlab没有c盘权限。
% dataPath = 'Z:\data\matlab_code'; 
% % 对sensor进行处理，因为gpu只能接收二进制grid，cart2grid是kwave的函数，google能搜到
% [sensor.mask,order,reorder] = cart2grid(kgrid,sensor.mask);
% sensor_pos = zeros(num_sensor_points,2);
% counter = 1;
% for j = 1:Nx
%     for i = 1:Nx
%         if sensor.mask(i,j) == 1
%             sensor_pos(counter,1) = (j-Nx/2)*dx;
%             sensor_pos(counter,2) = (i-Nx/2)*dx;
%             counter = counter + 1;
%         end
%     end
% end
% sensor_data = kspaceFirstOrder2DG(kgrid, medium, source, sensor,'DataPath', dataPath);
% % gpu跑出来的sensor_data，sensor的位置与cpu不一致，cpu的sensor序号方向是按照逆时针（顺时针？反正是一个方向）排列的。
% % gpu的sensor序号方向是上下对称？具体见fig1
% % 这地方的原因是cart2grid的时候reorder改变了sensor的顺序。因为cart2grid使用了最近邻插值，所以也无法完美的恢复信号。
% temp_data = sensor_data;
% temp_pos = sensor_pos;
% for i = 1:num_sensor_points
%     sensor_data(reorder(i,1),:) = temp_data(i,:);
%     sensor_pos(reorder(i,1),:) = temp_pos(i,:);
% end
%% CPU
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor);