%% 这是kwave_circle的代码
% ABOUT:
%       author               - Fan Zhang (shanghaitech university)
%       date                 - 2023
%       last update          - 2023
clear;
% create the computational grid
Nx = 256;    % number of grid points in the x (row) direction
Ny = 256;    % number of grid points in the y (column) direction
dx = 50e-6;  % grid point spacing in the x direction [m]
dy = 50e-6;  % grid point spacing in the y direction [m]
kgrid = makeGrid(Nx,dx,Ny,dy);

% define the medium properties
medium.sound_speed = 1500*ones(Nx, Ny);  % [m/s]
medium.density = 1040;                   % [kg/m^3]

% define an initial pressure using makeDisc
disc_x_pos = 128;                        % [grid points]
disc_y_pos = 128;                        % [grid points]
disc_radius = 8;                         % [grid points]
disc_mag = 30;                           % [Pa]
source.p0 = disc_mag*makeDisc(Nx, Ny, disc_x_pos, disc_y_pos, disc_radius);

% c0 = medium.sound_speed;
% define a Cartesian sensor mask of a centered circle with 50 sensor elements
sensor_radius = 0.005;                    % [m]
% sensor.frequency_response = [2e6, 70];
num_sensor_points = 128;
sensor.mask = makeCartCircle(sensor_radius, num_sensor_points);

% run the simulation
%% CPU
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor);