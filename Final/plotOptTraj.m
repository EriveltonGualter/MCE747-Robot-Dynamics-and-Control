function [q, qd, qdd, Tau] = plotOptTraj(X, w, t, VeFcn, VpFcn, Yfcn, TH, flag)

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
            
            Tau(:,k) = Yfcn(Q{:},Qd{:},Qdd{:})*TH;
        end
    end
    
    Ve(:,k) = VeFcn(Q{:}, Qd{:});
    Vp(:,k) = VpFcn(Q{:}, Qd{:});
    end
    
    VE = sqrt(Ve(1,:).^2+Ve(2,:).^2+Ve(3,:).^2).';
    VP = sqrt(Vp(1,:).^2+Vp(2,:).^2+Vp(3,:).^2).';
    
    if flag
        figure;
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

        figure;
        subplot(311); hold on; plot(t, Tau(1,:));         plot(t, 25*ones(length(t)), t, -25*ones(length(t)), 'r', 'LineWidth', 2);   ylabel('Tau 1');
        subplot(312); hold on; plot(t, Tau(2,:));         plot(t, 25*ones(length(t)), t, -25*ones(length(t)), 'r', 'LineWidth', 2);   ylabel('Tau 2');
        subplot(313); hold on; plot(t, Tau(3,:));         plot(t, 25*ones(length(t)), t, -25*ones(length(t)), 'r', 'LineWidth', 2);   ylabel('Tau 3');
    end
end