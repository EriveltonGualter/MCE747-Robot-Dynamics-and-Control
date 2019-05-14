%Constrained optimization example 2:

%Minimize the sum of the areas under two functions q1(t) and q(2) in [0 1]
%Functions parameterized as Fourier expansions 
%q1=a01+a11*sin(w*t)+b12*cos(w*t);
%q2=a02+a12*sin(w*t)+b22*cos(w*t);

%Optimize over coefficients a01, a11, b12, a02, a12, b22
%w is given


%Constraints:
%Equality: q1(0)=0=q2(0) and q1(1)=1=q2(1) (Handled with Aeq*X=Beq)

%Inequality (handled with nonlinear constraint function)

%q1(t)>=0 and q2(t)>=0 for all t in [0 1]

%Define Y(t(i))=[q1(t(i)) q1dot(t(i))+q2dot(t(i));q2dot(i)^2 sin(q1(t(i)))*q2(t(i))];

%The sum of the traces of Y(t(i)) for t in [0 1] must be smaller than a
%given value


clc;clear;close all

w=2;

%Set up initial guess
X0=rand(6,1);

%Set up interval for minimum detection
delta=0.01;

%Set up linear equality constraint matrices
Aeq=[1 0 1 0 0 0;0 0 0 1 0 1;1 sin(w) cos(w) 0 0 0;0 0 0 1 sin(w) cos(w)];
Beq=[0;0;1;1];


options = optimoptions('fmincon','Display','iter','MaxFunctionEvaluations',100000,'OptimalityTolerance',1e-11,'StepTolerance',1e-11,'MaxIterations',10000);

Xsol=fmincon(@(X) obj(X,w), X0, [],[], Aeq, Beq, [],[], @(X) nonlconstr(X,w,delta),options);

%Plot results
t=[0:delta:1];
a01=Xsol(1); a11=Xsol(2); b12=Xsol(3);
a02=Xsol(4); a12=Xsol(5); b22=Xsol(4);

q1=a01+a11*sin(w*t)+b12*cos(w*t);
q2=a02+a12*sin(w*t)+b22*cos(w*t);

q1dot=a11*w*cos(w*t)-b12*w*sin(w*t);
q2dot=a12*w*cos(w*t)-b22*w*sin(w*t);

%Report sum of traces
sumtr=0;
for i=1:length(q1)
    Y=[q1(i) q1dot(i)+q2dot(i);q2dot(i)^2 sin(q1(i))*q2(i)];
    sumtr=sumtr+trace(Y);
end

sumtr

plot(t,q1,t,q2);legend('q_1','q_2')
xlabel('t');ylabel('q_1 and q_2')


function out=obj(X,w)

a01=X(1); a11=X(2); b12=X(3);
a02=X(4); a12=X(5); b22=X(4);

%From separate symbolic computation:
Area1=a01 + (a11 - a11*cos(w) + b12*sin(w))/w;
Area2=a02 + (a12 - a12*cos(w) + b22*sin(w))/w;

out=Area1+Area2;

end

function [c, ceq]=nonlconstr(X,w,delta)
%Find the minimum of the functions in [0 1] with spacing delta

a01=X(1); a11=X(2); b12=X(3);
a02=X(4); a12=X(5); b22=X(4);

c=[];
ceq=[];

t=[0:delta:1];
q1=a01+a11*sin(w*t)+b12*cos(w*t);
q2=a02+a12*sin(w*t)+b22*cos(w*t);

q1dot=a11*w*cos(w*t)-b12*w*sin(w*t);
q2dot=a12*w*cos(w*t)-b22*w*sin(w*t);

q1min=min(q1);
q2min=min(q2);

%constraints pass when c<0, ceq=0
c=[c;-q1min;-q2min];

%Constraint: the sum of the traces of all instances of Y must be
%less than maxtr

maxtr=100;
sumtr=0;
for i=1:length(q1)
    Y=[q1(i) q1dot(i)+q2dot(i);q2dot(i)^2 sin(q1(i))*q2(i)];
    sumtr=sumtr+trace(Y);
end
c=[c; sumtr-maxtr];

end