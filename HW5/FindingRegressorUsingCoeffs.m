% Erivelton 

clear all
close all
clc

%% Coefficients of Univariate Polynomial
syms x
F1 = 16*x^2 + 19*x + 11
c = coeffs(F1)
fliplr(c)

%% Coefficients of Multivariate Polynomial with Respect to Particular Variable
syms x y
F2 = x^3 + 2*x^2*y + 3*x*y^2 + 4*y^3
cx = coeffs(F2, x)
cy = coeffs(F2, y)

%% Coefficients of Multivariate Polynomial with Respect to Two Variables
syms x y
F3 = x^3 + 2*x^2*y + 3*x*y^2 + 4*y^3
cxy = coeffs(F3, [x y])
cyx = coeffs(F3, [y x])

%% Coefficients and Corresponding Terms of Multivariate Polynomial
syms x y
F = x^3 + 2*x^2*y + 3*x*y^2 + 4*y^3
[cx,tx] = coeffs(F, x)
[cy,ty] = coeffs(F, y)