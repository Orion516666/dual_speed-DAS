function TOF = one_point_tof(source_point, sensor_pos, speed) 
    
    n = length(sensor_pos);

    % speed(:,1)=speed(:,1)-source_point(1);
    % speed(:,2)=speed(:,2)-source_point(2);

    sensor_pos(:, 1) = sensor_pos(:, 1) - source_point(1);
    sensor_pos(:, 2) = sensor_pos(:, 2) - source_point(2);

    TOF = zeros(n, 1);
    
    for i = 1:n
        sensor_x = sensor_pos(i, 1);
        sensor_y = sensor_pos(i, 2);
       
        x = 0;
        y = 0;

        slope = sensor_y / sensor_x;
        
        source_to_sensor_tof = 0;

        if  abs(slope) <= 1
            for k = 1:abs(sensor_x)
                
                y = round(x*slope);
                
                source_to_sensor_tof = source_to_sensor_tof + sqrt(1+slope^2) / speed(x + source_point(1), y + source_point(2));
                
                x = x + sensor_x/abs(sensor_x);
            end
        else
            for k = 1:abs(sensor_y)
                
                x = round(y/slope);
                
                source_to_sensor_tof = source_to_sensor_tof + sqrt(1+1/slope^2) / speed(x + source_point(1), y + source_point(2));

                y = y + sensor_y/abs(sensor_y);
            end
        end

        TOF(i) = source_to_sensor_tof;

    end


end



