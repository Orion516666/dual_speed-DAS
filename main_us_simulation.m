load("phantom_sos.mat");

num_sensor_points = 256;
sensor_radius = 40e-3; 

channel_index = 256;

[channel_data, sample_freq, rowIndex, colIndex] = us_transducer_simulation(channel_index, phantom_sos, num_sensor_points, sensor_radius);

filename = sprintf('sensor%d_data.mat', channel_index);
save(filename, 'channel_data', 'sample_freq', 'rowIndex', 'colIndex');

