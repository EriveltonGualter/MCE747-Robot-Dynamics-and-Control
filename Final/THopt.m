%New friction regressor

%Yf=[q1d tanh(2*q1d)  0 0 0 0; 0 0 q2d tanh(2*q2d) 0 0; 0 0 0 0 q4d tanh(2*q4d)];

%with parameters TH22 thru TH27 


%A direct optimization was run to obtain estimates of the individual
%parameters so that the residual Y*Theta-U was minimal.


%The optimized parameters are in vector X

% Known parameters
a = 0.045;
d = 0.55;
g = 9.81;

load Xopt.mat

xc1=X(1);yc1=X(2); zc1=X(3); xc2=X(4); zc2=X(5); yc2=X(6); xc3=X(7); yc3=X(8); zc3=X(9); xc4=X(10); yc4=X(11); zc4=X(12);
I1xx=X(13); I1xy=X(14); I1xz=X(15); I1yy=X(16); I1yz=X(17); I1zz=X(18);
I2xx=X(19); I2xy=X(20); I2xz=X(21); I2yy=X(22); I2yz=X(23); I2zz=X(24);
I3xx=X(25); I3xy=X(26); I3xz=X(27); I3yy=X(28); I3yz=X(29); I3zz=X(30);
I4xx=X(31); I4xy=X(32); I4xz=X(33); I4yy=X(34); I4yz=X(35); I4zz=X(36);
m1=X(37); m2=X(38); m3=X(39); m4=X(40);

%X(41) thru X(44) represent friction

%Build TH estimate
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

%Append friction parameters
TH=[TH;X(41:46)];


