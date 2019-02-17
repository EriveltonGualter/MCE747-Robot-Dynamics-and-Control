function u=invdyn647(z,zd)

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

q1=z(1);
q2=z(2);
q1dot=z(3);
q2dot=z(4);

q1d=zd(1);
q2d=zd(4);
q1ddot=zd(2);
q2ddot=zd(5);
q1dddot=zd(3);
q2dddot=zd(6);

qtilde=[q1-q1d;q2-q2d];
qtildedot=[q1dot-q1ddot;q2dot-q2ddot];

%Gains
K0=diag([4 4]);
K1=diag([2 2]);

%Virtual accel
a=[q1dddot;q2dddot]-K0*qtilde-K1*qtildedot;
a1=a(1);
a2=a(2);

%Form the regressor
Y(1,1)=a1;
Y(1,2)=-a2*sin(q2)-q2dot^2*cos(q2);
Y(1,3)=0;
Y(1,4)=q1dot;
Y(1,5)=sign(q1dot);
Y(1,6)=0;

% -----------------------------------
Y(2,1)=0;
Y(2,2)=-a1*sin(q2)+g*cos(q2);
Y(2,3)=a2;
Y(2,4)=0;
Y(2,5)=0;
Y(2,6)=q2dot;



u0=Y*TH;


%Motor 1 average input constant:
k1=1.25; %in N/volt

u=diag([1/k1 1])*u0;