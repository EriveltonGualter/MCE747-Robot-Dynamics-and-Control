% Erivelton Gualter 

clc
clear all
close all

% Problem 3

    d1 = 359;   % mm
    d2 = 71;    % mm
    a2 = 325;   % mm
    a3 = 225;   % mm
    d = 225;    % mm
    d4 = d1+d2-d; % mm
    a4 = 30;    % mm
    
    param = [d1 d2 a2 a3 d4 a4];
    q1 = 0; q2 = 0; q3 = 0; q4 = 0;
       
    ax1 = axes('Position',[0.1 0.1 0.7 0.7]);
    ax2 = axes('Position',[0.65 0.65 0.28 0.28]); 
    ax3 = axes('Position',[0.65 0.1 0.28 0.28]); 
%     hold on; view([1,0,0]);
    set(gcf, 'Position', get(0, 'Screensize'));

    % Initialize Plots
    axes(ax1); DrawCylinder(ax1,'none','b'); DrawBase();
    axes(ax2); DrawCylinder(ax2,'none','b'); DrawBase(); title('Cutting Focus','interpreter','latex','fontsize', 14);
    axes(ax3); DrawCylinder(ax3,'-','k'); axis equal; view(0, 90); title('XY view','interpreter','latex','fontsize', 14);
%     Draw(q1, q2, q3, q4, param, ax1);
    
    %% Trajectory
    ts = 0.1;
    t = 0:ts:20;
    v = 2*(15+40)/t(end);
    
    T15 = 0:ts:15/v; 
    T40 = 0:ts:40/v;
    
    % Initialize array
    Ox = ones(1,length(t))*(400 + sqrt(50^2-7.5^2));
    Oy = ones(1,length(t));
    Oz = ones(1,length(t));
    th = ones(1,length(t));

    P01 = length(T15); 
    P12 = length(T15)+length(T40);
    P23 = 2*length(T15)+length(T40);
    
    % path 1
    Oy(1:P01) = -7.5 + v*T15; 
    Oz(1:P01) = 85;
    th(1:P01) = atan2(Oy(1:P01),sqrt(50^2-7.5^2));
    
    % path 2
    Oy(P01:P12-1) = Oy(P01); 
    Oz(P01:P12-1) = Oz(P01) + v*T40;
    th(P01:P12-1) = atan2(7.5,sqrt(50^2-7.5^2));
    
    % path 3
    Oy(P12:P23-1) = Oy(P12-1) - v*T15; 
    Oz(P12:P23-1) = Oz(P12-1); 
    th(P12:P23-1) = atan2(Oy(P12:P23-1),sqrt(50^2-7.5^2));
    
    % path 4
    Oy(P23:end) = Oy(P23-1); 
    Oz(P23:end) = Oz(P23-1) - v*T40; 
    th(P23:end) = atan2(-7.5,sqrt(50^2-7.5^2));
    
    %% Inverse Kinematics
    for i=1:length(t)
        ox = Ox(i);
        oy = Oy(i);
        oz = Oz(i);
        oth = th(i);

        O = [ox, oy, oz, oth];
        [th1, th2, d3, th4] = inverseKinematicsPPWrist(O, a2, a3, d, a4);

        T = forwardKinematicsPPWrist(th1,th2,d3,th4, param);
        t1(:,i) = T(1,4:4:end)';
        t2(:,i) = T(2,4:4:end)';
        t3(:,i) = T(3,4:4:end)';
    end
       
    %% RMS 
    rmsox = rms([Ox-t1(end,:)])
    rmsoy = rms([Oy-t2(end,:)])
    rmsoz = rms([Oz-t3(end,:)]) 

    
    %% Simulation
    time = 0;
    tic;
    while time < t(end)
        
        % Compute the position of the system at the current real world time
        oxp = interp1(t',Ox',time')';
        oyp = interp1(t',Oy',time')';
        ozp = interp1(t',Oz',time')';
        
        t1p = interp1(t',t1',time')';
        t2p = interp1(t',t2',time')';
        t3p = interp1(t',t3',time')';
        
        % Update current time
        time = toc;
        
        axes(ax1); hold on;
        plotLinks(t1p,t2p,t3p);     % Plot Robot
        plot3(oxp,oyp,ozp,'.r');    % Plot Cut
        
        str = horzcat('Time = ',num2str(time,3),' s ...');
        title(str,'interpreter','latex','fontsize', 14);
        
        axes(ax2); hold on; 
        view(45, 180/6);
        axis equal; 
        axis([400 500 -50 50 60 180]);
        plot3(oxp,oyp,ozp,'.r');    % Plot Cut
        
        axes(ax3); hold on;
        plotEnd(t1p(end-2:end),t2p(end-2:end),t3p(end-2:end))
        plot3(oxp,oyp,ozp,'.r');    % Plot Cut
        
        drawnow
    end 
    
    axes(ax1);
    str = horzcat('Total Time = ',num2str(time,3),' s ');
    title(str,'interpreter','latex','fontsize', 14);
    
    figure;
    title('Results from Inverse and Forward Kinematics');
    subplot(311); hold on; plot(t,Ox,'-r', 'LineWidth',2); plot(t, t1(end,:),'--k', 'LineWidth',1.5); box on; ylabel('Ox'); ylim([400 500]);
    subplot(312); hold on; plot(t,Oy,'-r', 'LineWidth',2); plot(t, t2(end,:),'--k', 'LineWidth',1.5); box on; ylabel('Oy');
    subplot(313); hold on; plot(t,Oz,'-r', 'LineWidth',2); plot(t, t3(end,:),'--k', 'LineWidth',1.5); box on; ylabel('Oz'); xlabel('Time, s');

%     print('SCARAconf0','-depsc')
    
    %% Functions
    function T =  forwardKinematicsPPWrist(q1, q2, q3, q4, param)
        
        d1 = param(1);
        d2 = param(2);
        a2 = param(3);
        a3 = param(4);
        d4 = param(5);
        a4 = param(6);
        
        T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
        T01 = getTransformMatrixDH(0, 0, d1, 0);
        T12 = getTransformMatrixDH(a2, 0, d2, q1);
        T23 = getTransformMatrixDH(a3, pi, 0, q2);
        T34 = getTransformMatrixDH(0, 0, -q3+d4, q4);
        T45 = getTransformMatrixDH(a4, 0, 0, 0);
        T56 = getTransformMatrixDH(0, pi/2, 0, pi/2);
        
        T02 = T01*T12;
        T03 = T02*T23;
        T04 = T03*T34;
        T05 = T04*T45;
        T06 = T05*T56;
        
        T = [T00 T01 T02 T03 T04 T06];
    end
    
    function [th1, th2, d3, th4] = inverseKinematicsPPWrist(O,a2,a3,d,a4,T)
        oth = O(4)+pi;
        ox = O(1)-a4*cos(oth);
        oy = O(2)-a4*sin(oth);
        oz = O(3);
        
        c2 = (ox*ox + oy*oy - a2*a2 - a3*a3) / (2*a2*a3);
        th2 = atan2(sqrt(1-c2*c2), c2);
        th1 = atan2(oy,ox) - atan2(a3*sin(th2), a2+a3*cos(th2));
        th4 = th1 + th2 - oth;
        d3  = oz - d;
    end
    
    function DrawCylinder(ax, linestyle, color)
        axes(ax);
        r=50;
        [X,Y,Z] = cylinder(r, 100);
        X = X + 400;
        Z = Z*175 + [75; 0];
        mesh(X,Y,Z,'facecolor',[.7 .7 .7], 'LineStyle', linestyle, 'EdgeColor', color, 'FaceAlpha',0.6);
    end
    
    function DrawBase()
        cube_plot([100,-100,0],400,200,75,'blue');
    end
    
    function cube_plot(origin,X,Y,Z,color)
    % CUBE_PLOT plots a cube with dimension of X, Y, Z.
    % http://jialunliu.com/how-to-use-matlab-to-plot-3d-cubes/
        ver = [1 1 0; 0 1 0; 0 1 1; 1 1 1; 0 0 1; 1 0 1; 1 0 0; 0 0 0];
        fac = [1 2 3 4; 4 3 5 6; 6 7 8 5; 1 2 8 7; 6 7 1 4; 2 3 5 8];

        cube = [ver(:,1)*X+origin(1),ver(:,2)*Y+origin(2),ver(:,3)*Z+origin(3)];
        patch('Faces',fac,'Vertices',cube,'FaceColor',color, 'FaceAlpha',0.6);
    end
    
    function Draw(q1, q2, q3, q4, param, ax)
        axes(ax)
        T =  forwardKinematicsPPWrist(q1, q2, q3, q4, param);
        str = horzcat('$\theta_1 = $',num2str(q1,2),' $\theta_2 = $',num2str(q2,2),' $d_3 = $',num2str(q3,2), ...
            ' $\theta_4 = $',num2str(q4,2));
        title(str,'interpreter','latex');
        hold on; axis equal;
        xlabel('x'); ylabel('y'); zlabel('z'); grid on; box on;
    
        plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end), 'linewidth', 1.5)    
        for i=1:4:length(T)
             DrawCoordFrame(T(:,i:i+3), 'scale', 75, 'linewidth', 2)
        end
        view(45, 180/6);
    end
    
    function plotLinks(x,y,z)
        global links;

        % Draw the cart:
        if isempty(links)
            links =  line(x,y,z, 'LineWidth',2); 
        else
            links.XData = x;
            links.YData = y;
            links.ZData = z;
        end
        view(45, 180/6);
        axis equal
    end
    
    function plotEnd(x,y,z)
        global endeff;

        % Draw the cart:
        if isempty(endeff)
            endeff =  line(x,y,z, 'LineWidth',2); 
        else
            endeff.XData = x;
            endeff.YData = y;
            endeff.ZData = z;
        end
%         view(0, 90);
        axis equal
    end
       
    function Ai = getTransformMatrixDH(a, alpha, d, theta)
        Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
    end