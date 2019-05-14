function zdot=puma2_zdot(t,z,u)
global I1y I2x I2y I2z d2 m2 d3 I2x g

n=length(u);
z_1=z(1:n);
z_2=z(n+1:2*n);

q1=z_1(1);
q2=z_1(2);
q1d=z_2(1);
q2d=z_2(2);

D=[ I1y + I2x + d2^2*m2 - I2x*cos(q2)^2 + I2y*cos(q2)^2 + d3^2*m2*cos(q2)^2, d2*d3*m2*sin(q2);
                                                        d2*d3*m2*sin(q2),    m2*d3^2 + I2z];
 
C=[ -(q2d*sin(2*q2)*(m2*d3^2 - I2x + I2y))/2, d2*d3*m2*q2d*cos(q2) - q1d*((m2*sin(2*q2)*d3^2)/2 - (I2x*sin(2*q2))/2 + (I2y*sin(2*q2))/2);
(q1d*sin(2*q2)*(m2*d3^2 - I2x + I2y))/2,                                                                                          0];
 
gq=[0;
-d3*g*m2*cos(q2)];

dotz_1=z_2;
dotz_2=inv(D)*(u-gq-C*z_2);
zdot=[dotz_1;dotz_2];
