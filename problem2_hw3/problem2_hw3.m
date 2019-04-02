close all
clear all
clc

% QUESTION 2

% Configuration test
q1 = 1;
q2 = -1;
q3 = pi/2;
q4 = pi/2;
q5 = 0;

[T, ~] = forwardKinematicsProb2(q1, q2, q3, q4, q5);

figure;
Draw(q1, q2, q3, q4, q5)
H05 = T(:,(1:4)+4*5);

% Create symbolic joints
syms q1 q2 q3 q4 q5
[T, Ot] = forwardKinematicsProb2sym(q1, q2, q3, q4, q5);

% Extract Position Frames
O1 = T(1:3,4*2);
O2 = T(1:3,4*3);
O3 = T(1:3,4*4);
O4 = T(1:3,4*5);
O5 = T(1:3,4*6);

% Find Orientation Zi
Z0 = [0;0;1];
Z1 = getOrientMatrix(Ot, 1)*Z0;
Z2 = getOrientMatrix(Ot, 2)*Z0;
Z3 = getOrientMatrix(Ot, 3)*Z0;
Z4 = getOrientMatrix(Ot, 4)*Z0;
Z5 = getOrientMatrix(Ot, 5)*Z0;

% Jacoabians
Jv1 = Z0;
Jv2 = Z1;
Jv3 = cross(Z2,O5-O2);
Jv4 = cross(Z3,O5-O3);
Jv5 = cross(Z4,O5-O4);

Jw1 = 0;
Jw2 = 0;
Jw3 = Z2;
Jw4 = Z3;
Jw5 = Z4;

Jv = [Jv1 Jv2 Jv3 Jv4 Jv5];
Jw = [Jw1 Jw2 Jw3 Jw4 Jw5];
J = [Jv; Jw];

Jv_function = matlabFunction(Jv, 'vars', {q1 q2 q3 q4 q5});

% Rank of simbolic jacobian
disp(['Rank of J_v is: ', num2str(rank(Jv)), ' Then it is a FULL RANK'])


% Singular Configuration 1
q1 = 0; q2 = 0; q3 = 0; q4 = pi/2; q5 = 0;

% Rank of singular
rs1 = rank(Jv_function(q1,q2,q3,q4,q5));
disp(['Test for singularity when (q1 = 0; q2 = 0; q3 = 0; q4 = pi/2; q5 = 0)-> rank is ', num2str(rank(Jv)), ' The it is not a FULL RANK'])

% Singular Configuration 2
q1 = 0; q2 = 0; q3 = 0; q4 = 0; q5 = pi/2;

% Rank of singular
rs2 = rank(Jv_function(q1,q2,q3,q4,q5));
disp(['Test for singularity when (q1 = 0; q2 = 0; q3 = 0; q4 = 0; q5 = pi/2)-> rank is ', num2str(rank(Jv)), ' The it is not a FULL RANK'])

syms q1 q2 q3 q4 q5
J_point = rref( [Jv_function(q1,q2,q3,q4,q5) zeros(3,1)] );

disp('');
disp('Yoshikawa’s manipulability:');
ykw = det(J_point*J_point.');
pretty(simplify(ykw))

% Singular Configuration 1
q1 = 0; q2 = 0; q3 = 0; q4 = pi/2; q5 = 0;
% q1 = 0; q2 = 0; q3 = 0; q4 = 0; q5 = pi/2;
disp(['After row echelon form, we know: qd4=qd1 and qd5=-qd2']);
J_point = rref( [Jv_function(q1,q2,q3,q4,q5) zeros(3,1)] )

qd1 = 1;
qd2 = 1;
qd3 = 0;
qd4 = qd1;
qd5 = -qd2;

disp(['which result in an instantaneous zero velocity for P :']);
Jv_function(q1,q2,q3,q4,q5)*[qd1;qd2;qd3;qd4;qd5]

Jwritst = J(4:6,3:5);
Jwritst*Ot(1:3,end-3:end-1)

disp(['Yoshikawa’s manipulability for the wrist:'])
mu_wrist = sqrt(det(Jwritst*Jwritst.'));
simplify(mu_wrist)

% Get Orientation Matrix 
function Or = getOrientMatrix(Ot, id)
    Or = eye(3);
    for i=0:id-1
        Or = Or*Ot(1:3,(1:3)+4*i);
    end
end

function [T, Ot] = forwardKinematicsProb2(q1, q2, q3, q4, q5)

    % Transformation Matrices
    T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    T01 = getTransformMatrixDH(pi/2,    q1, 0,  pi/2);
    T12 = getTransformMatrixDH(-pi/2,   q2, 0, -pi/2);
    T23 = getTransformMatrixDH(q3,      1,  0, -pi/2);
    T34 = getTransformMatrixDH(q4,      0,  0,  pi/2);
    T45 = getTransformMatrixDH(q5,      0, -1, 0);

    % Coordinates in the base frame
    T02 = T01*T12;
    T03 = T02*T23;
    T04 = T03*T34;
    T05 = T04*T45;

    Ot = [T01 T12 T23 T34 T45];
    T = [T00 T01 T02 T03 T04 T05];
end

function [T, Ot] = forwardKinematicsProb2sym(q1, q2, q3, q4, q5)

    % Transformation Matrices
    T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    T01 = getTransformMatrixDH(sym(pi)/2,    q1, 0,  sym(pi)/2);
    T12 = getTransformMatrixDH(-sym(pi)/2,   q2, 0, -sym(pi)/2);
    T23 = getTransformMatrixDH(q3,      1,  0, -sym(pi)/2);
    T34 = getTransformMatrixDH(q4,      0,  0,  sym(pi)/2);
    T45 = getTransformMatrixDH(q5,      0, -1, 0);

    % Coordinates in the base frame
    T02 = T01*T12;
    T03 = T02*T23;
    T04 = T03*T34;
    T05 = T04*T45;

    Ot = [T01 T12 T23 T34 T45];
    T = [T00 T01 T02 T03 T04 T05];
end

function Draw(q1, q2, q3, q4, q5)
    T =  forwardKinematicsProb2(q1, q2, q3, q4, q5);
    str = horzcat('$d_1 = $',num2str(q1,2),' $d_2 = $',num2str(q2,2),' $\theta_3 = $',num2str(q3,2), ...
        ' $\theta_4 = $',num2str(q4,2),' $\theta_5 = $',num2str(q5,2));
    title(str,'interpreter','latex');
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