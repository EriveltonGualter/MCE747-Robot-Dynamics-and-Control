clear all
close all
clc

syms m1 m2 l1 lc1 lc2 I1 I2
syms Q2

Qarr = Q2;

D(1,1) = m1*lc1^2 + m2*(l1^2+lc2^2+2*l1*lc2*cos(Q2)) + I1 + I2;
D(1,2) = m2*(lc2^2+l1*lc2*cos(Q2)) + I2;
D(2,1) = D(1,2);
D(2,2) = m2*lc2^2 + I2;

% D = expand(D);
F = D;

% Expand Matrix
% F = expand(F);

% Find children
N = length(F);
k = 1;
for i=1:N
    for j=1:N
        cftemp = children(F(i,j));
        CF(k,1:length(cftemp)) = children(F(i,j));
        k = k+1;
    end
end

% Get Theta
[M,N] = size(CF);
k = 1;
for idx=0:length(Qarr)
    if ~idx
        CFA = CF;
        CFB = CFA;
        TH(1) = CFA(1,1);
    else
        CFA = diff(CF, Qarr(idx));
        CFB = diff(CF, Qarr(idx));
    end
    for i=1:M
        for j=1:N
            for I=1:M
                for J=1:N
                    % Test:
                    %   CF == Ftemp 
                    %   CF ~= 0 
                    %   CF ~= Any number
                    
                    if ((isequal(CFA(i,j), CFB(I,J))) && CFA(i,j) ~= 0 && hasQ(CFB(I,J),Qarr) == 0 && ~isUnit(CFA(i,j)))
                        if ~(isequal(TH(k),CFB(I,J)))
                            k = k +1;
                            TH(k) = CFA(i,j);
                        end                    
                        CFB(I,J) = sym(0);
                    end

                end
            end
        end
    end
%     CFA
%     CFB
end
CF
TH

%                     || isequal(CF(i,j), diff(CFtemp(I,J),Q1))
%                     && diff(CFtemp(I,J),Q1)
%                     diffCQn(CF(i,j),Qarr);
%                     hasQ(CFtemp(I,J),Qarr)
                    
function out = hasQ(C,Qn)
    out = sym(0);
    for i=1:length(Qn)
        out = out + has(C,Qn(i));
    end
end

function out = diffCQn(C,Qn)
    out = sym(0);
    for i=1:length(Qn)
        out = out + diff(C,Qn(i));
    end
end

% for i=1:M
%     for j=i:N
%         CF(i,j)
%     end
% end