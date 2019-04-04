
clear all
close all

syms x xeq i ieq k m g kff

F = k*ieq^2*(x-xeq)/xeq^3 - k*ieq*(i-ieq)/xeq^2;
pretty(simplify(F))

% Simulation
m = 0.068;          % Mass of the ball, kg
k = 6.5308*1e-5;    % Nm^2/A^2
g = 9.81;           % Acceleration of gravity, m/s^2
param = [m; k; g];

kff = sqrt(2*m*g/k); 

% Equilibrium Point
xeq = 6e-3;
ieq = kff*xeq;

% Initial Condition
X0 = [14e-3; 0 ];

% LQR Controller
A = [0 1; 2*g/xeq 0];
B = [0; -2*g/ieq];

Q = eye(2);
R = 1;
K = lqr(A,B,Q,R)

sim('maglev.slx',1);

figure('Name','Nonlinear and Linear State Response');
ax1 = subplot(211); hold on; plot(t, X(:,1), 'linewidth', 2); plot(t, X2(:,1), '--', 'linewidth', 2); title('State Response');
ax2 = subplot(212); hold on; plot(t, X(:,2), 'linewidth', 2); plot(t, X2(:,2), '--', 'linewidth', 2); 
legend('Nonlinear','linear');

% Plot boundaries
plot(ax1, t,zeros(size(t)), '-b', 'linewidth', 2); plot(ax1, t, 0.014*ones(size(t)), '-b', 'linewidth', 2)
legend(ax1, 'Nonlinear','linear','boundaries','boundaries');

figure('Name','Control Input');
title('Control Input: Current, A');
hold on; plot(t, i, 'linewidth', 2); plot(t, deltai, '--', 'linewidth', 2); legend('Nonlinear','linear');

% Plot boundaries
plot(t,-2.5*ones(size(t)), '-b', 'linewidth', 2); plot(t, 2.5*ones(size(t)), '-b', 'linewidth', 2)
legend('Nonlinear','linear','boundaries','boundaries');

% Quadratic Lyapunov Function and Region of Attraction
Q = diag([1 1]);

Acl = A-B*K;
P = lyap(Acl',Q);

syms x1 x2
V = 0.5*[x1 x2]*P*[x1; x2];
vpa(simplify(V), 4)

V_sym = matlabFunction(V, 'vars', [x1,x2]);

u = ieq - K*[x1-xeq; x2];
x1d = x2;
x2d = (m*g-k.*u^2/2/x1^2)/m;

Vdot = diff(V,x1)*x1d + diff(V,x2)*x2d;
Vdot_sym = matlabFunction(Vdot, 'vars', [x1,x2]);
