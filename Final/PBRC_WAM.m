function u = PBRC_WAM(Z, Zd, Yabfcn, TH0, rho, eps, Lambda, K)

    % Unpack
    % Current States
    Z1 = Z(1:3);    % q1, q2, q3
    Z2 = Z(4:6);    % q1dot, q2dot, q3dot 
    
    % Desired States
    Z1d = Zd(1:3:end);  % q1d, q2d, q3d
    Z2d = Zd(2:3:end);  % q1dotd, q2dotd, q3dotd 
    Z3d = Zd(3:3:end);

    % Error
    deltaZ = Z1-Z1d;    % q - qd
    deltaZdot = Z2-Z2d; % qdot - qdotd
%     Q = [Lambda.'*K*Lambda zeros(3); zeros(3) K]

    % Gain
%     Lambda = 1*eye(3);
%     K = 1*eye(3);
    
    % Passivity-Based Motion Control
    v = Z2d - Lambda*deltaZ;
    a = Z3d - Lambda*deltaZdot;
    r = deltaZdot + Lambda*deltaZ;
       
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
    V = {v(1) v(2) v(3)};
    A = {a(1) a(2) a(3)};
       
    Y = Yabfcn(Q{:}, Qdot{:}, Qddot{:}, V{:}, A{:});
    s = Y'*r; 
    
    if norm(s) > eps
        dTH = -rho*s/norm(s);
    else
%         dTH = -rho*s/eps;
        dTH = 0;
    end
    
    Y = Yabfcn(Q{:}, Qdot{:}, Qddot{:}, V{:}, A{:});
    u = Y*(TH0+dTH) - K*r;
end