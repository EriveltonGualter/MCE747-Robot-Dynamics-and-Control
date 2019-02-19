% Erivelton Gualter
%
% https://academic.csuohio.edu/richter_h/courses/mce647/mce647_4p5.pdf
% Minupulability

close all

Q = [10 4; 4 2];
P = Q^(-1/2);
[U,S,V] = svd(P)

syms w1 w2

X = U*[w1;w2]

vpa(simplify(X.'*Q*X),2)

hold on; box on;
E = ellipsoid(inv(Q));
plot(E)
plot([0 U(1,1)*S(1,1)], [0 U(2,1)*S(1,1)], 'k')
plot([0 U(1,2)*S(2,2)], [0 U(2,2)*S(2,2)], 'k')

axis equal