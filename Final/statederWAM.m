function ZDot = statederWAM(Z, tau, Dsym, Csym, Gsym, Bsym)

    % Unpack
    Z1 = Z(1:3);
    Z2 = Z(4:6);
    
    % Solving Terms: Inertia, Coriollis and Gravititinal acceleration 
    D = Dsym(Z1(1),Z1(2),Z1(3));
    C = Csym(Z1(1),Z1(2),Z1(3),Z2(1),Z2(2),Z2(3));
    g = Gsym(Z1(1),Z1(2),Z1(3));
    f = Bsym(Z2(1),Z2(2),Z2(3));
    
    % Derivatives
    Z1d = Z2;
    Z2d = D\(tau - C*Z2 - g - f);

    ZDot = [Z1d; Z2d];    
end