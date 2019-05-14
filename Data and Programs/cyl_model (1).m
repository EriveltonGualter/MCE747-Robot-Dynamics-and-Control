

syms q1 q2 q3 l1 l2 c1 c2 
syms g I1x I2x I3x I1y I2y I3y I1z I2z I3z
syms m1 m2 m3 
syms q1dot q2dot q3dot 
%Set up coordinate transformations

%From world to frame 1:
%(Rot z,q1)(Trans x,l1)
T10=Rotz(q1)*Transx(l1);

%From frame 1 to frame 2: 
%(Rot z,q2)(Trans x,l2)
T21=Rotz(q2)*Transx(l2);

%From frame 2 to frame 3: 
T32=Transz(q3);

T20=T10*T21;
T30=T20*T32;

%Find the Jacobians to the centers of mass:
%Link 1:
z0=[0;0;1];
CM1=T10*[c1-l1;0;0;1];CM1=CM1(1:3);
J1v1=cross(z0,CM1);
J1v2=[0;0;0]; 
J1v3=[0;0;0]; %the velocity a link is independent from higher links
J1v=[J1v1 J1v2 J1v3];

J1w=[0 0 0;0 0 0;1 0 0];

%Link 2:
o10=T10*[0;0;0;1];o10=o10(1:3);
CM2=T20*[c2-l2;0;0;1];CM2=CM2(1:3);
z1=z0;
J2v1=cross(z0,CM2);
J2v2=cross(z1,CM2-o10);
J2v3=[0;0;0]; %the velocity a link is independent from higher links
J2v=[J2v1 J2v2 J2v3];

J2w=[0 0 0;0 0 0;1 1 0];


%Link 3:
CM3=T30*[0;0;0;1];CM3=CM3(1:3);
z2=z0;
J3v1=cross(z0,CM3);
J3v2=cross(z1,CM3-o10);
J3v3=z2;
J3v=[J3v1 J3v2 J3v3];

J3w=[0 0 0;0 0 0;1 1 0];



%Inertia Matrix
I1=diag([I1x I1y I1z]);
I2=diag([I2x I2y I2z]);
I3=diag([I3x I3y I3z]);


R1=T10(1:3,1:3);
R2=T20(1:3,1:3);
R3=T30(1:3,1:3);

sum= J1w.'*R1*I1*R1.'*J1w+ m1*J1v.'*J1v;
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

%The above has been checked to satisfy the skew-symmetry property for
%Ddot-2C

%Potential Energy
gv=[0;0;-g];  %gravity direction in world frame
P=-m1*gv.'*CM1-m2*gv.'*CM2-m3*gv.'*CM3;

gq1=simplify(diff(P,q1));
gq2=simplify(diff(P,q2));
gq3=simplify(diff(P,q3));

gq=[gq1;gq2;gq3];

