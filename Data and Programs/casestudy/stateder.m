function zdot=stateder(z,V,Te)
%Two-link planar manipulator state derivatives with external force
%MCE647 Case Study, Spring 2015

%V are the control voltages

%True parameters
%Robot:
m1=1; %kg
m2=1; %kg
l1=0.75; %m
lc1=l1/2;  %to center of mass
l2=0.75; %m
lc2=l2/2;  %to center of mass
I1=0.1; %kg-m^2
I2=0.1; %kg-m^2
g=9.81; %m/s^2
B1=0.1; %link 1 damping, Nms
B2=0.1; %link 2 damping, Nms


%Drive system:
n1=30; %gear ratio
n2=15; %gear ratio
bm1=0.001; %motor 1 damping, Nms
bm2=0.001; %motor 2 damping, Nms
alpha1=0.05; %motor 1 torque constant, Nm/A
alpha2=0.05; %motor 2 torque constant, Nm/A
R1=1; %motor 1 resistance, ohm
R2=1; %motor 2 resistance, ohm
Jm1=5e-5; %motor 1 inertia, kg-m^2
Jm2=5e-5; %motor 2 inertia, kg-m^2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=length(z);
z_1=z(1:n/2);
z_2=z(n/2+1:n);
%find numerical values for matrices M, C and calculate state derivatives
D(1,1)=m1*lc1^2+m2*(l1^2+lc2^2+2*l1*lc2*cos(z_1(2)))+I1+I2;
D(1,2)=m2*(lc2^2+l1*lc2*cos(z_1(2)))+I2;
D(2,1)=D(1,2);
D(2,2)=m2*lc2^2+I2;
%Augment with motor inertias
M=D+diag([Jm1*n1^2 Jm2*n2^2]);

%Damping matrix:
R=[B1+n1^2*(bm1+alpha1^2/R1); B2+n2^2*(bm2+alpha2^2/R2)];

%Coriolis:

h=-m2*l1*lc2*sin(z_1(2));

C(1,1)=h*z_2(2);
C(1,2)=h*z_2(2)+h*z_2(1);
C(2,1)=-h*z_2(1);
C(2,2)=0;

%Gravity:
gg(1,1)=(m1*lc1+m2*l1)*g*cos(z_1(1))+m2*lc2*g*cos(z_1(1)+z_1(2));
gg(2,1)=m2*lc2*g*cos(z_1(1)+z_1(2));

%External force: Te (passed to function)

u=[V(1)*alpha1*n1/R1;V(2)*alpha2*n2/R2];

zdot=[z_2;inv(M)*(u-C*z_2-R-gg-Te)];

