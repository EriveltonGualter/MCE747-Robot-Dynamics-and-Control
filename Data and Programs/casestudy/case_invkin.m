%casestudy_invkin

%Calculates online desired joint trajectories for the case study

function qds=case_invkin(t,z)

q1=z(1);
q2=z(2);
q1dot=z(3);
q2dot=z(4);


l1=0.75; %m
l2=0.75; %m


%Horiz distance
d=1.25;

%Desired end effector position
x=d+0.01;
y=0.5+0.25*sin(t);

%Solve inverse kinematics, elbow up

D=(x^2+y^2-l1^2-l2^2)/2/l1/l2;
q2d=atan(sqrt(1-D^2)/D);
q1d=atan(y/x)-atan(l2*sin(q2)/(l1+l2*cos(q2)));

%Inverse velocity and acceleration (see inv_vel_accel for offline
%symbolic computations)

%Inverse kinematic Jacobian at the end effector (from symbolic computation)
iJv=[cos(q1 + q2)/(l1*sin(q2)) sin(q1 + q2)/(l1*sin(q2));-(l2*cos(q1 + q2) + l1*cos(q1))/(l1*l2*sin(q2)) -(l2*sin(q1 + q2) + l1*sin(q1))/(l1*l2*sin(q2))];

xdot=0;
ydot=0.25*cos(t);
qdots=iJv*[xdot;ydot];
q1ddot=qdots(1);q2ddot=qdots(2);

%Inverse acceleration:
A=[-l2*sin(q1+q2)-l1*sin(q1) 0;l2*cos(q1+q2)+l1*cos(q1) l2*cos(q1+q2)];
B(1,1)=- q1dot*(q1dot*(l2*cos(q1 + q2) + l1*cos(q1)) + l2*q2dot*cos(q1 + q2)) - q2dot*(l2*q1dot*cos(q1 + q2) + l2*q2dot*cos(q1 + q2)) - l2*q2ddot*sin(q1 + q2);
B(2,1)=- q2dot*(l2*q1dot*sin(q1 + q2) + l2*q2dot*sin(q1 + q2)) - q1dot*(q1dot*(l2*sin(q1 + q2) + l1*sin(q1)) + l2*q2dot*sin(q1 + q2));

accels=inv(A)*B;
q1dddot=accels(1);
q2dddot=accels(2);

qds=[q1d;q2d;q1ddot;q2ddot;q1dddot;q2dddot];

 