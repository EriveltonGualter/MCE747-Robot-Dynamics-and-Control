function [Mfcn, Cfcn, Gfcn, Ffcn, Yfcn, Yavfcn, TH] = convertSymVarsTOfunctions(M, C, G, F, TH)

syms TH1 TH2 TH3 TH4 TH5 TH6 TH7 TH8 TH9 TH10
syms TH11 TH12 TH13 TH14 TH15 TH16 TH17 TH18 
syms TH19 TH20 TH21 TH22 TH23 TH24 TH25 TH26 TH27

syms q1 q2 q3 q4
syms q1d q2d q4d
syms q1dd q2dd q4dd
syms v1 v2 v3 
syms a1 a2 a3
                     
THsym = [TH1 TH2 TH3 TH4 TH5 TH6 TH7 TH8 TH9 TH10 TH11 TH12 TH13 TH14 TH15 ...
      TH16 TH17 TH18 TH19 TH20 TH21];

q   = [q1; q2; q4];
qd  = [q1d; q2d; q4d];
qdd = [q1dd; q2dd; q4dd];
aux = M*qdd + C*qd + G;  % From parameterization

for i = 1:3                                   % Number of rows (links)
    for j = 1:length(THsym)                   % Number of parameters
        Y(i,j) = diff(aux(i),THsym(j));
    end
end
Yf = [q1d tanh(2*q1d)  0 0 0 0; 0 0 q2d tanh(2*q2d) 0 0; 0 0 0 0 q4d tanh(2*q4d)];

a123 = [a1; a2; a3];
v123 = [v1; v2; v3];
aux2 = M*a123 + C*v123 + G;  % From parameterization

for i=1:3                               % Number of rows (links)
    for j=1:length(THsym)                  % Number of parameters
        Yav(i,j)=diff(aux2(i),THsym(j));
    end
end

% New Data
% Yf  = [q1d tanh(2*q1d)  0 0 0 0; 0 0 q2d tanh(2*q2d) 0 0; 0 0 0 0 q4d tanh(2*q4d)];
% Yf  = [q1d tanh(q1d)  0 0 0 0; 0 0 q2d tanh(q2d) 0 0; 0 0 0 0 q4d tanh(q4d)];
Y   = [Y Yf];
Yav = [Yav Yf];

% Getting Values of Thetas to Create Dfcn, Cfcn and Gfcn
TH1 = TH(1); 
TH2 = TH(2); 
TH3 = TH(3); 
TH4 = TH(4); 
TH5 = TH(5); 
TH6 = TH(6); 
TH7 = TH(7); 
TH8 = TH(8); 
TH9 = TH(9); 
TH10 = TH(10); 
TH11 = TH(11); 
TH12 = TH(12); 
TH13 = TH(13); 
TH14 = TH(14); 
TH15 = TH(15); 
TH16 = TH(16); 
TH17 = TH(17); 
TH18 = TH(18); 
TH19 = TH(19); 
TH20 = TH(20); 
TH21 = TH(21); 

Mtemp = eval(M);
Ctemp = eval(C);
Gtemp = eval(G);
Ftemp = eval(F);
Yavtemp = eval(Yav);

% Creat Matlab Functions
Mfcn = matlabFunction(Mtemp, 'vars', {q1, q2, q4});
Cfcn = matlabFunction(Ctemp, 'vars', {q1, q2, q4, q1d, q2d, q4d});
Gfcn = matlabFunction(Gtemp, 'vars', {q1, q2, q4});
Ffcn = matlabFunction(Ftemp, 'vars', {q1d, q2d, q4d});
Yfcn = matlabFunction(Y, 'vars', {q1, q2, q4, q1d, q2d, q4d, q1dd, q2dd, q4dd});
Yavfcn = matlabFunction(Yavtemp, 'vars', {q1, q2, q4, q1d, q2d, q4d, q1dd, q2dd, q4dd, ...
                                                v1, v2, v3, a1, a2, a3});
end

