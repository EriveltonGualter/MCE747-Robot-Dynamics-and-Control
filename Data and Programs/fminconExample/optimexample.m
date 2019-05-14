syms x a b L

Lg=x;
Lw=sqrt(b^2+(a-x)^2);

J=Lg+L*Lw;

dJdx=diff(J,x);

xopt=solve(dJdx)

d2Jdx2=diff(dJdx);

d2Jdx2=simplify(subs(d2Jdx2,x,xopt))

close all
%Solve for an example
a=2; %km
b=0.5; %km
L=4;

xsol=eval(xopt(2));

%Show cost and solution
x=[0:0.1:2*a];
Lg=x;
Lw=sqrt(b^2+(a-x).^2);
J=Lg+L*Lw;
plot(x,J);hold on
plot(xsol,0,'*'); grid


%Now solve more difficult problem with fmincon
%Price over water increases linearly with length, and x is constrained

%Set prices over land and water
pg=100; %dollars per km
pow=1000; %fixed cost of going over water
sw=5; %price penalty per length over water

%Prepare fmincon solution
%Bounds
LB=0.1; 
UB=0.75*a;

%Guess
x0=a/2;

xsol=fmincon(@(x) cost(x,pg,pow,sw,a,b), x0,[],[],[],[],LB,UB);

%Show solution
x=[0:0.1:2*a];
Lg=x;
Lw=sqrt(b^2+(a-x).^2);
pw=pow+sw*Lw;
J=pg*Lg+pw.*Lw;
figure(2)
plot(x,J);hold on
plot(xsol,0,'*'); grid

function out=cost(x,pg,pow,sw,a,b)

%Calculate lengths

Lg=x;
Lw=sqrt(b^2+(a-x)^2);

%Price over water
pw=pow+sw*Lw;

%Total cost
out=pg*Lg+pw*Lw;
end

