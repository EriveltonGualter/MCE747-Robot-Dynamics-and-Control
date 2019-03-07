% Authors
% Date

clear all
close all

addpath('Homogeneous Primitive Transformation');

% Parameters
d1 = .666;  % m
d2 = .2435; % m
a2 = .432;  % m
d3 = .0934; % m
a3 = .432;  % m
alph = .065; % rad

param = [d1, d2, a2, d3, a3, alph];

% Create symbolic joints
syms q1 q2 q3 q4

% Test Zero Configuration
% q1=0;q2=0;q3=0;q4=0;

[T, Ot] =  forwardKinematicsPUMA(q1, q2, q3, q4, param);
% Draw(q1, q2, q3, q4, param);

% Jacobian 

% Extract Position Frames
O1 = T(1:3,4*2);
O2 = T(1:3,4*3);
O3 = T(1:3,4*4);
O4 = T(1:3,4*5);
OP = T(1:3,4*6);    % End-Effector

% Find Orientation Zi
Z0 = [0;0;1];
Z1 = getOrientMatrix(Ot, 1)*Z0;
Z2 = getOrientMatrix(Ot, 2)*Z0;
Z3 = getOrientMatrix(Ot, 3)*Z0;
Z4 = getOrientMatrix(Ot, 4)*Z0;
ZP = getOrientMatrix(Ot, 5)*Z0;

% Jacoabians 
Jv1 = cross(Z0,OP);
Jv2 = cross(Z1,OP-O1);
Jv3 = cross(Z2,OP-O2);
Jv4 = cross(Z3,OP-O3);
JvP = cross(ZP,OP-O4);

J = [Jv1 Jv2 Jv3 Jv4];

% Find the null joint velociticies
A = 1;      % Amplitude, rad
w = 1;      % Frequency, rad/s
ts = 1e-3;  % Sampling time, s
Tf = 30;    % Final time, s
% Tf = 2*pi/w;    % Final time, s

Jv_sym = matlabFunction(J, 'vars', {q1 q2 q3 q4});

fun = @(t, Q) function_qd(t, Q, Jv_sym, A, w);
Q0 = [0 -.5 pi/4 -1];

[t,y] = ode45(fun , 0:ts:Tf, Q0);   

figure('Name','Joint Positions', 'NumberTitle','off');
subplot(411); plot(t, y(:,1));
subplot(412); plot(t, y(:,2));
subplot(413); plot(t, y(:,3));
subplot(414); plot(t, y(:,4));

q1 = y(:,1);
q2 = y(:,2);
q3 = y(:,3);
q4 = y(:,4);

for i=1:length(t)
    Q = [q1(i) q2(i) q3(i) q4(i)];
    Qdot =  function_qd(t(i), Q, Jv_sym, A, w);
    q1d(i) = Qdot(1);
    q2d(i) = Qdot(2);
    q3d(i) = Qdot(3);
    q4d(i) = Qdot(4);
end

figure('Name','Joint Velocities', 'NumberTitle','off');
subplot(411); plot(t, q1d);
subplot(412); plot(t, q2d);
subplot(413); plot(t, q3d);
subplot(414); plot(t, q4d);

q1dd = diff([q1d q1d(end)])/ts; 
q2dd = diff([q2d q2d(end)])/ts;
q3dd = diff([q3d q3d(end)])/ts;
q4dd = diff([q4d q4d(end)])/ts;

figure('Name','Joint Accelerations', 'NumberTitle','off');
subplot(411); plot(t, q1dd);
subplot(412); plot(t, q2dd);
subplot(413); plot(t, q3dd);
subplot(414); plot(t, q4dd);

for i=1:length(t)
    T = forwardKinematicsPUMA(q1(i), q2(i), q3(i), q4(i), param);    
    p(:,i) = T(1:3, end);    
end

figure('Name','End-Effector Cartesian', 'NumberTitle','off'); hold on;
plot(t, p(1,:)); plot(t, p(2,:)); plot(t, p(3,:));
% plot3(p(1,:), p(2,:), p(3,:), '*');
rms([p'-mean(p')])

fsim = figure('Name','Simulation PUMA', 'NumberTitle','off'); hold on;
first_frame = true;
time = 0;
tic;
while time < t(end)
    set(0, 'currentfigure', fsim);
    cla
    % Compute the position of the system at the current real world time
    q1Draw = interp1(t',q1',time')';
    q2Draw = interp1(t',q2',time')';
    q3Draw = interp1(t',q3',time')';
    q4Draw = interp1(t',q4',time')';
    
    % Update current time
    time = toc;

    Draw(q1Draw, q2Draw, q3Draw, q4Draw, param);
    axis([-1 1 -1 1 0 1]);
    drawnow
end 


% Main function for ODE45
function out = function_qd(t, Q, Jv_fun, A, w)
    
    % Extracting current joints
    q1 = Q(1);
    q2 = Q(2);
    q3 = Q(3);
    
    q4 = -A*cos(w*t);
    q4d = A*w*sin(w*t);
    
    % Jacobian at current joint position
    J = Jv_fun(q1,q2,q3,q4);
    
    A = J(:,1:3);
    B = -J(:,end)*q4d;
    
    q13 = inv(A)*B;
    
    out = [q13(1) q13(2) q13(3) q4d]';
end

% Get Orientation Matrix 
function Or = getOrientMatrix(Ot, id)
    Or = eye(3);
    for i=0:id-1
        Or = Or*Ot(1:3,(1:3)+4*i);
    end
end

% Solve Forward Kinematics for PUMA
function [T, Ot] =  forwardKinematicsPUMA(q1, q2, q3, q4, param)

    x4 = .061;  % m
    y4 = .3;    % Decide later what to do
    z4 = .027;  % m
    
    % Exctract Parameters
    d1 = param(1);
    d2 = param(2);
    a2 = param(3);
    d3 = param(4);
    a3 = param(5);
    alph = param(6);
    
    % Transformation Matrices
    T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    T01 = getTransformMatrixDH(q1, d1, 0, -(pi/2));
    T12 = getTransformMatrixDH(q2, -d2, a2, 0);
    T23 = Rot_z(q3)*Trans_z(d3)*Trans_x(a3)*Rot_y(pi/2)*Rot_x(alph);
    T34 = getTransformMatrixDH(q4, 0, 0, 0);
    T4P = Trans_x(-x4)*Trans_y(-y4)*Trans_z(-z4);
        
    % Coordinates in the base frame
    T02 = T01*T12;
    T03 = T02*T23;
    T04 = T03*T34;
    T0P = T04*T4P;

    Ot = [T01 T12 T23 T34 T4P];
    T = [T00 T01 T02 T03 T04 T0P];
end

% Draw Robot Link + Frames
function Draw(q1, q2, q3, q4, param)
    
    T =  forwardKinematicsPUMA(q1, q2, q3, q4, param);
    hold on; axis equal;
    xlabel('x'); ylabel('y'); zlabel('z'); grid on; box on;

    plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end))    
    for i=1:4:length(T)
        DrawCoordFrame(T(:,i:i+3), 'scale', 0.25, 'linewidth', 2)
    end
    view(3)
end

% Get DH Convention matrix
function Ai = getTransformMatrixDH(theta, d, a, alpha)
    Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
end