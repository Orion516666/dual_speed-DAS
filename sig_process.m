clear;

load('demo_sensor_data.mat');
load('phantom_sos.mat');

num_sensor_points = 256;
sensor_radius = 400;

% for channel_index = 1:num_sensor_points
%     % us simulation
%     [channel_data, sample_freq, rowIndex, colIndex] = us_transducer_simulation(channel_index, phantom_sos, num_sensor_points, sensor_radius);
% 
%     % temporal window  探头到phantom边界和到phantom的1/4
%     chan_data_aic = chan_data(1542:2313);
%     % Akaike information criterion (AIC) picker algorithm
%     boundary_index = AIC_picker(chan_data_aic) + 1541;
% end

% 40mm * 40mm
chan_data = sensor_data(3, 1542:4877);
% 探头到phantom边界和到phantom的1/4
chan_data_aic = sensor_data(3, 1542:2313);

% plot(chan1_data);




% 5Mhz toneBurst, dt: 17.2913ns, t_end: 126.002us, time steps: 7288
% save('demo_sensor_data.mat', 'sensor_data');


boundary_index = AIC_picker(chan_data_aic) + 1541;

sample_freq = 1 / 17.2913e-9;

rowIndex = 581;
colIndex = 201;
x_tx = 601 + (sensor_radius - 0.5e4 * boundary_index / sample_freq * 1500) * (colIndex-601) / sensor_radius;
x_tx = round(x_tx);

y_tx = 601 + (sensor_radius - 0.5e4 * boundary_index / sample_freq * 1500) * (rowIndex-601) / sensor_radius;
y_tx = round(y_tx);










% % flight_distance = 40e-3;
% flight_distance = 126.4911e-3;
% flight_distance = 60e-3;
% tof = flight_distance / 1500;
% 
% step = tof / 17.2913e-9