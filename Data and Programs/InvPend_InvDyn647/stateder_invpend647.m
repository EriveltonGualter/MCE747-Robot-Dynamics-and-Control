function zdot=stateder_invpend647(z,u0)
%Inverted pendulum on cart
%Simulation assumes a motor for the cart, direct torque input for the
%pendulum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters
m=1; %bar mass
h=.5;  %bar CM location
I=0.44; %Moment of inertia of bar relative to pivot
m2=1e-5; %gears inertia
n2=10;   %reduction ratio
b2=.01; %motor damping

alph=0.05; %Torque constant of DC machine
Ra=1.5;    %Resistance
a2p=alph*n2; 
g=9.81;

TH1=1.7+m; 
TH2=m*h;
TH3=I+m*h^2+m2*n2^2;
TH4=12;
TH5=0.3;
TH6=b2*n2^2+a2p^2/Ra;

TH=[TH1;TH2;TH3;TH4;TH5;TH6];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k1=1.25; %in N/volt
%Parse inputs
z_1=z(1:2);
z_2=z(3:4);
q1=z_1(1);q2=z_1(2);
q1dot=z_2(1);q2dot=z_2(2);
D(1,1)=TH1;D(1,2)=-TH2*sin(q2);
D(2,1)=D(1,2);D(2,2)=TH3;
C(1,1)=0;C(1,2)=-TH2*q2dot*cos(q2);
C(2,1)=0;C(2,2)=0;
R=[TH4*q1dot+TH5*sign(q1dot);TH6*q2dot];
gg=[0;TH2*g*cos(q2)];
u=diag([k1 1])*u0; 
zdot=[z_2;inv(D)*(u-R-C*z_2-gg)];


      



    