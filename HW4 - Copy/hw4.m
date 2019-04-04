
clear all
close all

%% Part I
% Simulation
m = 0.068;          % Mass of the ball, kg
k = 6.5308*1e-5;    % Nm^2/A^2
g = 9.81;           % Acceleration of gravity, m/s^2
param = [m; k; g];

kff = sqrt(2*m*g/k)

% Equilibrium Point
xeq = 6e-3;
ieq = kff*xeq

% Initial Condition
X0 = [14e-3; 0 ];

% State-Space Representation
A = [0 1; 2*g/xeq 0];
B = [0; -2*g/ieq];
% Alternative: 
% A = [0 1; k*ieq^2/xeq^3/m 0];
% B = [0; -k*ieq/xeq^2/m];

% LQR Controller
Q = diag([10 1]);
R = 1;
K = lqr(A,B,Q,R)

% Simulation
sim('maglev.slx',1);

% Plots
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

%% Part II
% Quadratic Lyapunov Function and Region of Attraction
Q = diag([1 1]);    % Worse
Q = getBestQ();     % Best
Acl = A-B*K;
P = lyap(Acl',Q);

syms x1 x2
V = 0.5*[x1 x2]*P*[x1; x2];
V_sym = matlabFunction(V, 'vars', [x1,x2]);

u = ieq - K*[x1-xeq; x2];
x1d = x2;
x2d = (m*g-k.*u^2/2/x1^2)/m;

Vdot = diff(V,x1)*x1d + diff(V,x2)*x2d;
Vdot_sym = matlabFunction(Vdot, 'vars', [x1,x2]);

[X1, X2] = meshgrid(0:1e-4:.014, -.1:1e-3:.1);
Vdot = Vdot_sym(X1, X2);

figure;
contourf(X1,X2,Vdot, [-Inf 0]); hold on;

for x10 = .0005:.0005:.014
    for x20 = -0.1:0.025:0.1
        X0 = [x10; x20];
        sim('maglev.slx',1);
        if ((abs(X(end,1)) - 6e-3) < 1e-3)
    %         plot(X(:,1), X(:,2), '--', 'linewidth', 2);
            plot(x10, x20, 'r*')
        else
            plot(x10, x20, 'k*')
        end
    end
end
x10 = 8e-3;
x20 = 25e-3;
X0 = [x10; x20];
sim('maglev.slx',1);
plot(X(:,1), X(:,2));

% Polar Scan 
P1 = [];
P2 = [];
for th = 0:.005:2*pi
    for r = 0:.0005:0.1
        x1 = r*cos(th)+6e-3;
        x2 = r*sin(th); 
        vdot = Vdot_sym(x1,x2);
        if vdot > 0
            P1 = [P1 [x1;x2]];
            break;
        else
            P2 = [P2 [x1;x2]];
        end
    end
end
plot(P2(1,:),P2(2,:), 'r*');
xlim([0 .014])
