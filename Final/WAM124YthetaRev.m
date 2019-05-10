%Minimal Parameterization of WAM robot with J3 frozen at q3=0

%Developed by John Schultz, MCE647/747 Spring 2019 - CSU
%Version 2 with corrected mistake in regressor.

load Xopt.mat
THF = X(end-5:end);

clearvars -except THF

syms TH1 TH2 TH3 TH4 TH5 TH6 TH7 TH8 TH9 TH10
syms TH11 TH12 TH13 TH14 TH15 TH16 TH17 TH18 
syms TH19 TH20 TH21

syms q1 q2 q3 q4
syms q1d q2d q4d

%M, C and G in parameter form:

M = [ TH1 + TH2*cos(2*q2 + 2*q4) + TH3*sin(2*q2 + 2*q4) + TH8*cos(q4) + TH9*sin(q4) + TH6*cos(2*q2 + q4) + TH7*sin(2*q2 + q4) + TH4*cos(2*q2) + TH5*sin(2*q2), TH10*cos(q2 + q4) + TH11*sin(q2 + q4) + TH12*cos(q2) + TH13*sin(q2), TH10*cos(q2 + q4) + TH11*sin(q2 + q4);
                                                                                     TH10*cos(q2 + q4) + TH11*sin(q2 + q4) + TH12*cos(q2) + TH13*sin(q2),                                  TH14 + TH16*cos(q4) + TH15*sin(q4),      TH17 + TH8*cos(q4) + TH9*sin(q4);
                                                                                                                   TH10*cos(q2 + q4) + TH11*sin(q2 + q4),                                    TH17 + TH8*cos(q4) + TH9*sin(q4),                                  TH17];
                                                                                                               
C = [q4d*(TH3*cos(2*q2 + 2*q4) - TH2*sin(2*q2 + 2*q4) + (TH9*cos(q4))/2 - (TH8*sin(q4))/2 + (TH7*cos(2*q2 + q4))/2 - (TH6*sin(2*q2 + q4))/2) + q2d*(TH3*cos(2*q2 + 2*q4) - TH2*sin(2*q2 + 2*q4) + TH7*cos(2*q2 + q4) - TH6*sin(2*q2 + q4) + TH5*cos(2*q2) - TH4*sin(2*q2)), q2d*(TH11*cos(q2 + q4) - TH10*sin(q2 + q4) + TH13*cos(q2) - TH12*sin(q2)) + q1d*(TH3*cos(2*q2 + 2*q4) - TH2*sin(2*q2 + 2*q4) + TH7*cos(2*q2 + q4) - TH6*sin(2*q2 + q4) + TH5*cos(2*q2) - TH4*sin(2*q2)) + q4d*(TH11*cos(q2 + q4) - TH10*sin(q2 + q4)), q1d*(TH3*cos(2*q2 + 2*q4) - TH2*sin(2*q2 + 2*q4) + (TH9*cos(q4))/2 - (TH8*sin(q4))/2 + (TH7*cos(2*q2 + q4))/2 - (TH6*sin(2*q2 + q4))/2) + q2d*(TH11*cos(q2 + q4) - TH10*sin(q2 + q4)) + q4d*(TH11*cos(q2 + q4) - TH10*sin(q2 + q4));
                                                                                                                                          -q1d*(TH3*cos(2*q2 + 2*q4) - TH2*sin(2*q2 + 2*q4) + TH7*cos(2*q2 + q4) - TH6*sin(2*q2 + q4) + TH5*cos(2*q2) - TH4*sin(2*q2)),                                                                                                                                                                                                             q4d*((TH15*cos(q4))/2 - (TH16*sin(q4))/2),                                                                                                                                                         q4d*(TH9*cos(q4) - TH8*sin(q4)) + q2d*((TH15*cos(q4))/2 - (TH16*sin(q4))/2);
                                                                                                                              -q1d*(TH3*cos(2*q2 + 2*q4) - TH2*sin(2*q2 + 2*q4) + (TH9*cos(q4))/2 - (TH8*sin(q4))/2 + (TH7*cos(2*q2 + q4))/2 - (TH6*sin(2*q2 + q4))/2),                                                                                                                                                                                                            -q2d*((TH15*cos(q4))/2 - (TH16*sin(q4))/2),                                                                                                                                                                                                                                   0];
