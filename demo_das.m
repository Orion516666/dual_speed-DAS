%% 这是kwave_circle的代码
% ABOUT:
%       author               - Fan Zhang (shanghaitech university)
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
medium.density = 1040;                   % [kg/m^3]

kgrid.makeTime(medium.sound_speed);
% define a Cartesian sensor mask of a centered circle with 50 sensor elements
sensor_radius = 0.005;                    % [m]
% sensor.frequency_response = [2e6, 70];
num_sensor_points = 128;
sensor.mask = makeCartCircle(sensor_radius, num_sensor_points);

% cartesian coordinate into grid format
[sensor_pos,order,reorder] = cart2grid(kgrid,sensor.mask);
display_sensor = sensor_pos;
% define source
source_indice = find(sensor_pos);
sensor_pos(:) = 0;
sensor_pos(source_indice(4)) = 1;

source.p_mask = sensor_pos;

% define pulse waveform
ping_pressure = 100;                                         % [Pa]
signal_freq = 0.5e6;                                           % [Hz]
ping_burst_cycles = 1;
source.p = ping_pressure * toneBurst(1./kgrid.dt, signal_freq, ping_burst_cycles);


%% Simulation

input_args = {'PlotLayout', false, ... 
              'PlotPML', false, ...
              'DisplayMask', source.p_mask | display_sensor == 1,...
              'DataCast', 'single'};

% dt: 17.2913ns, t_end: 126.002us, time steps: 7288
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor, input_args{:});