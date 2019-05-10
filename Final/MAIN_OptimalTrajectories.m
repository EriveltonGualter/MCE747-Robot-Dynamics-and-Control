% Erivleton Gualter
% FINAL

clc

if ~exist('Yfcn', 'var')
    [M, C, G, F, TH, Y] = getWAMParameters();
    [Mfcn, Cfcn, Gfcn, Ffcn, Yfcn, Yavfcn, TH] = convertSymVarsTOfunctions(M, C, G, F, TH);
    [Ve, Vp] = getVeVp();
    
    syms q1 q2 q3 q4 q1dot q2dot q3dot q4dot;
    q3 = 0;
    q3dot = 0;
    Ve = eval(Ve);
    Vp = eval(Vp);

    VeFcn = matlabFunction(Ve, 'vars', [q1 q2 q4 q1dot q2dot q4dot]);
    VpFcn = matlabFunction(Vp, 'vars', [q1 q2 q4 q1dot q2dot q4dot]);
end
          
clearvars -except Y Yfcn VeFcn VpFcn

t = 0:.1:10;
Q(:,1) = sin(t);
Q(:,2) = sin(t);
Q(:,3) = sin(t);

Qdot(:,1) = cos(t);
Qdot(:,2) = cos(t);
Qdot(:,3) = cos(t);

Qddot(:,1) = -sin(t);
Qddot(:,2) = -sin(t);
Qddot(:,3) = -sin(t);

a = rand(12,1);
b = rand(12,1);
w = 2*pi/10;

X0 = [a; b]; 
% X0 = X;

% LB = -10*ones(size([a;b]));
% UB = +10*ones(size([a;b]));
LB = [];
UB = [];

lambd1 = 1; 
lambd2 = 10;

FUN = @(X) (objFunction(X, w, lambd1, lambd2, t, Yfcn));
NONLCON = @(X) (nonLinearQ(X, w, t, VeFcn, VpFcn));
OPTIONS = optimoptions('fmincon','Display','iter','MaxFunctionEvaluations',10000, ...
    'OptimalityTolerance',1e-11,'StepTolerance',1e-11,'MaxIterations',10000*10); 

% OPTIONS = optimoptions('fmincon','Display','iter','MaxFunctionEvaluations',10000, ...
%     'OptimalityTolerance',1e-11,'StepTolerance',1e-11,'MaxIterations',10000); 

% for k=1:5
EXITFLAG = -1;
while EXITFLAG < 0
    r0 = -.3;
    r1 = .3;
%     a = rand(12,1);
%     b = rand(12,1);
    a = (r1-r0)*rand(12,1) +r0;
    b = (r1-r0)*rand(12,1) +r0;
    X0 = [a; b]; 
    [X,FVAL,EXITFLAG,OUTPUT] = fmincon(FUN,X0,[],[],[],[],[],[],NONLCON,OPTIONS);
end
% X = fmincon(FUN,X0,[],[],[],[],[],[],NONLCON,OPTIONS);

plotTraj(X, w, t, VeFcn, VpFcn, 0)
% end


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
%     condSum
%     1/svdSum

%     cost = lambd1*condSum/N + lambd2/(svdSum*N) + 1e-3/std(q(:,1));
%     cost = lambd1*condSum/N + lambd2/(svdSum*N);
    cost = lambd1*condSum/N + lambd2*N/(svdSum)*10;
end


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
   
%     if sum(csum) > 0 
%         c = 1000;
%     else
%         c = -1;
%     end   
    c = sum(csum);
       
       
%     c = [c sum(find(Q1 > 1)) sum(find(Q2 > 1)) sum(find(Q4 < -.5)) ...
%            sum(find(Q1d > 1)) sum(find(Q2d > 1)) sum(find(Q3d > 1)) ... 
%            sum(find(VE > .5)) sum(find(VP > .5))]/length(Q1);
    
end

function plotTraj(X, w, t, VeFcn, VpFcn, flag)

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
    
    VE = sqrt(Ve(1,:).^2+Ve(2,:).^2+Ve(3,:).^2).';
    VP = sqrt(Vp(1,:).^2+Vp(2,:).^2+Vp(3,:).^2).';
    
%     if flag 
        figure;
%         set(0, 'currentfigure', f);  %# for figures
        subplot(311); hold on; plot(t, q(:,1));     plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q1');
        subplot(312); hold on; plot(t, q(:,2));     plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q2');
        subplot(313); hold on; plot(t, q(:,3));     plot(t, 2*ones(length(t)), t, -.5*ones(length(t)), 'r', 'LineWidth', 2);    ylabel('q4');

        figure;
        subplot(311); hold on; plot(t, qd(:,1));    plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q1d');
        subplot(312); hold on; plot(t, qd(:,2));    plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q2d');
        subplot(313); hold on; plot(t, qd(:,3));    plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q4d');

        figure;
        subplot(211); hold on; plot(t, VE);         plot(t, .5*ones(length(t)), t, -.5*ones(length(t)), 'r', 'LineWidth', 2);   ylabel('Ve');
        subplot(212); hold on; plot(t, VP);         plot(t, .5*ones(length(t)), t, -.5*ones(length(t)), 'r', 'LineWidth', 2);   ylabel('Vp');
%     else
%         figure;
%         subplot(311); hold on; plot(t, q(:,1)); ylabel('q1');
%         subplot(312); hold on; plot(t, q(:,2)); ylabel('q2');
%         subplot(313); hold on; plot(t, q(:,3)); ylabel('q4');
% 
%         figure;
%         subplot(311); hold on; plot(t, qd(:,1)); ylabel('q1d');
%         subplot(312); hold on; plot(t, qd(:,2)); ylabel('q2d');
%         subplot(313); hold on; plot(t, qd(:,3)); ylabel('q4d');
% 
%         figure;
%         subplot(211); hold on; plot(t, VE); ylabel('Ve');
%         subplot(212); hold on; plot(t, VP); 
%     end

%     subplot(421); hold on; plot(t, q(:,1));     plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q1');
%     subplot(423); hold on; plot(t, q(:,2));     plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q2');
%     subplot(425); hold on; plot(t, q(:,3));     plot(t, 2*ones(length(t)), t, -.5*ones(length(t)), 'r', 'LineWidth', 2);    ylabel('q4');
%     subplot(422); hold on; plot(t, qd(:,1));    plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q1d');
%     subplot(424); hold on; plot(t, qd(:,2));    plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q2d');
%     subplot(426); hold on; plot(t, qd(:,3));    plot(t, ones(length(t)), t, -1*ones(length(t)), 'r', 'LineWidth', 2);       ylabel('q4d');
%     subplot(427); hold on; plot(t, VE);         plot(t, .5*ones(length(t)), t, -.5*ones(length(t)), 'r', 'LineWidth', 2);   ylabel('Ve');
%     subplot(428); hold on; plot(t, VP);         plot(t, .5*ones(length(t)), t, -.5*ones(length(t)), 'r', 'LineWidth', 2);   ylabel('Vp');
end