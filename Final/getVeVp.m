function [Ve, Vp] = getVeVp()

syms a d g
syms q1 q2 q3 q4 
syms q1dot q2dot q3dot q4dot 
syms q1ddot q2ddot q4ddot 

% Add Homogeneous Primitive Transformation Library
disp('Adding Homogeneous Primitive Transformation Library ...');
addpath('Homogeneous Primitive Transformation');

% Homogenous Transformation
H10 = Rot_z(q1)*Rot_x(-sym(pi)/2);
H21 = Rot_z(q2)*Rot_x(sym(pi)/2);
H32 = Rot_z(q3)*Trans_z(d)*Trans_x(a)*Rot_x(-sym(pi)/2);
H43 = Rot_z(q4)*Trans_x(-a)*Rot_x(sym(pi)/2);  

% World Frame
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

% CM locations in local frames
% cmxx denotes cm of link x in frame x]

syms xc1 yc1 zc1 xc2 zc2 yc2 xc3 yc3 zc3 xc4 yc4 zc4

cm11 = [-0.00443422;0.12189039;-0.00066489;1];
cm22 = [-0.00236983;0.03105614;0.01542114;1];
cm33 = [-0.03825858;0.20750770;0.00003309;1];
cm44 = [0.01095471;-0.00002567;0.14053900;1];

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
oe0 = H40*[0;0;.36;1];  % End-Effector in World Frame
oe0 = oe0(1:3);

%Velocity Jacobians relative to CMs
%Link 4
J4pv1 = cross(z0,o40);
J4pv2 = cross(z1,o40-o10);
J4pv3 = cross(z2,o40-o20);
J4pv4 = cross(z3,o40-o30);
J4pv = [J4pv1 J4pv2 J4pv3 J4pv4];

Vp = J4pv*[q1dot; q2dot; q3dot; q4dot];

J4ev1 = cross(z0,oe0);
J4ev2 = cross(z1,oe0-o10);
J4ev3 = cross(z2,oe0-o20);
J4ev4 = cross(z3,oe0-o30);
J4ev = [J4ev1 J4ev2 J4ev3 J4ev4];

Ve = J4ev*[q1dot; q2dot; q3dot; q4dot];

a = 0.045;
d = 0.55;

Vp = eval(Vp);
Ve = eval(Ve);

end

