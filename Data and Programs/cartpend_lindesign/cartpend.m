function zdot=cartpend(z,F)

q1=z(1);
q2=z(2);
q1dot=z(3);
q2dot=z(4);

%Numerical constants
g=9.81;
m1=2;
m2=1;
h=1;
I2z=1;

M=[m1 + m2 -h*m2*sin(q2);
-h*m2*sin(q2),  m2*h^2 + I2z];

C=[0 -h*m2*q2dot*cos(q2);
    0 0];

gq=[0; g*h*m2*cos(q2)];


zdot=[q1dot;q2dot;inv(M)*([F;0]-C*[q1dot;q2dot]-gq)];

