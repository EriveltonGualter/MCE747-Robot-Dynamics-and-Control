clear all
close all

syms TH1 TH2 TH3 TH4 TH5 sgn  g q1 q2 q1dot q2dot

D(1,1)=TH1;
D(1,2)=-TH2*sin(q2);
D(2,1)=D(1,2);
D(2,2)=TH3;

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

gq=[0;g*TH2*cos(q2)];
Rdiss=[0;TH4*q2dot];
Cfric=[TH5*sgn;0];

%Extract regressor
syms q1ddot q2ddot
aux=D*[q1ddot;q2ddot]+C*[q1dot;q2dot]+gq+Rdiss+Cfric;  %from parameterization
TH=[TH1 TH2 TH3 TH4 TH5].';

for i=1:2, %number of rows (links)
    for j=1:5, %number of parameters
        Y(i,j)=diff(aux(i),TH(j));
    end
end


%Verification
%Define parameters
syms m1 m2 h b I2z f
TH1=m1+m2;
TH2=m2*h;
TH3=m2*h^2+I2z;
TH4=b;
TH5=f;

aux1=Y*[TH1;TH2;TH3;TH4;TH5];

cartpend_dyn

aux2=D*[q1ddot;q2ddot]+C*[q1dot;q2dot]+Rdiss+gq+Cfric;

simplify(eval(aux1-aux2))


