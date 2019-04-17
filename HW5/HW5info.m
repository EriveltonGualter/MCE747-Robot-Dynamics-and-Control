%Kinematics and parameters for the WAM 4 DOF robot
%Third joint will be frozen at q3=0

%Frames and kinematics:
%see https://support.barrett.com/wiki/WAM/KinematicsJointRangesConversionFactors

syms q1 q2 q3 q4 a d

H10=Rotz(q1)*Rotx(-sym(pi)/2);
H21=Rotz(q2)*Rotx(sym(pi)/2);
H32=Rotz(q3)*Transz(d)*Transx(a)*Rotx(-sym(pi)/2);
H43=Rotz(q4)*Transx(-a)*Rotx(sym(pi)/2);  

H20=H10*H21;
H30=H20*H32;
H40=H30*H43;

%Rotations
R1=H10(1:3,1:3);
R2=H20(1:3,1:3);
R3=H30(1:3,1:3);
R4=H40(1:3,1:3);



%z axes
z0=[0;0;1];
z1=H10(1:3,3);
z2=H20(1:3,3);
z3=H30(1:3,3);
z4=H40(1:3,3);

%CM locations in local frames
%cmxx denotes cm of link x in frame x]

syms xc1 yc1 zc1 xc2 zc2 yc2 xc3 yc3 zc3 xc4 yc4 zc4

cm11=[xc1;yc1;zc1;1];
%cm11=[-0.00443422;0.12189039;-0.00066489;1];
cm22=[xc2;yc2;zc2;1];
%cm22=[-0.00236983;0.03105614;0.01542114;1];
cm33=[xc3;yc3;zc3;1];
%cm33=[-0.03825858;0.20750770;0.00003309;1];
cm44=[xc4;yc4;zc4;1];
%cm44=[0.01095471;-0.00002567;0.14053900;1];

%CM locations in world frame
cm10=H10*cm11;cm10=cm10(1:3);
cm20=H20*cm22;cm20=cm20(1:3);
cm30=H30*cm33;cm30=cm30(1:3);
cm40=H40*cm44;cm40=cm40(1:3);

%Origin locations in world frame
o10=H10(1:3,4);
o20=H20(1:3,4);
o30=H30(1:3,4);
o40=H40(1:3,4);

%Velocity Jacobians relative to CMs
%Link 1
J1v1=cross(z0,cm10);
J1v=[J1v1 zeros(3,3)];

%Link 2
J2v1=cross(z0,cm20);
J2v2=cross(z1,cm20-o10);
J2v=[J2v1 J2v2 zeros(3,2)];

%Link 3
J3v1=cross(z0,cm30);
J3v2=cross(z1,cm30-o10);
J3v3=cross(z2,cm30-o20);
J3v=[J3v1 J3v2 J3v3 zeros(3,1)];

%Link 4
J4v1=cross(z0,cm40);
J4v2=cross(z1,cm40-o10);
J4v3=cross(z2,cm40-o20);
J4v4=cross(z3,cm40-o30);
J4v=[J4v1 J4v2 J4v3 J4v4];

%Angular velocity Jacobians
J1w=[z0 zeros(3,3)];
J2w=[z0 z1 zeros(3,2)];
J3w=[z0 z1 z2 zeros(3,1)];
J4w=[z0 z1 z2 z3];

%gravity
g=9.81;

%Local CM coordinates

xc1=-0.00443422;
yc1=0.12189039;
zc1=-0.00066489;
xc2=-0.00236983;
yc2=0.03105614;
zc2=0.01542114;
xc3=-0.03825858;
yc3=0.20750770;
zc3=0.00003309;
xc4=0.01095471;
yc4=-0.00002567;
zc4=0.14053900;

%Moments of inertia
I1xx=0.29486350;
I1xy=-0.00795023;
I1xz=-0.00009311;
I1yy=0.11350017;
I1yz=-0.00018711;
I1zz=0.25065343;

I2xx=0.02606840;
I2xy=-0.00001346;
I2xz=-0.00011701;
I2yy=0.01472202;
I2yz=0.00003659;
I2zz=0.01934814;

I3xx=0.13671601;
I3xy=-0.01680434;
I3xz=0.00000510;
I3yy=0.00588354;
I3yz=-0.00000530;
I3zz=0.13951371;

I4xx=0.03952350;
I4xy=0.00000189;
I4xz=0.00003117;
I4yy=0.04008214;
I4yz=0.00000131;
I4zz=0.00210299;

%Link masses
m1=10.76768767;
m2=3.87493756;
m3=1.80228141;
m4=1.06513649; %elbow+blank link

%Other kinematic parameters
a=0.045;
d=0.35;
