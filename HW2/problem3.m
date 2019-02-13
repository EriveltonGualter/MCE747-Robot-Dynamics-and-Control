% Erivelton Gualter 

clear all
close all


%% Problem 3

    d1 = 359;   % mm
    d2 = 71;    % mm
    a2 = 325;   % mm
    a3 = 225;   % mm
    d4 = d1+d2-225; % mm
    d5 = 30;    % mm
    
    param = [d1 d2 a2 a3 d4 d5];
    q1 = 0; q2 = 0; q3 = 0; q4 = 0;
    
    hold on;
    DrawEnv()
    Draw(q1, q2, q3, q4, param);
    
    %% Functions
    function DrawEnv()
        r=50;
        [X,Y,Z] = cylinder(r, 100);
        X = X + 400;
        Z = Z*175 + [75; 0];
        mesh(X,Y,Z,'facecolor',[.7 .7 .7], 'LineStyle', 'none', 'FaceAlpha',0.6);

        y = linspace(-7.5,7.5, 100);
        x = sqrt(50^2-y.^2) + 400;
        z = [85 125; 125 125];
        zi = ones(2,length(y));
        
        plot3(x,y,zi.*z(1,:)', '-r', 'LineWidth', 2); 
        plot3(x,y,zi.*z(2,:)', '-r', 'LineWidth', 2); 
        
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
    
    function Draw(q1, q2, q3, q4, param)
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
        view(3)
    end

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
        T34 = getTransformMatrixDH(0, 0, d4+q3, 0);
        T45 = getTransformMatrixDH(a4, 0, 0, q4);
        T56 = getTransformMatrixDH(0, pi/2, 0, pi/2);
        
        T02 = T01*T12
        T03 = T02*T23
        T04 = T03*T34
        T05 = T04*T45
        T06 = T05*T56
        
        T = [T00 T01 T02 T03 T04 T06];
    end
    
    function Ai = getTransformMatrixDH(a, alpha, d, theta)
        Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
    end