G = [ 0;
 TH18*cos(q2 + q4) + TH19*sin(q2 + q4) + TH20*cos(q2) + TH21*sin(q2);
                               TH18*cos(q2 + q4) + TH19*sin(q2 + q4)];                                                                                                                   
                                                                                                         
 
%Parameter definitions
syms a d
syms xc1 yc1 zc1 xc2 zc2 yc2 xc3 yc3 zc3 xc4 yc4 zc4
syms I1xx I1xy I1xz I1yy I1yz I1zz
syms I2xx I2xy I2xz I2yy I2yz I2zz
syms I3xx I3xy I3xz I3yy I3yz I3zz
syms I4xx I4xy I4xz I4yy I4yz I4zz
syms xc1 yc1 zc1 xc2 zc2 yc2 xc3 yc3 zc3 xc4 yc4 zc4
syms m1 m2 m3 m4
syms g

TH = [I2xx/2 + I3xx/2 + I4xx/2 + I1yy + I3yy/2 + I2zz/2 + I4zz/2 + (a^2*m3)/2 + a^2*m4 + (d^2*m3)/2 + (d^2*m4)/2 + m1*xc1^2 + (m2*xc2^2)/2 + (m3*xc3^2)/2 + (m4*xc4^2)/2 + m2*yc2^2 + (m3*yc3^2)/2 + m4*yc4^2 + m1*zc1^2 + (m2*zc2^2)/2 + m3*zc3^2 + (m4*zc4^2)/2 + a*m3*xc3 - a*m4*xc4 - d*m3*yc3;
                                                                                                                                                                                                                        (m4*a^2)/2 - m4*a*xc4 + (m4*xc4^2)/2 - I4xx/2 + I4zz/2 - (m4*zc4^2)/2;
                                                                                                                                                                                                                                                                 m4*xc4*zc4 - a*m4*zc4 - I4xz;
                                                                                                                      I3yy/2 - I3xx/2 - I2xx/2 + I2zz/2 + (a^2*m3)/2 + (a^2*m4)/2 - (d^2*m3)/2 - (d^2*m4)/2 + (m2*xc2^2)/2 + (m3*xc3^2)/2 - (m3*yc3^2)/2 - (m2*zc2^2)/2 + a*m3*xc3 + d*m3*yc3;
                                                                                                                                                                                                                I3xy - I2xz + a*d*m3 + a*d*m4 - a*m3*yc3 + d*m3*xc3 - m3*xc3*yc3 + m2*xc2*zc2;
                                                                                                                                                                                                                                                                    -m4*(a^2 - xc4*a + d*zc4);
                                                                                                                                                                                                                                                                     m4*(a*zc4 - a*d + d*xc4);
                                                                                                                                                                                                                                                                   m4*(- a^2 + xc4*a + d*zc4);
                                                                                                                                                                                                                                                                     m4*(a*d + a*zc4 - d*xc4);
                                                                                                                                                                                                                                                                            I4yz - m4*yc4*zc4;
                                                                                                                                                                                                                                                                 m4*xc4*yc4 - a*m4*yc4 - I4xy;
                                                                                                                                                                                                                                  I2yz - I3yz - d*m4*yc4 - d*m3*zc3 - m2*yc2*zc2 + m3*yc3*zc3;
                                                                                                                                                                                                                                  a*m4*yc4 - I3xz - I2xy + a*m3*zc3 + m2*xc2*yc2 + m3*xc3*zc3;
                                                                                                                            I2yy + I4yy + I3zz + a^2*m3 + 2*a^2*m4 + d^2*m3 + d^2*m4 + m2*xc2^2 + m3*xc3^2 + m4*xc4^2 + m3*yc3^2 + m2*zc2^2 + m4*zc4^2 + 2*a*m3*xc3 - 2*a*m4*xc4 - 2*d*m3*yc3;
                                                                                                                                                                                                                                                           2*a*d*m4 + 2*a*m4*zc4 - 2*d*m4*xc4;
                                                                                                                                                                                                                                                                 2*m4*(- a^2 + xc4*a + d*zc4);
                                                                                                                                                                                                                                             m4*a^2 - 2*m4*a*xc4 + m4*xc4^2 + m4*zc4^2 + I4yy;
                                                                                                                                                                                                                                                                              -g*m4*(a - xc4);
                                                                                                                                                                                                                                                                                     g*m4*zc4;
                                                                                                                                                                                                                                                            g*(a*m3 + a*m4 + m2*xc2 + m3*xc3);
                                                                                                                                                                                                                                                            g*(d*m3 + d*m4 - m3*yc3 + m2*zc2)];
