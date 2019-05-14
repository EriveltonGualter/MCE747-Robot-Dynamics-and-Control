%puma_dyn2.m
%Develops dynamic equations for the PUMA560 (first 2 links only)
%Hanz Richter, CSU 2012

syms q1 q2 d1 d2 d3

%Develop transformations as done in class
Rxm90=[1 0 0 0; 0 0 1 0;0 -1 0 0; 0 0 0 1]; %Rotx,-90
%Note use +/-1 instead of cos(-pi/2) and sin(-pi/2) to avoid numerical representation problems (vpa) 

%A10: (Rotz,q1)(Transz,d1)(Rotx,-pi/2)
A10=[cos(q1) -sin(q1) 0 0; sin(q1) cos(q1) 0 0; 0 0 1 d1; 0 0 0 1]*Rxm90;
%A21: (Rotz,q2)(Transz,d2)(Transx,d3)
A21=[cos(q2) -sin(q2) 0 0; sin(q2) cos(q2) 0 0; 0 0 1 0; 0 0 0 1]*[1 0 0 0; 0 1 0 0;0 0 1 d2; 0 0 0 1]*[1 0 0 d3; 0 1 0 0;0 0 1 0; 0 0 0 1];
A20=simplify(A10*A21);
R1=simplify(A10(1:3,1:3));
R2=simplify(A20(1:3,1:3));

%Find the Jacobians to the centers of mass
%To first link CM: J1
o1=[0;0;d1]; %We are assuming that the CM of L1 is at o1 
z0=[0;0;1];
J1v1=cross(z0,o1);
J1v2=[0;0;0]; %the velocity of link n is independent of the motion of higher links
J1v=[J1v1 J1v2];
J1w1=z0;
J1w2=[0;0;0];
J1w=[J1w1 J1w2];

%To second link CM: J2
o2=simplify(A20*[0;0;0;1]); %Assuming that the CM of L2 is at o2
o2=eval(o2(1:3));
%z1=z0; This is a mistake from the old coord system
z1=R1*[0;0;1];
J2v1=cross(z0,o2);
J2v2=cross(z1,o2-o1);
J2w1=z0;
J2w2=z1;
J2v=[J2v1 J2v2];
J2w=[J2w1 J2w2];

%Inertia matrix derivations
syms I1x I1y I1z I2x I2y I2z m1 m2
I1=diag([I1x I1y I1z]);
I2=diag([I2x I2y I2z]);

sum=m1*J1v.'*J1v+J1w.'*R1*I1*R1.'*J1w;
sum=simplify(sum+m2*J2v.'*J2v+J2w.'*R2*I2*R2.'*J2w);

D=sum;

D11=D(1,1);
D12=D(1,2);
D21=D12;
D22=D(2,2);

%Coriolis Matrix Derivation

c111=diff(D11,q1)/2;
c211=diff(D11,q2)/2;
c221=(diff(D12,q2)+diff(D12,q2)-diff(D22,q1))/2;
c112=(diff(D21,q1)+diff(D21,q1)-diff(D11,q2))/2;
c222=diff(D22,q2)/2;
c122=(diff(D22,q1)+diff(D21,q2)-diff(D12,q2))/2;
c121=c211;
c212=c122;

syms q1d q2d
qdot=[q1d;q2d];

c11=simplify([c111 c211]*qdot);
c12=simplify([c121 c221]*qdot);
c21=simplify([c112 c212]*qdot);
c22=simplify([c122 c222]*qdot);

C=[c11 c12;c21 c22];

syms g
gv=[0;0;-g];

P=-simplify(m1*gv.'*o1+m2*gv.'*o2);

gq=[diff(P,q1);diff(P,q2)];


 

