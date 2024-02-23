function distance = one_point_tof(source_point, sensor_point, polygon) 
    n = length(polygon);
    % 将polygon多边形的坐标转为以point点为原点的坐标
    % 方便计算原点向右发出的水平线射线与多边形各边相交
    polygon(:,1)=polygon(:,1)-source_point(1);
    polygon(:,2)=polygon(:,2)-source_point(2);

    sensor_point(1) = sensor_point(1)-source_point(1);
    sensor_point(2) = sensor_point(2)-source_point(2);

    source_point =[0,0];
    
    intersection_array = zeros(2, 2);
    intersection_sensor_index = zeros(1, 2);
    k = 0;

    for i = 1:n
        % 依次判断点的射线与每条边的相交情况
        line1 = [sensor_point; source_point];
        if (i < n)
            line2 =polygon(i :i+1,:);
        else
            line2 =[polygon(n, :); polygon(1, :)];
        end
               
        [sol_x, sol_y, result] = intersection_detection(line1, line2);

        if result == 1
            k = k+1;
            intersection_sensor_index(k) = i;
            intersection_array(k, 1) = sol_x;
            intersection_array(k, 2) = sol_y;
        end
    end

    if  k == 0
        distance = norm(sensor_point);
    elseif k == 1
        distance = norm(intersection_array(k)) + norm(intersection_array(k) - sensor_point);
        % distance = intersection_array(k, 1)^2 + intersection_array(k, 2)^2;
        % distance = sqrt(distance);
    elseif k == 2
        
    end

end


function



