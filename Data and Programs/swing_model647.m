%swing_model
%Derives the dynamic model matrices for the a prosthesis test robot in swing mode
%Uses 3-link PRR planar manipulator configuration

syms q1 q2 q3 d0 l2 c1y c2 c3 
syms g I2x I2y I2z I3x I3y I3z m1 m2 m3 
syms q1dot q2dot q3dot 
%Set up coordinate transformations

%From world to frame 1:
%(Trans z,q1)(Rot x,90)
Tzq1=[1 0 0 0; 0 1 0 0;0 0 1 q1; 0 0 0 1];
Rx90=[1 0 0 0; 0 0 -1 0;0 1 0 0; 0 0 0 1];
A10=Tzq1*Rx90;
%From frame 1 to frame 2: 
%(Rot z,q2)(Trans z,d0)(Transx,l2)
Rzq2=[cos(q2) -sin(q2) 0 0; sin(q2) cos(q2) 0 0; 0 0 1 0; 0 0 0 1];
Tzd0=[1 0 0 0; 0 1 0 0;0 0 1 d0; 0 0 0 1];
Txl2=[1 0 0 l2; 0 1 0 0;0 0 1 0; 0 0 0 1];
A21=Rzq2*Tzd0*Txl2;
A20=A10*A21;
%From frame 2 to frame 3: 
%(Rot z,q3)(Trans x,c3)
Rzq3=[cos(q3) -sin(q3) 0 0; sin(q3) cos(q3) 0 0; 0 0 1 0; 0 0 0 1];
Txc2=[1 0 0 c3; 0 1 0 0;0 0 1 0; 0 0 0 1];
A32=Rzq3*Txc2;

%Overall transformation:
A30=simplify(A10*A21*A32);

%Find the Jacobians to the centers of mass:
%Link 1:
o10=[0;-d0;q1]; %origin of frame 1 in world coords
c10=[0;c1y;q1]; %CM of L1 in world coords
z0=[0;0;1];
J1v1=z0; %prismatic joint
J1v2=[0;0;0]; 
J1v3=[0;0;0]; %the velocity a link is independent from higher links
J1v=[J1v1 J1v2 J1v3];

J1w=zeros(3,3);

%Link 2:
o22=A20*[0;0;0;1];
o20=o22(1:3);  %origin of frame 2 in world coords
c22=[c2;0;0;1]; %c2 will have a negative numerical value
c20=A20*c22;
c20=c20(1:3); %CM of L2 in world coords 
z1=[0;-1;0]; %z1, z2 and z3 match -y0 (planar robot)
z2=z1;
z3=z1;
J2v1=z0; %prismatic joint
J2v2=cross(z1,c20-o10);
J2v3=[0;0;0]; %the velocity a link is independent from higher links
J2v=[J2v1 J2v2 J2v3];

J2w1=[0;0;0]; %Joint 1 is prismatic
J2w2=z1;
J2w3=[0;0;0];

J2w=[J2w1 J2w2 J2w3];

%Link 3:
o33=[0;0;0;1];
o30=A30*o33;
o30=o30(1:3); %origin of frame and CM of L3 in world coords
J3v1=z0; %prismatic joint
J3v2=cross(z1,o30-o10);
J3v3=cross(z2,o30-o20);
J3v=[J3v1 J3v2 J3v3];

J3w1=[0;0;0];
J3w2=z1;
J3w3=z2;

J3w=[J3w1 J3w2 J3w3];



%Inertia Matrix
I2=diag([I2x I2y I2z]);
I3=diag([I3x I3y I3z]);
R2=A20(1:3,1:3);
R3=A30(1:3,1:3);

sum=m1*J1v.'*J1v;
sum=sum+m2*J2v.'*J2v+J2w.'*R2*I2*R2.'*J2w;
sum=sum+m3*J3v.'*J3v+J3w.'*R3*I3*R3.'*J3w;
D_q=simplify(sum);

%Coriolis/Centripetal Matrix
q=[q1;q2;q3];
for i=1:3,
for j=1:3,
for k=1:3,
c(i,j,k)=(1/2)*((diff(D_q(k,j),q(i)))+(diff(D_q(k,i),q(j)))-(diff(D_q(i,j),q(k))));
end
end
end

for k=1:3,
for j=1:3,
C(k,j)=c(1,j,k)*q1dot+c(2,j,k)*q2dot+c(3,j,k)*q3dot;
end
end

%Potential Energy
gv=[0;0;g];  %gravity direction in world frame
P=-m1*gv.'*c10-m2*gv.'*c20-m3*gv.'*o30;

gq1=simplify(diff(P,q1));
gq2=simplify(diff(P,q2));
gq3=simplify(diff(P,q3));

gq=[gq1;gq2;gq3];

