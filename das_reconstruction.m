%% 这是得到kwave的data后DAS重建的代码
Nx = 256;
dx = 50e-6;
sensor_radius = 0.005; 
interval = 10e-9; %[s]
speed = 1500;

p = DAS_circle(sensor_data,Nx,dx,interval,sensor_radius,speed,90);

imagesc(-p)