%%%End of TH listing  %%%%%

%Modify inertial parameters of diagonal elements of the mass matrix to include reflected inertias
%of the drives - See WAM documentation for values

syms Jdrive1 Jdrive2 Jdrive4
TH(1)=TH(1)+Jdrive1;
TH(14)=TH(14)+Jdrive2;
TH(17)=TH(17)+Jdrive4;

%Regressor  - 21 columns

syms q1dd q2dd q4dd

Y = [q1dd, q1dd*cos(2*q2 + 2*q4) - 2*q1d*q2d*sin(2*q2 + 2*q4) - 2*q1d*q4d*sin(2*q2 + 2*q4), q1dd*sin(2*q2 + 2*q4) + 2*q1d*q2d*cos(2*q2 + 2*q4) + 2*q1d*q4d*cos(2*q2 + 2*q4), q1dd*cos(2*q2) - 2*q1d*q2d*sin(2*q2), q1dd*sin(2*q2) + 2*q1d*q2d*cos(2*q2), q1dd*cos(2*q2 + q4) - 2*q1d*q2d*sin(2*q2 + q4) - q1d*q4d*sin(2*q2 + q4), q1dd*sin(2*q2 + q4) + 2*q1d*q2d*cos(2*q2 + q4) + q1d*q4d*cos(2*q2 + q4),   q1dd*cos(q4) - q1d*q4d*sin(q4),   q1dd*sin(q4) + q1d*q4d*cos(q4), - sin(q2 + q4)*q2d^2 - 2*sin(q2 + q4)*q2d*q4d - sin(q2 + q4)*q4d^2 + q2dd*cos(q2 + q4) + q4dd*cos(q2 + q4), cos(q2 + q4)*q2d^2 + 2*cos(q2 + q4)*q2d*q4d + cos(q2 + q4)*q4d^2 + q2dd*sin(q2 + q4) + q4dd*sin(q2 + q4), - sin(q2)*q2d^2 + q2dd*cos(q2), cos(q2)*q2d^2 + q2dd*sin(q2),    0,                              0,                              0,           0,            0,            0,       0,       0;
    0,                                                          q1d^2*sin(2*q2 + 2*q4),                                                         -q1d^2*cos(2*q2 + 2*q4),                      q1d^2*sin(2*q2),                     -q1d^2*cos(2*q2),                                                    q1d^2*sin(2*q2 + q4),                                                   -q1d^2*cos(2*q2 + q4),   - sin(q4)*q4d^2 + q4dd*cos(q4),     cos(q4)*q4d^2 + q4dd*sin(q4),                                                                                          q1dd*cos(q2 + q4),                                                                                        q1dd*sin(q2 + q4),                   q1dd*cos(q2),                 q1dd*sin(q2), q2dd, q2dd*sin(q4) + q2d*q4d*cos(q4), q2dd*cos(q4) - q2d*q4d*sin(q4),        q4dd, cos(q2 + q4), sin(q2 + q4), cos(q2), sin(q2);
    0,                                                          q1d^2*sin(2*q2 + 2*q4),                                                         -q1d^2*cos(2*q2 + 2*q4),                                    0,                                    0,                                                (q1d^2*sin(2*q2 + q4))/2,                                               -(q1d^2*cos(2*q2 + q4))/2, (sin(q4)*q1d^2)/2 + q2dd*cos(q4), q2dd*sin(q4) - (q1d^2*cos(q4))/2,                                                                                          q1dd*cos(q2 + q4),                                                                                        q1dd*sin(q2 + q4),                              0,                            0,    0,             -(q2d^2*cos(q4))/2,              (q2d^2*sin(q4))/2, q2dd + q4dd, cos(q2 + q4), sin(q2 + q4),       0,       0];
 

