function xDer = maglevDer(X, u, param)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    % Extract parameters
    m = param(1);
    k = param(2);
    g = param(3);
    
    x1 = X(1);
    x2 = X(2);
    
    x1D = x2;
    x2D = (m*g-k*u^2/2/x1^2)/m;

    xDer = [x1D; x2D];
end

