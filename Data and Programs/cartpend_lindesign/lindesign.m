%lindesign
%Linearization design for the cart-pendulum

syms m1 m2 h I2z q2 q2dot g

%Matrices (assumed given from dynamic modeling process)

M=[m1 + m2 -h*m2*sin(q2);
-h*m2*sin(q2),  m2*h^2 + I2z];

C=[0 -h*m2*q2dot*cos(q2);
    0 0];

gq=[0; g*h*m2*cos(q2)];


%Find accelerations

syms F q1dot

a=inv(M)*([F;0]-C*[q1dot;q2dot]-gq);

%Find partial derivatives of acceleration
syms q1 
DaDq1=diff(a,q1);
DaDq1dot=diff(a,q1dot);
DaDq2=diff(a,q2);
DaDq2dot=diff(a,q2dot);
DaDF=diff(a,F);

%Find numerical values of partial derivatives at upright
%equilibrium
F=0;q2=pi/2;q2dot=0;

%Assume numerical constants
g=9.81;
m1=2;
m2=1;
h=1;
I2z=1;

DaDq1=eval(DaDq1);
DaDq1dot=eval(DaDq1dot);
DaDq2=eval(DaDq2);
DaDq2dot=eval(DaDq2dot);
DaDF=eval(DaDF);

%Find state-space matrices
%State vector is [q1;q2;q1dot;q2dot]

A=[zeros(2,2) eye(2);DaDq1 DaDq2 DaDq1dot DaDq2dot];
B=[zeros(2,1);DaDF];

%Design a linear quadratic regulator
Q=diag([1 1 1 1]);R=1;
K=lqr(A,B,Q,R);


%Verify regulation near upright equilibrium

%Initial condition:

q10=0.2;
q20=0.9*pi/2; %fails at 0.28*pi/2 for q10=0.2, zero initial speeds
q1dot0=0;
q2dot0=0;

z0=[q10;q20;q1dot0;q2dot0];

%Equilibrium point:
zeq=[0;pi/2;0;0];

sim('lineardesign')
plot(t,z)
legend('q1','q2','q3','q4')

