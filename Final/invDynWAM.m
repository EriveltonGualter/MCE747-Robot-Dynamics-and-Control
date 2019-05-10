function u = invDynWAM(Z, Zd, Yfcn, TH)

    % Unpack
    % Current States
    Z1 = Z(1:3);    % q1, q2, q3
    Z2 = Z(4:6);    % q1dot, q2dot, q3dot 
    
    % Desired States
    Z1d = Zd(1:3:end);  % q1d, q2d, q3d
    Z2d = Zd(2:3:end);  % q1dotd, q2dotd, q3dotd 
    Z3d = Zd(3:3:end);

    % Error
    deltaZ = Z1-Z1d;       % q - qd
    deltaZdot = Z2-Z2d;    % qdot - qdotd
    
    % Gains
    w = 4;
    K0 = w^2*eye(3);
    K1 = 2*w*eye(3);
    
    % Virtual acceleration
    a = Z3d - K0*deltaZ - K1*deltaZdot;
    
    % Unpacking Inputs for regressor: Y(...)
    q1 = Z1(1);
    q2 = Z1(2);
    q4 = Z1(3);
    q1d = Z2(1);
    q2d = Z2(2);
    q4d = Z2(3);
    q1dd = a(1);
    q2dd = a(2);
    q4dd = a(3);
    
    Q = {q1 q2 q4};
    Qdot = {q1d q2d q4d};
    Qddot = {q1dd q2dd q4dd};
    Y = Yfcn(Q{:}, Qdot{:}, Qddot{:});
    u = Y*TH;
end