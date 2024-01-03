function [channel_data, sample_freq, rowIndex, colIndex] = us_transducer_simulation(channel_index, phantom_sos, num_sensor_points, sensor_radius)
% ABOUT:
%       author               - Xinlong Dong(shanghaitech university)
%       date                 - 2024.1.3
%       last update          - 2024.1.3

    %% Define media and its properties
    % create the computational grid
    Nx = 1200;                                                  % number of grid points in the x (row) direction
    Ny = 1200;                                                  % number of grid points in the y (column) direction
    dx = 1e-4;                                                  % grid point spacing in the x direction [m]
    dy = 1e-4;                                                  % grid point spacing in the y direction [m]
    kgrid = makeGrid(Nx,dx,Ny,dy);
    
    % medium
    medium.sound_speed = phantom_sos;                           % [m/s]
    % medium.sound_speed = 1500 * ones(Nx, Ny);
    medium.density = 1000;                                      % [kg/m^3]
    medium.alpha_coeff = 0.75 * ones(Nx, Ny);                   % [dB/(MHz^y cm)]
    medium.alpha_power = 1.5;
    
    % Simulation time and step size
    kgrid.makeTime(medium.sound_speed);
    
    %% Define ultrassound source and sensors
    
    % define sensors
    % sensor_radius = 40e-3;                                       % [m]
    % num_sensor_points = 256;
    sensor.frequency_response = [6.25e6, 76.8];
    sensor_radius = sensor_radius * dx;
    sensor.mask = makeCartCircle(sensor_radius, num_sensor_points);
    
    % cartesian coordinate into grid format
    [sensor_pos,~,~] = cart2grid(kgrid,sensor.mask);
    
    display_sensor = sensor_pos;
    % define source
    source_indice = find(sensor_pos);
    sensor_pos(:) = 0;
    sensor_pos(source_indice(channel_index)) = 1;
    [rowIndex, colIndex] = find(sensor_pos == 1);

    source.p_mask = sensor_pos;
    
    % define pulse waveform
    ping_pressure = 100;                                         % [Pa]
    signal_freq = 5e6;                                           % [Hz]
    ping_burst_cycles = 1;
    source.p = ping_pressure * toneBurst(1/kgrid.dt, signal_freq, ping_burst_cycles);
    
    sample_freq = 1 / kgrid.dt;
    
    %% Simulation

    
    %% GPU
    % 用显卡跑kwave不写dataPath会报错h5文件不存在，因为kspaceFirstOrder2DG在c盘，但matlab没有c盘权限。
    dataPath = pwd;
        
    input_args = {'PlotLayout', false, ... 
                  'PlotPML', false, ...
                  'DisplayMask', source.p_mask | display_sensor == 1,...
                  'DataCast', 'single', ...
                  'DataPath', dataPath};

    % 对sensor进行处理，因为gpu只能接收二进制grid，cart2grid是kwave的函数，google能搜到
    [sensor.mask,~,reorder] = cart2grid(kgrid,sensor.mask);
    sensor_pos_cart = zeros(num_sensor_points,2);
    counter = 1;
    for j = 1:Nx
        for i = 1:Nx
            if sensor.mask(i,j) == 1
                sensor_pos_cart(counter,1) = (j-Nx/2)*dx;
                sensor_pos_cart(counter,2) = (i-Nx/2)*dx;
                counter = counter + 1;
            end
        end
    end

    % dt: 17.2913ns, t_end: 126.002us, time steps: 7288
    sensor_data = kspaceFirstOrder2DG(kgrid, medium, source, sensor, input_args{:});
    % gpu跑出来的sensor_data，sensor的位置与cpu不一致，cpu的sensor序号方向是按照逆时针（顺时针？反正是一个方向）排列的。
    % gpu的sensor序号方向是上下对称？具体见fig1
    % 这地方的原因是cart2grid的时候reorder改变了sensor的顺序。因为cart2grid使用了最近邻插值，所以也无法完美的恢复信号。
    temp_data = sensor_data;
    temp_pos = sensor_pos_cart;
    for i = 1:num_sensor_points
        sensor_data(reorder(i,1),:) = temp_data(i,:);
        sensor_pos_cart(reorder(i,1),:) = temp_pos(i,:);
    end
    
    if  channel_index < 4
        channel_data = sensor_data(4-channel_index, :);
    else
        channel_data = sensor_data(260-channel_index, :);
    end

end

