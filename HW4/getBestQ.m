function [Qnew] = getBestQ()

    % Simulation
    m = 0.068;          % Mass of the ball, kg
    k = 6.5308*1e-5;    % Nm^2/A^2
    g = 9.81;           % Acceleration of gravity, m/s^2
    kff = sqrt(2*m*g/k); 

    % Equilibrium Point
    xeq = 6e-3;
    ieq = kff*xeq;

    % Plant
    A = [0 1; 2*g/xeq 0];
    B = [0; -2*g/ieq];
    C = eye(2);
    D = 0;

    % LQR Controller
    K = lqr(A, B, diag([10 1]),1);
    Acl = A-B*K;

    % Lyapunov Function
    Q = eye(2);
    P = dlyap(Acl', Q);

    nonlcon = @(X) nonlconstraints (X, Acl);
    x0 = reshape(Q,4,1);

    options = struct('MaxFunctionEvaluations', 1000, 'MaxIterations', 1000);

    fun = @(X) objFunction (X, Acl);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = [];
    ub = [];
    x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

    Qnew = reshape(x,2,2);


function out = objFunction (X, Acl)
    Q = reshape(X, 2,2);
    P = lyap(Acl', Q);
    out = trace(P);

function [c, ceq] = nonlconstraints (X, Acl)
    c = [];
    Q = reshape(X, 2,2);

    P = lyap(Acl', Q);
    gama1 = sqrt([1 0]*inv(P)*[1 0]');
    gama3 = sqrt([0 1]*inv(P)*[0 1]');

    ceq = X(2)-X(3);
    c = [c; -Q(1,1); -Q(1,1)*Q(2,2)+Q(2,1)*Q(1,2); gama1-1; gama3-1];   


