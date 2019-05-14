%Plant uncertainties:
d=5;
c=0.01;
A=1;

%"Estimated" plant input
%Assume max ranges for x1, x2 (a controller would have to enforce this)
x1max=10;
x2max=10;
fmax=d*x1max+c*x2max^3+A;


%Sliding observer tuning:
k1=70;
k2=70;
alpha1=2;
alpha2=5;
phi1=0.1;
phi2=0.005;


%Initial conditions
x0=0;
xdot0=0;

x1hat0=10;
x2hat0=-10;
