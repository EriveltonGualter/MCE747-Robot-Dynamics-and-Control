%setup647
%Loads parameters for basic fully-actuated inverted pendulum simulation

m=1; %bar mass
h=.5;  %bar CM location
I=0.44; %Moment of inertia of bar relative to pivot
m2=1e-5; %gears inertia
n2=10;   %reduction ratio
b2=.01; %motor damping
TH1=1.7+m; 
TH2=m*h;
TH3=I+m*h^2+m2*n2^2;
TH4=12;
TH5=0.3;
TH6=b2*n2^2;
%TH=[TH1;TH2;TH3;TH4;TH5;TH6];
alph=0.05; %Torque constant of DC machine
Ra=1.5;    %Series resistance
a2=alph*n2; 
rr=1;
Rs=0.0;
R2=Ra+rr^2*Rs;
g=9.81;

w1=2; %frequency of cart oscillation, rad/s
A1=0.1; %amplitude of cart oscillation, m
w2=3; %frequency of bar oscillation, rad/s
A2=0.25; %amplitude of bar oscillation, rad

%Initial conditions
Z0=[0;pi/4;0;0];

%1. Run this file
%2. Simulate with the Simulink file
%3. Plot trajectories to see good tracking with
%>> plot(t,q1,t,q1d)
%>> plot(t,q2,t,q2d)
%>> plot(t,q3,t,q3d)


