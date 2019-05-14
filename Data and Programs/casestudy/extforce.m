function out=extforce(z)

l1=0.75; %m
l2=0.75; %m
d=1.29; %wall location, m
kw=1e5; %wall stiffness, N/m
  
q1=z(1);
q2=z(2);
q1dot=z(3);
q2dot=z(4);

%Position of the end effector from forward kinematics
x=l1*cos(q1)+l2*cos(q1+q2);
y=l1*sin(q1)+l2*sin(q1+q2);

%Vertical end effector velocity 
ydot=l1*cos(q1)*q1dot+l2*cos(q1+q2)*(q1dot+q2dot);

%Compute normal and tangential forces


%Wall deflection
delta=max(0,x-d);
Fn=kw*delta;
if Fn>100, %create frictional forces only if there is sufficient normal pressure
    Ft=(0.1*sign(ydot)+0.1*ydot);
else
    Ft=0;
end
%Compute joint moments due to external force
Te=[Fn*(l2*sin(q1 + q2) + l1*sin(q1)) + Ft*(l2*cos(q1 + q2) + l1*cos(q1));Ft*l2*cos(q1 + q2) + Fn*l2*sin(q1 + q2)];

out=[Fn;Ft;Te];    