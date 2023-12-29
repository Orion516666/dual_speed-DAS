%% 这是DAS_circle的代码
function [p_r] = DAS_circle(sensor_data,Nd,dx,interval,sensor_radius,speed_sound,initial_degree)
% This employs the classic delay-and-sum method of beamforming
% inputs:  
%        sensor_data: - RF data (transmission number, receive channel, time index)
%        Nd: the rectagle region to show [mm]
%        Rd : pixel size / 2 [mm]
%        fs: sampling rate [MHz]
%        sensor_radius:the distance from the scanning center to the transducer[mm]
%        angl: the angle between sensor [degree]
%        sound_speed: the speed of sound [mm/us]
% outputs:  
%    image: beamformed data 
% ABOUT:
%       author               - Hengrong Lan (shanghaitech university)
%       date                 - 2019.1.22
%       last update          - 2019.1.22

% 单位统一
Rd = Nd * dx / 2 * 1e3;
fs = 1 / interval / 1e6;
sensor_radius = sensor_radius * 1e3;
speed_sound = speed_sound / 1e3;

[num_sensor_points,data_len] =size(sensor_data);
angl = 360 / num_sensor_points;

%ROI=2*Nx; %[mm]
ROI_points = Nd;%floor(ROI./d_pixel) +1; % all of we reconstructed point in a axis
p_r=zeros(Nd,Nd);
coordinate=zeros(Nd,Nd,2);

xygrid=linspace(-Rd,Rd,Nd);
[coordinate(:,:,2),coordinate(:,:,1)]=meshgrid(xygrid);  %2-x,1-y  same with cart_sensor_mask1
coordinate(:,:,1)=-1*coordinate(:,:,1);
sensor_coordinate=ones(ROI_points,ROI_points,2);

for i=1:1:num_sensor_points
    
    detx=sensor_radius*cos(((i-1)*angl+initial_degree)*pi/180);
    dety=sensor_radius*sin(((i-1)*angl+initial_degree)*pi/180);
    sensor_mask(:,:,1)=sensor_coordinate(:,:,1).*detx; %y axis of sensor
    sensor_mask(:,:,2)=sensor_coordinate(:,:,2).*dety; %x axis of sensor
    
    delay_dis=sqrt(((coordinate(:,:,1)-sensor_mask(:,:,1)).^2)+((coordinate(:,:,2)-sensor_mask(:,:,2)).^2));
    %dis(i,1)=delay_dis(110,90);
    
    delay_num=floor(delay_dis./speed_sound.*fs);
    delay_num=delay_num+1;
    delay_num(delay_num>data_len)=data_len;
% sensor_data(i,:)=abs(hilbert(sensor_data(i,:)));
    for j =1:1:ROI_points
       p_r(j,:)=p_r(j,:)-sensor_data(i,delay_num(j,:));
    end
end
p_r = real(p_r);

end