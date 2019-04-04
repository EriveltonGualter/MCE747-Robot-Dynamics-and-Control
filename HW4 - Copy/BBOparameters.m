% Parameters BBO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bbo.OPTIONS.Maxgen = 5;    % generation count limit 
bbo.OPTIONS.popsize = 5;   % Number of individuals in the population
bbo.OPTIONS.PMutate = 0.02; % Mutation probability
bbo.OPTIONS.Keep = 2;       % Number of elite individuals in population
bbo.OPTIONS.OrderDependent = true;

% temp: 
bbo.OPTIONS.numVar = 3;     % number of variables in each population

% Boundaries
bbo.MinParValue = [0 0 0];
bbo.MaxParValue = 10e6*[1 1 1];


% Simulation
m = 0.068;          % Mass of the ball, kg
k = 6.5308*1e-5;    % Nm^2/A^2
g = 9.81;           % Acceleration of gravity, m/s^2
param = [m; k; g];

kff = sqrt(2*m*g/k); 

% Equilibrium Point
xeq = 6e-3;
ieq = kff*xeq;

A = [0 1; 2*g/xeq 0];
B = [0; -2*g/ieq];

Q = diag([10 1]);
R = 1e-3;
K = lqr(A,B,Q,R);
Acl = A-B*K;

bbo.OPTIONS.Acl = Acl;
bbo.OPTIONS.xeq = xeq;
bbo.OPTIONS.ieq = ieq;
bbo.OPTIONS.m = m;    
bbo.OPTIONS.g = g;    
bbo.OPTIONS.k = k;    
bbo.OPTIONS.K = K; 