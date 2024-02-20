clear; clc;
% dt: 17.2913ns, t_end: 126.002us, time steps: 7288
%% Define media and its properties
% create the computational grid
Nx = 1200;                                                  % number of grid points in the x (row) direction
Ny = 1200;                                                  % number of grid points in the y (column) direction
dx = 1e-4;                                                  % grid point spacing in the x direction [m]
dy = 1e-4;                                                  % grid point spacing in the y direction [m]
kgrid = makeGrid(Nx,dx,Ny,dy);

% medium
load("phantom_sos.mat")
medium.sound_speed = phantom_sos;                           % [m/s]
% medium.sound_speed = 1500 * ones(Nx, Ny);
medium.density = 1000;                                      % [kg/m^3]
medium.alpha_coeff = 0.75 * ones(Nx, Ny);                   % [dB/(MHz^y cm)]
medium.alpha_power = 1.5;

% Simulation time and step size
kgrid.makeTime(medium.sound_speed);

%% Define ultrassound source and sensors

% define sensors
sensor_radius = 40e-3;                                       % [m]
num_sensor_points = 256;
sensor.frequency_response = [6.25e6, 76.8];
sensor.mask = makeCartCircle(sensor_radius, num_sensor_points);

% cartesian coordinate into grid format
[sensor_pos,order,reorder] = cart2grid(kgrid,sensor.mask);

display_sensor = sensor_pos;
% define source
source_indice = find(sensor_pos);

% only one transducer
sensor_pos(:) = 0;
sensor_pos(source_indice(256)) = 1;

source.p_mask = sensor_pos;

% define pulse waveform
ping_pressure = 100;                                         % [Pa]
signal_freq = 5e6;                                           % [Hz]
ping_burst_cycles = 1;
source.p = ping_pressure * toneBurst(1/kgrid.dt, signal_freq, ping_burst_cycles);


%% Simulation

input_args = {'PlotLayout', false, ... 
              'PlotPML', false, ...
              'DisplayMask', source.p_mask | display_sensor == 1,...
              'DataCast', 'single'};

sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor, input_args{:});


