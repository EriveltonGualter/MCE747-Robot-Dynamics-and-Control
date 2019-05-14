function zdot=stateder(t,z,u)
%Two-link planar manipulator state derivatives
m1=10.9803;
m2=8.5778;
l1=0.6357;
lc1=l1/2;  %to center of mass
l2=0.4241;
lc2=l2/2;  %to center of mass
I1=25.406;
I2=12.5467;
g=9.8;

n=length(z);
z_1=z(1:n/2);
z_2=z(n/2+1:n);
%find numerical values for matrices M, C and calculate state derivatives
D(1,1)=m1*lc1^2+m2*(l1^2+lc2^2+2*l1*lc2*cos(z_1(2)))+I1+I2;
D(1,2)=m2*(lc2^2+l1*lc2*cos(z_1(2)))+I2;
D(2,1)=D(1,2);
D(2,2)=m2*lc2^2+I2;

h=-m2*l1*lc2*sin(z_1(2));

C(1,1)=h*z_2(2);
C(1,2)=h*z_2(2)+h*z_2(1);
C(2,1)=-h*z_2(1);
C(2,2)=0;

gg(1,1)=(m1*lc1+m2*l1)*g*cos(z_1(1))+m2*lc2*g*cos(z_1(1)+z_1(2));
gg(2,1)=m2*lc2*g*cos(z_1(1)+z_1(2));

zdot=[z_2;inv(D)*(u-C*z_2-gg)];

