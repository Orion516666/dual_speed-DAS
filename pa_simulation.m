%% Dual-speed photoacoustic simulation
% ABOUT:
%       author               - Xinlong Dong(shanghaitech university)
%       date                 - 2023.12.30
%       last update          - 2023.12.30
clear;

% create the computational grid
Nx = 1200;      % number of grid points in the x (row) direction
Ny = 1200;      % number of grid points in the y (column) direction
dx = 1e-4;      % grid point spacing in the x direction [m]
dy = 1e-4;      % grid point spacing in the y direction [m]
kgrid = makeGrid(Nx,dx,Ny,dy);

% define an initial pressure
disc_x_pos = 600;                        % [grid points]
disc_y_pos = 600;                        % [grid points]
disc_radius = 150;                       % [grid points]
disc_mag = 100;                          % [Pa]

% 间隔
interval = 50;

% 生成点的坐标
pa_sources = zeros(Nx,Ny);
for x = -disc_radius:interval:disc_radius
    for y = -disc_radius:interval:disc_radius
        if sqrt(x^2 + y^2) <= disc_radius
            pa_sources(x+disc_x_pos, y+disc_y_pos) = 1;
        end
    end
end
source.p0 = disc_mag*pa_sources;

% define the medium properties
phantom = makeDisc(Nx, Ny, disc_x_pos, disc_y_pos, disc_radius);
meanValue = 1538;
stdDeviation = 39.4;

randomArray = meanValue + stdDeviation * randn(size(phantom));

phantom_sos = phantom;
phantom_sos(phantom_sos == 1) = randomArray(phantom_sos == 1);
phantom_sos(phantom_sos == 0) = 1500;

medium.sound_speed = phantom_sos;           % [m/s]
medium.density = 1000;                      % [kg/m^3]
medium.alpha_coeff = 0.75;                  % [dB/(MHz^y cm)]
medium.alpha_power = 1.5;

% define a Cartesian sensor mask of a centered circle with 50 sensor elements
sensor_radius = 40e-3;                      % [m]
% sensor.frequency_response = [2e6, 70];
num_sensor_points = 256;
sensor.mask = makeCartCircle(sensor_radius, num_sensor_points);

% run the simulation
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor);