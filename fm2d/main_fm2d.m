% Time comparison C++ code vs Matlab code

%% Setup
% Allow for non-semicolon-ended output
%#ok<*NOPTS>

m = 40; % Num of y nodes
n = m;   % Num of x nodes

% Grid distances
dx = 1;
dy = 3;

% Speed map
F = ones(m,n);

% Source points
SPs = [4 4]';


%% Solve for T (distance map)
% Matlab version (with class heap implementation)
tic; 
% T1 = fm(F,SPs,[dx dy],'imp','mat','order',1); 
T1 = fm2d(F,SPs,dx,dy,int32(1)); 
T1time = toc 

