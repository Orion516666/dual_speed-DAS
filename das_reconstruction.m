%% 这是得到kwave的data后DAS重建的代码
% WARNING: makeGrid will be deprecated in a future version of k-Wave.
%          Update codes to use the syntax kgrid = kWaveGrid(...).
% Running k-Wave simulation...
%   start time: 31-Dec-2023 00:05:55
%   reference sound speed: 1734.9723m/s
%   WARNING: visualisation plot scale may not be optimal for given source.
%   dt: 17.2913ns, t_end: 126.002us, time steps: 7288
%   input grid size: 1200 by 1200 grid points (120 by 120mm)
%   maximum supported frequency: 6.7334MHz
%   smoothing p0 distribution...
%   calculating Delaunay triangulation...
%   precomputation completed in 5.1998s
%   starting time loop...
%   estimated simulation time 10min 23.5613s...
%   simulation completed in 11min 11.9591s
%   total computation time 11min 17.222s
clear;
load('saved_data/sensor_data.mat');

Nx = 1200;
dx = 1e-4;
sensor_radius = 40e-3; 
% dt: 17.2913ns
interval = 17.2913e-9; %[s]

% reference sound speed: 1734.9723m/s
speed = 1517;

p = DAS_circle(sensor_data,Nx,dx,interval,sensor_radius,speed,90);

figure;
imagesc(-p(401:800, 401:800));