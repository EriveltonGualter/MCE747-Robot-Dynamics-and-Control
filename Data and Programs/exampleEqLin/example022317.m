%Class example 2/23/17


%Find equilibria


u=1;

xsol = fsolve(@(x) systemf(x,u),[1;-1]);

%sol [1;0]

%linearization

clear
syms x1 x2 u

f1=x1^2-u;
f2=x1*x2^2-x2*u;

Df1Dx1=diff(f1,x1);
Df1Dx2=diff(f1,x2);
Df1Du=diff(f1,u);

Df2Dx1=diff(f2,x1);
Df2Dx2=diff(f2,x2);
Df2Du=diff(f2,u);

A=[Df1Dx1 Df1Dx2;Df2Dx1 Df2Dx2];
B=[Df1Du;Df2Du];

%Include equilibrium values
x1=-1;x2=-1;u=1;

A=eval(A)
B=eval(B)

%Define output
C=[1 2]; D=0;
sysSS=ss(A,B,C,D);
%Find transfer function
G=tf(sysSS)

%Design pole placement controller

DP=[-2+i;-2-i];
K=place(A,B,DP);


wn=abs(DP(1));
beta=atan(imag(DP(1))/-real(DP(1)));
zeta=cos(beta);

%From here the transient response can be estimated.





