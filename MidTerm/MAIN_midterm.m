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

J = [Jv1 Jv2 Jv3 Jv4 JvP];

% Find the null joint velociticies
A = 1;  % Amplitude, rad
w = 1;  % Frequency, rad/s
ts = 1e-3;  % Sampling time, s
Tf = 30; % Final time, s

Jv_sym=matlabFunction(J, 'vars', {q1 q2 q3 q4});

function_qd([0,0,0,0])

% Functions
function out = function_qd(Q,@)
    
    % Extracting current joints
    q1 = Q(1);
    q2 = Q(2);
    q3 = Q(3);
    q4 = Q(4);
       
    Jv_sym(q1,q2,q3,q4)
    
end

function Or = getOrientMatrix(Ot, id)
    Or = eye(3);
    for i=0:id-1
        Or = Or*Ot(1:3,(1:3)+4*i);
    end
end

function [T, Ot] =  forwardKinematicsPUMA(q1, q2, q3, q4, param)

    y4 = .2;  % Decide later what to do
    
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
    T23 = getTransformMatrixDH(q3, d3, a3, 0)*Rot_y((pi/2))*Rot_x(alph);
    T34 = getTransformMatrixDH(q4, 0, 0, 0);
    T4P = Trans_x(-.06425)*Trans_y(-y4)*Trans_z(-.025);
    
    % T12 = Rot_z(q3)*Trans_z(d3)*Trans_x(a3)*Rot_y(sym(pi/2))*Rot_x(alph);
    
    % Coordinates in the base frame
    T02 = T01*T12;
    T03 = T02*T23;
    T04 = T03*T34;
    T0P = T04*T4P;

    Ot = [T01 T12 T23 T34 T4P];
    T = [T00 T01 T02 T03 T04 T0P];
end

function Draw(q1, q2, q3, q4, param)
    
    T =  forwardKinematicsPUMA(q1, q2, q3, q4, param);
%     str = horzcat('$d_1 = $',num2str(q1,2),' $d_2 = $',num2str(q2,2),' $\theta_3 = $',num2str(q3,2), ...
%         ' $\theta_4 = $',num2str(q4,2),' $\theta_5 = $',num2str(q5,2));
%     title(str,'interpreter','latex');
    hold on; axis equal;
    xlabel('x'); ylabel('y'); zlabel('z'); grid on; box on;

    plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end))    
    for i=1:4:length(T)
        DrawCoordFrame(T(:,i:i+3), 'scale', 0.25, 'linewidth', 2)
    end
    view(3)
end

function Ai = getTransformMatrixDH(theta, d, a, alpha)
    Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
end