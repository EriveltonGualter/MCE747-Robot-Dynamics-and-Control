if ~exist('Yfcn', 'var')
    [M, C, G, F, TH, ~] = getWAMParameters();
    [~, ~, ~, ~, Yfcn, ~, TH] = convertSymVarsTOfunctions(M, C, G, F, TH);
    [Ve, Vp] = getVeVp();
    
    syms q1 q2 q3 q4 q1dot q2dot q3dot q4dot;
    q3 = 0;
    q3dot = 0;
    Ve = eval(Ve);
    Vp = eval(Vp);

    VeFcn = matlabFunction(Ve, 'vars', [q1 q2 q4 q1dot q2dot q4dot]);
    VpFcn = matlabFunction(Vp, 'vars', [q1 q2 q4 q1dot q2dot q4dot]);
end
          
t = 0:.1:10;
w = 2*pi/10;

a = rand(12,1);
b = rand(12,1);

lambd1 = 1; 
lambd2 = 10;

FUN = @(X) (objFunction(X, w, lambd1, lambd2, t, Yfcn));
NONLCON = @(X) (nonLinearQ(X, w, t, VeFcn, VpFcn));
OPTIONS = optimoptions('fmincon','Display','iter','MaxFunctionEvaluations',10000, ...
    'OptimalityTolerance',1e-11,'StepTolerance',1e-11,'MaxIterations',10000*10);


EXITFLAG = -1;
while EXITFLAG < 0
    r0 = -.2;
    r1 = .2;
    X0 = [a; b]; 
    [X,FVAL,EXITFLAG,OUTPUT] = fmincon(FUN,X0,[],[],[],[],[],[],NONLCON,OPTIONS);
    a = (r1-r0)*rand(12,1) +r0;
    b = (r1-r0)*rand(12,1) +r0;
end

[q, qd, qdd, Tau] = plotOptTraj(X, w, t, VeFcn, VpFcn, Yfcn, TH, 1);

% Object Function
function cost = objFunction(X, w, lambd1, lambd2, t, Yfcn)
    % Unpack
    A = X( 1:12);
    B = X(13:24);
    
    a = reshape(A,4,3);
    b = reshape(B,4,3);
    q = zeros(length(t), 3);
    qd = zeros(length(t), 3);
    qdd = zeros(length(t), 3);
    
    condSum = 0;
    svdSum = 0;
    
    for k=1:length(t)
    for i=1:3
        for j=1:4
            aji = a(j,i);
            bji = b(j,i);
            tk = t(k);
            wj = w*j;
            
            q(k, i)     = q(k, i)   + aji*sin(wj*tk)/wj      - bji*cos(wj*tk)/wj;
            qd(k, i)    = qd(k, i)  + aji*wj*cos(wj*tk)/wj   + bji*wj*sin(wj*tk)/wj;
            qdd(k, i)   = qdd(k, i) - aji*wj^2*sin(wj*tk)/wj + bji*wj^2*cos(wj*tk)/wj;
          
            Q = {q(k, 1) q(k, 1) q(k, 1)};
            Qd = {qd(k, 1) qd(k, 2) qd(k, 3)};
            Qdd = {qdd(k, 1) qdd(k, 2) qdd(k, 3)};
        end
    end
    Ytemp = Yfcn(Q{:}, Qd{:}, Qdd{:});
    condSum = condSum + cond(Ytemp);
    svdTemp = svd(Ytemp);
    svdSum = svdSum + svdTemp(3);
    end

    N = length(t);
    cost = lambd1*condSum/N + lambd2*N/(svdSum)*10;
end

% Nonlinar Function
function  [c,ceq] = nonLinearQ(X, w, t, VeFcn, VpFcn)
    ceq = 0;
    c = [];
    
    % Unpack
    A = X( 1:12);
    B = X(13:24);
    
    a = reshape(A,4,3);
    b = reshape(A,4,3);
    q = zeros(length(t), 3);
    qd = zeros(length(t), 3);
    qdd = zeros(length(t), 3);
        
    for k=1:length(t)
    for i=1:3
        for j=1:4
            aji = a(j,i);
            bji = b(j,i);
            tk = t(k);
            wj = w*j;
            
            q(k, i) = q(k, i) + aji*sin(wj*tk)/wj - bji*cos(wj*tk)/wj;
            qd(k, i) = qd(k, i) + aji*wj*cos(wj*tk)/wj + bji*wj*sin(wj*tk)/wj;
            qdd(k, i) = qdd(k, i) - aji*wj^2*sin(wj*tk)/wj + bji*wj^2*cos(wj*tk)/wj;
          
            Q = {q(k, 1) q(k, 1) q(k, 1)};
            Qd = {qd(k, 1) qd(k, 2) qd(k, 3)};
            Qdd = {qdd(k, 1) qdd(k, 2) qdd(k, 3)};
        end
    end
    Ve(:,k) = VeFcn(Q{:}, Qd{:});
    Vp(:,k) = VpFcn(Q{:}, Qd{:});
    end
    
    Q1 = abs(q(:,1)) ;
    Q2 = abs(q(:,2)) ;
    Q4 = q(:,3);
    Q1d = abs(qd(:,1)) ;
    Q2d = abs(qd(:,2)) ;
    Q3d = abs(qd(:,3)) ;
            
     
    VE = sqrt(Ve(1,:).^2+Ve(2,:).^2+Ve(3,:).^2).';
    VP = sqrt(Vp(1,:).^2+Vp(2,:).^2+Vp(3,:).^2).';
     
    csum = [sum(find(Q1 > 1)) sum(find(Q2 > 1)) sum(find(Q4 < -.5)) ...
           sum(find(Q1d > 1)) sum(find(Q2d > 1)) sum(find(Q3d > 1)) ... 
           sum(find(VE > .5)) sum(find(VP > .5))];

   c = sum(csum);  
end
