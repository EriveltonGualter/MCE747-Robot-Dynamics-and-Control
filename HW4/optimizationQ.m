
nonlcon = @(X) nonlconstraints (X, Acl);
x0 = reshape(Q,4,1);

options = struct('MaxFunctionEvaluations', 1000, 'MaxIterations', 1000);

syms x1 x2
fun = @(X) objFunction (X, Acl, x1, x2);
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

Qnew = reshape(x,2,2);
Pnew = lyap(Acl', Qnew);
figure; hold on
rectangle('Position', [-1 -1 2 2]); 
Pnew = inv(Pnew);
E = ellipsoid([0; 0], Pnew); 
plot(E)
axis equal

function out = objFunction (X, Acl, x1, x2)
    Q = reshape(X, 2,2);
    P = lyap(Acl', Q);

    V = 0.5*[x1 x2]*P*[x1; x2];
    vpa(simplify(V), 4)

    V_sym = matlabFunction(V, 'vars', [x1,x2]);

    u = ieq - K*[x1-xeq; x2];
    x1d = x2;
    x2d = (m*g-k.*u^2/2/x1^2)/m;

    Vdot = diff(V,x1)*x1d + diff(V,x2)*x2d;
    Vdot_sym = matlabFunction(Vdot, 'vars', [x1,x2]);
   
    for r = 0:1e-3:.14
        for th = 0:.01:2*pi,
            x1 = r*cos(th)+6e-3;
            x2 = r*sin(th);  %absolute coords
            vdot = Vdot_sym(x1,x2);
            if vdot > 0
                fbreak  = 1;
                break;
            else
                fbreak = 0;
                out = 1/r
%                 P2 = [P2 [x1;x2]];
            end
        end
        if fbreak == 1
            break;
        end
    end
end

function [c, ceq] = nonlconstraints (X, Acl)
    c = [];
    Q = reshape(X, 2,2);

    P = lyap(Acl', Q);
%     gama1 = sqrt([1 0]*inv(P)*[1 0]');
%     gama3 = sqrt([0 1]*inv(P)*[0 1]');
        
    ceq = X(2)-X(3);
    c = [c; -Q(1,1); -Q(1,1)*Q(2,2)+Q(2,1)*Q(1,2)];
%     c = [c; -Q(1,1); -Q(1,1)*Q(2,2)+Q(2,1)*Q(1,2); gama1-1; gama3-1];   
end

