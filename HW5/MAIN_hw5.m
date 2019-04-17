%Kinematics and parameters for the WAM 4 DOF robot
%Third joint will be frozen at q3 = 0

%Frames and kinematics:
%see https://support.barrett.com/wiki/WAM/KinematicsJointRangesConversionFactors

clear all
close all
clc

addpath('Homogeneous Primitive Transformation');

NLINK = 4;

syms q1 q2 q3 q4 a d
syms q1dot q2dot q3dot 
q = [q1 q2 q3];
qdot = [q1dot q2dot q3dot];

H10 = Rot_z(q1)*Rot_x(-sym(pi)/2);
H21 = Rot_z(q2)*Rot_x(sym(pi)/2);
H32 = Rot_z(q3)*Trans_z(d)*Trans_x(a)*Rot_x(-sym(pi)/2);
H43 = Rot_z(q4)*Trans_x(-a)*Rot_x(sym(pi)/2);  

H20 = H10*H21;
H30 = H20*H32;
H40 = H30*H43;

%Rotations
R1 = H10(1:3,1:3);
R2 = H20(1:3,1:3);
R3 = H30(1:3,1:3);
R4 = H40(1:3,1:3);
R = cat(3, R1,R2,R3,R4);

%z axes
z0 = [0;0;1];
z1 = H10(1:3,3);
z2 = H20(1:3,3);
z3 = H30(1:3,3);
z4 = H40(1:3,3);

%CM locations in local frames
%cmxx denotes cm of link x in frame x]

syms xc1 yc1 zc1 xc2 zc2 yc2 xc3 yc3 zc3 xc4 yc4 zc4

cm11 = [xc1;yc1;zc1;1];
%cm11 = [-0.00443422;0.12189039;-0.00066489;1];
cm22 = [xc2;yc2;zc2;1];
%cm22 = [-0.00236983;0.03105614;0.01542114;1];
cm33 = [xc3;yc3;zc3;1];
%cm33 = [-0.03825858;0.20750770;0.00003309;1];
cm44 = [xc4;yc4;zc4;1];
%cm44 = [0.01095471;-0.00002567;0.14053900;1];

%CM locations in world frame
cm10 = H10*cm11;cm10 = cm10(1:3);
cm20 = H20*cm22;cm20 = cm20(1:3);
cm30 = H30*cm33;cm30 = cm30(1:3);
cm40 = H40*cm44;cm40 = cm40(1:3);

%Origin locations in world frame
o10 = H10(1:3,4);
o20 = H20(1:3,4);
o30 = H30(1:3,4);
o40 = H40(1:3,4);

%Velocity Jacobians relative to CMs
%Link 1
J1v1 = cross(z0,cm10);
J1v = [J1v1 zeros(3,3)];

%Link 2
J2v1 = cross(z0,cm20);
J2v2 = cross(z1,cm20-o10);
J2v = [J2v1 J2v2 zeros(3,2)];

%Link 3
J3v1 = cross(z0,cm30);
J3v2 = cross(z1,cm30-o10);
J3v3 = cross(z2,cm30-o20);
J3v = [J3v1 J3v2 J3v3 zeros(3,1)];

%Link 4
J4v1 = cross(z0,cm40);
J4v2 = cross(z1,cm40-o10);
J4v3 = cross(z2,cm40-o20);
J4v4 = cross(z3,cm40-o30);
J4v = [J4v1 J4v2 J4v3 J4v4];

Jv = cat(3, J1v,J2v,J3v,J4v);

%Angular velocity Jacobians
J1w = [z0 zeros(3,3)];
J2w = [z0 z1 zeros(3,2)];
J3w = [z0 z1 z2 zeros(3,1)];
J4w = [z0 z1 z2 z3];
Jw = cat(3, J1w,J2w,J3w,J4w);

syms m1 m2 m3 m4 
m = cat(3, m1,m2,m3,m4);

% Inertia Tensor
syms I1xx I1xy I1xz I1yy I1yz I1zz 
syms I2xx I2xy I2xz I2yy I2yz I2zz
syms I3xx I3xy I3xz I3yy I3yz I3zz
syms I4xx I4xy I4xz I4yy I4yz I4zz 

I1 = getSkewSymmetricMatrix([I1xx I1yy I1zz], [I1xy I1xz I1yz]);
I2 = getSkewSymmetricMatrix([I2xx I2yy I2zz], [I2xy I2xz I2yz]);
I3 = getSkewSymmetricMatrix([I3xx I3yy I3zz], [I3xy I3xz I3yz]);
I4 = getSkewSymmetricMatrix([I4xx I4yy I4zz], [I4xy I4xz I4yz]);
I = cat(3, I1,I2,I3,I4);

D4 = sym(zeros(4));
for i=1:NLINK
    D4 = D4 + m(i)*Jv(:,:,i).'*Jv(:,:,i) + Jw(:,:,i).'*R(:,:,i)*I(:,:,i)*R(:,:,i).'*Jw(:,:,i);
end
q3 =0;
eval(D4);

D = D4([1:2 4], [1:2 4]);
% D = simplify(D, 'ArithmeticOnly', true);
Ddot = zeros(3);
for i=1:3
    Ddot = Ddot + diff(D,q(i))*qdot(i);
end

% Coriolis/Centripetal Matrix
for i=1:3
    for j=1:3
        for k=1:3
            c(i,k,j) = .5* ( diff(D(k,j),q(i)) + diff(D(k,i),q(j)) + diff(D(i,j),q(k)));
        end
    end
end

for k=1:3
    for j=1:3
        C(k,j) = c(1,j,k)*q1dot + c(2,j,k)*q2dot + c(3,j,k)*q3dot;
    end
end

skewDdot = Ddot-2*C;

i = [2 3 3];
j = [1 1 2];
sD = 0;
for k=1:3
    sD = sD + skewDdot(i(k),j(k)) - skewDdot(j(k),i(k));
end
% q3 = 0;
% eval(D);
% simplify(D)
% simplify(D,'AithmeticOnly', true)
% D1 = m1*J1v.'*J1v + J1w.'*R1*


function S = getSkewSymmetricMatrix(Iaa,Iabc)
    S = sym(zeros(3));
    S(1:end,1:end) = diag(Iaa);
    S(1,2) = Iabc(1);
    S(1,3) = Iabc(2);
    S(2,3) = Iabc(3);
    S(2,1) = S(1,2);
    S(3,1) = S(1,3);
    S(3,2) = S(2,3);
end
