%cartpend_kin
%Develops the forward kinematics necessary to 
%obtain a dynamic model of the cart-pendulum system

syms q1 q2 h

%To frame 1: (Transz,q1)*(Rotx,-pi/2)
H10=[1 0 0 0;0 0 1 0;0 -1 0 q1;0 0 0 1];
 
%To frame 2: (Rotz,q2)
H21=[cos(q2) -sin(q2) 0 0;sin(q2) cos(q2) 0 0;0 0 1 0;0 0 0 1];

H20=H10*H21;

%CM origins
o10=[0;0;q1];
o20=H20*[0;-h;0;1];
o20=o20(1:3);

%Actuation axes
z0=[0;0;1];
z1=[0;1;0];

%Jacobians relative to CM1
J1v1=z0; %prismatic joint
J1v2=[0;0;0]; %the velocity a link is independent from the velocities of higher links
J1v=[J1v1 J1v2];

J1w=zeros(3,2); %prismatic joint; the velocity a link is independent from....

J2v1=z0; %prismatic joint
J2v2=cross(z1,o20-o10);
J2v=[J2v1 J2v2];

J2w1=[0;0;0]; %prismatic joint
J2w2=z1;
J2w=[J2w1 J2w2]; 

%%
%Compute rotations for use in inertia matrix computations
R1=zeros(3,3); %frame 1 is not rotated
R2=H20(1:3,1:3);


