function point_in_polygon = is_point_in_polygon(point, polygon)
    % 沿着多边形顺时针走一圈，point如果在右手边就是在内部？？？
    % 判断点是否在多边形内部
    % 射线法,Ray casting algorithm
    % 原理:从该点向右发出的水平线射线与多边形各边相交,若交点数为奇数,则在多边形的内部
    % 需要注意以下几种特殊情况:
    % 1)点在多边形的顶点或边上
    % 2)点在多边形边的延长线上
    % 3)点的射线与多边形相交于多边形的顶点上
    
    % 输出:
    % point_in_polygon 点是否在多边形内部
    
    % 输入:
    % point    点      [x,y]
    % polygon  多边形  [xi,yi]
    
    
    point_in_polygon = false;
    % 多边形的边数
    n = length(polygon);
    % 将polygon多边形的坐标转为以point点为原点的坐标
    % 方便计算原点向右发出的水平线射线与多边形各边相交
    polygon(:,1)=polygon(:,1)-point(1);
    polygon(:,2)=polygon(:,2)-point(2);
    point =[0,0];
    

    y_flag = [0, 0];
    x_flag = [0, 0];
    flip = 0;

    for i = 1:n

        % 依次判断点的射线与每条边的相交情况
        if (i < n)
            line =polygon(i :i+1,:);
        else
            line =[polygon(n, :); polygon(1, :)];
        end
        % 判断点是否在多边形的边线上
        point_in_line = is_point_in_line(point, line);
        if (point_in_line)
            % 特殊情况1
            % 点在多边形的顶点或边上
            point_in_polygon =true;
            return;

        else
            % 提取每条线两个端点的纵坐标
            y1 = line(1, 2);
            y2 = line(2, 2);
            x1 = line(1, 1);
            x2 = line(2, 1);
            cross_flag = y1 * y2;
            if (cross_flag > 0)
                % 无交点
                continue;

            elseif (cross_flag < 0)
                % 有一个交点
                % 计算该点的横坐标
                x0 = get_line_cross_x_axis(line);
                if (x0 > 0)
                    point_in_polygon = ~point_in_polygon;
                end
            else
                % 特殊情况2和3
                % 相交于其中一个端点或两个端点
                % if(y1 == 0 && y1 > y2)||(y2 == 0 && y2 > y1)
                %     %若该点属于该边纵坐标较大的顶点则计一次穿越
                %     point_in_polygon = ~point_in_polygon;
                % end
                % if  y1==0 && polygon(i+1,2)*polygon(i-1,2) <= 0
                %     point_in_polygon = ~point_in_polygon;
                % end


                % 1如果两点y不都为0
                if  y1 + y2 ~= 0
                    y_flag(1+flip) = y1 + y2;
                    if  y1 == 0
                        x_flag(1+flip) = x1;
                    elseif y2 == 0
                        x_flag(1+flip) = x2;
                    end

                    % if  flip && y_flag(1)*y_flag(2) < 0 && x_flag(1) > 0 && x_flag(2) > 0 
                    if  y_flag(1)*y_flag(2) < 0 && x_flag(1) > 0 && x_flag(2) > 0 
                        point_in_polygon = ~point_in_polygon;
                    end

                    flip = ~flip;
                end
            end

        end
    end
end

%% is_point_in_line
function point_in_line = is_point_in_line(point, line)
% 判断点是否在线上
% 输出:
% point_in line :点是否在线上
% 输入:
% point 点[x，y]
% line 线[xi，yi]
    point_in_line = false;

    x= point(1);
    y= point(2);

    x1= line(1,1);
    y1= line(1,2);
    x2= line(2,1);
    y2= line(2,2);

    if(((y-y1)*(x2-x1)) == ((y2-y1)*(x-x1)))...
        && (x >= min(x1, x2))...
        && (x <= max(x1, x2))...
        && (y >= min(y1, y2))...
        && (y <= max(y1, y2))

        point_in_line =true;
    end
end


%% get_line_cross_x_axis
function x = get_line_cross_x_axis(line)
% 获取line穿过x轴的x坐标

    x1 = line(1, 1);
    y1 = line(1, 2);
    x2 = line(2, 1);
    y2 = line(2, 2);
    
    x=x1-y1*(x2-x1)/(y2 - y1);
end



