%cartpend_dyn
%Finds the inertia, Coriolis and gravity matrices 
%for the cart-pendulum system

%Run kinematics
cartpend_kin

syms m1 m2 h g I1x I1y I1z I2x I2y I2z
%We know that the inertias of L1 and 2 inertias of L2 are unnecessary
%(plane rotation). The procedure is general, and irrelevant parameters
%should dissapear by themselves (use for verification)

%Inertia matrices relative to the CMs of each link:
I1=diag([I1x I1y I1z]);
I2=diag([I2x I2y I2z]);

sum=m1*J1v.'*J1v+J1w.'*R1*I1*R1.'*J1w;
sum=sum+m2*J2v.'*J2v+J2w.'*R2*I2*R2.'*J2w;
D=simplify(sum);


%Coriolis/Centripetal Matrix
syms q1dot q2dot
q=[q1;q2];
for i=1:2,
    for j=1:2,
        for k=1:2,
            c(i,j,k)=(1/2)*((diff(D(k,j),q(i)))+(diff(D(k,i),q(j)))-(diff(D(i,j),q(k))));
        end
    end
end

for k=1:2,
    for j=1:2,
        C(k,j)=c(1,j,k)*q1dot+c(2,j,k)*q2dot;
    end
end

%Gravity term

%Potential Energy
gv=[-g;0;0];  %gravity direction in world frame
P=-m1*gv.'*o10-m2*gv.'*o20;

gq1=simplify(diff(P,q1));
gq2=simplify(diff(P,q2));

gq=[gq1;gq2];

%Hinge friction (assume linear)
syms b

Rayleigh=b*q2dot^2/2;

Rdiss1=simplify(diff(Rayleigh,q1dot));
Rdiss2=simplify(diff(Rayleigh,q2dot));

Rdiss=[Rdiss1;Rdiss2];

%Cart track friction (assume Coulomb)
%Use sgn as placeholder for sign(q1dot) function
syms sgn f

Cfric=[f*sgn;0];

%Final model is

%D*qddot+C*qdot+g+Rdiss+Cfric=tau



