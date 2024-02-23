clear
% 线段 1 的端点坐标
x1 = -1; y1 = -1;
x2 = 3; y2 = 3;

% 线段 2 的端点坐标
x3 = 5; y3 = -6;
x4 = -2; y4 = 0;

% 计算向量表示的线段
v1 = [x2 - x1, y2 - y1];
v2 = [x4 - x3, y4 - y3];

l1 = [x1, y1; x2, y2];
l2 = [x3, y3; x4, y4];

tic
[sol_x, sol_y, result] = intersection_detection(l1, l2)
time=toc

