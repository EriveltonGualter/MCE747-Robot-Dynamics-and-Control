
clear all
close all

% Simulation
m = 0.068;          % Mass of the ball, kg
k = 6.5308*1e-5;    % Nm^2/A^2
g = 9.81;           % Acceleration of gravity, m/s^2
kff = sqrt(2*m*g/k); 

% Equilibrium Point
xeq = 6e-3;
ieq = kff*xeq;

% LQR Controller
A = [0 1; 2*g/xeq 0];
B = [0; -2*g/ieq];
C = eye(2);
D = 0;

% % Continuos Plant 
% A = [0 1; 0 0];
% B = [0; 1];
C = eye(2);
D = 0;

p = [0 0];
K = lqr(A, B, diag([100 1]),0.1);
Acl = A-B*K;

Q = eye(2);

P = dlyap(Acl', Q);
%%
nonlcon = @(X) nonlconstraints (X, Acl);
x0 = reshape(Q,4,1);

options = struct('MaxFunctionEvaluations', 1000, 'MaxIterations', 1000);

fun = @(X) objFunction (X, Acl);
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

Qnew = reshape(x,2,2);
Pnew = lyap(Acl', Qnew);
figure; hold on
% rectangle('Position', [-1 -1 2 2]); 
Pnew = inv(Pnew);
E = ellipsoid([0; 0], Pnew); 
plot(E)
axis equal

% [x10,x20] = ginput(1);
% X = [x10; x20];
% 
% Ts = 0.01;
% t = 0:Ts:10;
% 
% A = [0 1; 2*g/xeq 0];
% B = [0; -2*g/ieq];
% C = eye(2);
% D = 0;
% sys_cl = ss(A-B*K,[0;0],C,D);
% [X, t] = lsim(sys_cl,zeros(size(t)), t, X);
% 
% plot(X(:,1), X(:,2))

function out = objFunction (X, Acl)
    Q = reshape(X, 2,2);
    P = lyap(Acl', Q);
    out = trace(P);
end

function [c, ceq] = nonlconstraints (X, Acl)
    c = [];
    Q = reshape(X, 2,2);

    P = lyap(Acl', Q);
    gama1 = sqrt([1 0]*inv(P)*[1 0]');
    gama3 = sqrt([0 1]*inv(P)*[0 1]');

    ceq = X(2)-X(3);
%     c = [c; -Q(1,1); -Q(1,1)*Q(2,2)+Q(2,1)*Q(1,2); gama1-.1; gama3-.1];  
    c = [c; -Q(1,1); -Q(1,1)*Q(2,2)+Q(2,1)*Q(1,2); gama1-1; gama3-1];   
end
