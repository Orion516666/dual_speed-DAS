function point_in_polygon = is_point_in_polygon(point, boundary)
    point_in_polygon = false;
    % 多边形的边数
    n = length(boundary);
    % 将polygon多边形的坐标转为以point点为原点的坐标
    % 方便计算原点向右发出的水平线射线与多边形各边相交
    boundary(:,1)=boundary(:,1)-point(1);
    boundary(:,2)=boundary(:,2)-point(2);
    % 初始化四个象限的计数器
    q1 = 0;
    q2 = 0;
    q3 = 0;
    q4 = 0;

    for i = 1:n
        x = boundary(i, 1);
        y = boundary(i, 2);

        if x > 0 && y > 0
            q1 = q1 + 1;
        elseif x < 0 && y > 0
            q2 = q2 + 1;
        elseif x < 0 && y < 0
            q3 = q3 + 1;
        elseif x > 0 && y < 0
            q4 = q4 + 1;
        end
    end

    if q1*q2*q3*q4 ~= 0
        point_in_polygon = true;
    end

end