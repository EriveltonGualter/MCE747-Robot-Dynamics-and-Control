% Erivelton Gualter 

clear all
close all

%% Problem 1

R04 = Rot_z(sym(pi/2))*Rot_y(sym(pi/2))*Rot_x(sym(pi/2))*Rot_y(sym(pi/2))

%% Problem 2

    q1 = 1; q2 = 1; d3 = 1; q3 = 0; q4 = 0; d5 = 1; q5 = 0;
%     q1 = 1; q2 = 1; d3 = 1; q3 = pi; q4 = 0; d5 = 1; q5 = pi/2;
%     q1 = 1; q2 = -1; d3 = 1; q3 = pi/2; q4 = pi/2; d5 = 1; q5 = 0;

    T =  forwardKinematicsPPWrist(q1, q2, d3, q3, q4, d5, q5);

    Draw(T)
    
    t = 0:0.01:20;
    q1 = sin(2*t);
    q2 = cos(t);
    q3 = t;
    q4 = sin(2*t);
    q5 = t;
    
    for i=1:length(t);
        T =  forwardKinematicsPPWrist(q1(i), q2(i), d3, q3(i), q4(i), d5, q5(i));  
        XYZ(i,:) = T(1:3, end);
    end
    
    figure;
    plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3)); 
    xlabel('X'); ylabel('Y'); zlabel('Z');
    
    figure;
    subplot(311); plot(t, XYZ(:,1)'); ylabel('X');
    subplot(312); plot(t, XYZ(:,2)'); ylabel('Y');
    subplot(313); plot(t, XYZ(:,3)'); ylabel('Z'); xlabel('Time, s');
        
    function Draw(T)
        plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end))    
        hold on; axis equal;
        for i=1:4:length(T)
            DrawCoordFrame(T(:,i:i+3), 'scale', 0.25, 'linewidth', 2)
        end
        xlabel('x'); ylabel('y'); zlabel('z');
    end

    function T =  forwardKinematicsPPWrist(q1, q2, d3, q3, q4, d5, q5)
        
        T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
        T01 = getTransformMatrixDH(0, +pi/2, q1, 0);
        T12 = getTransformMatrixDH(0, +pi/2, q2, 0);
        T23 = getTransformMatrixDH(0, +pi/2, 0,  q3);
        T34 = getTransformMatrixDH(0, -pi/2, 0,  q4);
        T45 = getTransformMatrixDH(0,     0, d5, q5);
        T56 = getTransformMatrixDH(0, +pi/2, d5, 0);

        T02 = T01*T12;
        T03 = T02*T23;
        T04 = T03*T34;
        T05 = T04*T45;
        T06 = T05*T56;
        
        T = [T00 T01 T02 T03 T04 T05 T06];
    end
    
    function Ai = getTransformMatrixDH(a, alpha, d, theta)
        Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
    end