function out=IJSMC(z,zd)

g=9.81;
M1=1.6512;
M2=0.2519;
K1=1.5;
K2=0.75;

q1=z(1);
q2=z(2);
q1dot=z(3);
q2dot=z(4);

q1d=zd(1);
q2d=zd(2);
q1ddot=zd(3);
q2ddot=zd(4);
q1dddot=zd(5);
q2dddot=zd(6);

qtilde=[q1-q1d;q2-q2d];
qtildedot=[q1dot-q1ddot;q2dot-q2ddot];

%Gains
L=diag([10 10]);
phi1=.10;
phi2=.10;
eta1=10;
eta2=100;


s=qtildedot+L*qtilde;

u=zd(5:6)-L*(z(3:4)-zd(3:4))-[eta1*satf(s(1)/phi1);eta2*satf(s(2)/phi2)];

V=diag([M1/K1 M2/K2])*u;

out=[V;s];

