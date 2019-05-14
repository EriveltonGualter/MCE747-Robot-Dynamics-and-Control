%Setup
%Case study: two-link planar RR manipulator


%Nominal parameters
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


n1=30; %gear ratio
n2=15; %gear ratio
alpha1=0.05; %motor 1 torque constant, Nm/A
alpha2=0.05; %motor 2 torque constant, Nm/A
R1=1; %motor 1 resistance, ohm
R2=1; %motor 2 resistance, ohm
Jm1=5e-5; %motor 1 inertia, kg-m^2
Jm2=5e-5; %motor 2 inertia, kg-m^2



%For use in IJ-SMC:
M1=m1*lc1^2+I1+I2+m2*(l1+lc2)^2+(n1^2)*Jm1;
M2=m2*lc2^2+I2+(n2^2)*Jm2;
K1=n1*alpha1/R1;
K2=n2*alpha2/R2;




Z0=[pi/4;-pi/4;0;0]; %initial condition for plant integrator
