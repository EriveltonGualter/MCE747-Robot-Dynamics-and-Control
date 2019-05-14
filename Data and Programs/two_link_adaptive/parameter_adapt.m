function th_hat_dot=parameter_adapt(t,z,zd)

Gamma_1=10*eye(5);
g=9.8;
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
L=diag([1 1]);
K=diag([1 1]);

v=[q1ddot;q2ddot]-L*qtilde;
a=[q1dddot;q2dddot]-L*qtildedot;
r=qtildedot+L*qtilde;

%Form the regressor
Y(1,1)=a(1);
Y(1,2)=cos(q2)*(2*a(1)+a(2))-sin(q2)*q2dot*v(1)-sin(q2)*(q1dot+q2dot)*v(2);
Y(1,3)=a(2);
Y(1,4)=g*cos(q1);
Y(1,5)=g*cos(q1+q2);
Y(2,1)=0;
Y(2,2)=cos(q2)*a(1)+sin(q2)*q1dot*v(1);
Y(2,3)=a(1)+a(2);
Y(2,4)=0;
Y(2,5)=Y(1,5);
th_hat_dot=-Gamma_1*Y'*r;
