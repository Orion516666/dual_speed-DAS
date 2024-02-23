% 根据两个线段，返回线段是否相交，如果相交，则返回相交的结点index
function [sol_x, sol_y, result] = intersection_detection(l1, l2)
    % 快速排斥实验
    if (max(l1(1, 1), l1(2, 1)) < min(l2(1, 1), l2(2, 1)) || ...
        max(l1(1, 2), l1(2, 2)) < min(l2(1, 2), l2(2, 2)) || ...
        max(l2(1, 1), l2(2, 1)) < min(l1(1, 1), l1(2, 1)) || ...
        max(l2(1, 2), l2(2, 2)) < min(l1(1, 2), l1(2, 2)))
        result = false;
        [sol_x, sol_y] = deal(0, 0);
        return;
    end
    
    % 跨立实验
    if (((l1(1, 1) - l2(1, 1))*(l2(2, 2) - l2(1, 2)) - (l1(1, 2) - l2(1, 2))*(l2(2, 1) - l2(1, 1))) * ...
        ((l1(2, 1) - l2(1, 1))*(l2(2, 2) - l2(1, 2)) - (l1(2, 2) - l2(1, 2))*(l2(2, 1) - l2(1, 1))) >= 0 || ...
        ((l2(1, 1) - l1(1, 1))*(l1(2, 2) - l1(1, 2)) - (l2(1, 2) - l1(1, 2))*(l1(2, 1) - l1(1, 1))) * ...
        ((l2(2, 1) - l1(1, 1))*(l1(2, 2) - l1(1, 2)) - (l2(2, 2) - l1(1, 2))*(l1(2, 1) - l1(1, 1))) >= 0)
        result = false;
        [sol_x, sol_y] = deal(0, 0);
        return;
    end
    
    % 定义直线1和直线2的参数
    [a1, b1, m1] = get_line_function(l1);
    [a2, b2, m2] = get_line_function(l2);
    
    % 如果直线重合则返回false
    if a1*b2 == a2*b1
        result = false;
        [sol_x, sol_y] = deal(0, 0);
        return;
    end

    % % 解方程组
    syms t s;
    [sol_x, sol_y] = solve(a1*t + b1*s == m1, a2*t + b2*s == m2, t, s);
    sol_x = double(sol_x);
    sol_y = double(sol_y);
    result = true;
end



function [a, b, m] = get_line_function(points)
    % points 2*2 包含两个点的横纵坐标
    % ax + by = m
    x1 = points(1, 1);
    y1 = points(1, 2);
    x2 = points(2, 1);
    y2 = points(2, 2);

    a = y2 - y1;
    b = x1 - x2;
    m = x1*y2 - x2*y1;

end
