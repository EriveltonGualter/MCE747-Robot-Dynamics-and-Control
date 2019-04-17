
clear all
load('matrix.mat')
clc

D11 = expand(D(1,1), 'ArithmeticOnly', true);

% -------------------------------------------------------------------------
TH1 = I1yy + I2xx + I4yy + I3zz + a^2*m3 + 2*a^2*m4 + d^2*m3 + d^2*m4 + m1*xc1^2 + m3*xc3^2 + m4*xc4^2 + m2*yc2^2 + m3*yc3^2 + m1*zc1^2 + m2*zc2^2 + m4*zc4^2;
% D11 = expand(D11 - TH1, 'ArithmeticOnly', true);
D11 = simplify(D11 - TH1);
D11 = expand(D11, 'ArithmeticOnly', true);
check(D(1,1), D11 + TH1)

% -------------------------------------------------------------------------
% clear QJ; 
syms QJ;
Y2 = 4*a*m4*xc4*cos(q2)*cos(q3)^2*cos(q4)*sin(q2)*sin(q4);
term = subs(D11, Y2, QJ)
diffTerm = diff(term,QJ)

% TH2 = 
D11 = simplify(D11 - TH2);
check(D(1,1), D11 + TH1 + TH2)
 
% cD11 = children(D11).'
 
% -------------------------------------------------------------------------
Y3 = cos(q2)*cos(q3)^2*cos(q4)*sin(q2)*sin(q4);
term = simplify(subs(D11, Y3, QJ));
diffTerm = diff(term,QJ)

children(term).'

TH3 = 0;
D11 = simplify(D11 - TH3);
check(D(1,1), D11 + TH1 + TH2 + TH3)

% cD11 = children(D11);




% children(term).'
% diffterm = diff(term,QJ);
% QI = cos(q2)*cos(q3)*cos(q4)*sin(q2)*sin(q4);
% D11 = subs(D11, cos(q2)*cos(q3)*cos(q4)*sin(q2)*sin(q4), QJ);
% TH2 = 
% D11 = simplify(D11 - TH2);
% check(D(1,1), D11 + TH1 + TH2) 

% -------------------------------------------------------------------------
% Dnew = subs(D11, cos(q2)^2, cq2_2);
% TH3 = diff(subs(D11, cos(q2)^2, cq2_2), cq2_2);
% D11 = D11 - TH3;
% check(D(1,1), D11 + TH1 + TH2 + TH3*cq2_2) 


function out = check(A,B)
    out = simplify(A-B);
end