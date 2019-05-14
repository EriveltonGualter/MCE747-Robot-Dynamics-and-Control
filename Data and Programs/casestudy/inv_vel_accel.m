%inv_vel_accel
%Solves the inverse velocity and acceleration problems symbolically
%Case study: two-link planar RR manipulator


syms l1 l2 q1 q2
%Kinematic Jacobian at the end effector (from other codes)
Jv=[-l2*sin(q1+q2)-l1*sin(q1) -l2*sin(q1+q2);l2*cos(q1+q2)+l1*cos(q1)  l2*cos(q1+q2)];

%Symbolic inverse Jacobian
iJv=inv(Jv);

%Calculate explicit velocities
syms q1dot q2dot q1ddot q2ddot
v=Jv*[q1dot;q2dot];
xdot=v(1);
ydot=v(2);
%Differentiate to find acceleration
ax=diff(xdot,q1)*q1dot+diff(xdot,q2)*q2dot+diff(xdot,q1dot)*q1ddot+diff(xdot,q2dot)*q2ddot;
ay=diff(ydot,q1)*q1dot+diff(ydot,q2)*q2dot+diff(ydot,q1dot)*q1ddot+diff(ydot,q2dot)*q2ddot;

%Restrict to zero x velocity
xdot=0;
simplify(eval(ax))
simplify(eval(ay))
%Linearity in joint acceleration is observed

%Form as system of linear equations
A(1,1)=diff(ax,q1ddot);
A(2,2)=diff(ax,q2ddot);
A(2,1)=diff(ay,q1ddot);
A(2,2)=diff(ay,q2ddot);

B(1,1)=ax-A(1,1)*q1ddot-A(1,2)*q2ddot;
B(2,1)=ay-A(2,1)*q1ddot-A(2,2)*q2ddot;

%Solve offline if desired
%inv(A)*B