%End of regressor listing

%Numerical values of basic parameters:
%NOTES (H RICHTER)

%1. The inertia tensors have been updated, we use the "L" listings from
%Barrett's documentation (at the CM, aligned with the local frame)

%2. The drive reflected inertias must be added to the diagonal elements of
%the mass matrix. 

%3. The regressor and parameter vector must be extended to include friction
% effects, as indicated in class.

cm11 = [-0.00443422;0.12189039;-0.00066489;1];
cm22 = [-0.00236983;0.03105614;0.01542114;1];
cm33 = [-0.03825858;0.20750770;0.00003309;1];
cm44 = [0.01095471;-0.00002567;0.14053900;1];

g = 9.81;

% Local CM coordinates

xc1 = -0.00443422;
yc1 = 0.12189039;
zc1 = -0.00066489;
xc2 = -0.00236983;
yc2 = 0.03105614;
zc2 = 0.01542114;
xc3 = -0.03825858;
yc3 = 0.20750770;
zc3 = 0.00003309;
xc4 = 0.01095471;
yc4 = -0.00002567;
zc4 = 0.14053900;

%Moments of inertia taken at the CG, aligned with local frame
I1xx=0.13488033; I1xy = -0.00213041; I1xz = -0.00012485;
I1yx = -0.00213041; I1yy = 0.11328369; I1yz = 0.00068555;
I1zx = -0.00012485; I1zy = 0.00068555; I1zz = 0.09046330;

I2xx = 0.02140958 ;I2xy = 0.00027172 ;I2xz = 0.00002461;
I2yx = 0.00027172 ;I2yy = 0.01377875 ;I2yz = -0.00181920;
I2zx = 0.00002461 ;I2zy = -0.00181920 ;I2zz = 0.01558906;


I3xx = 0.05911077 ;I3xy = -0.00249612 ;I3xz = 0.00000738;
I3yx = -0.00249612 ;I3yy = 0.00324550 ;I3yz = -0.00001767;
I3zx = 0.00000738 ;I3zy = -0.00001767 ;I3zz = 0.05927043;

I4xx = 0.00093220 ;I4xy = 0.00000258 ;I4xz = -0.00031408;
I4yx = 0.00000258 ;I4yy = 0.00120070 ;I4yz = 0.00000227;
I4zx = -0.00031408 ;I4zy = 0.00000227 ;I4zz = 0.00084605;

% Link masses

m1 = 10.76768767;
m2 = 3.87493756;
m3 = 1.80228141;
m4 = 1.06513649; % elbow+blank link

% Other kinematic parameters

a = 0.045;
d = 0.55;

%Reflected drive inertias in kg-m^2
Jdrive1=0.205190;
Jdrive2=0.094428;
Jdrive4=0.094428;


%Extend parameters to include friction

TH=[TH;THF];
TH=eval(TH);
