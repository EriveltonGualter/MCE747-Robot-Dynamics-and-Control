% Erivelton Gualter 

clear all
close all

%% Problem 1

R04 = Rot_z(sym(pi/2))*Rot_y(sym(pi/2))*Rot_x(sym(pi/2))*Rot_y(sym(pi/2))

%% Problem 2

    q1 = 1; q2 = 1; d3 = 1; q3 = 0; q4 = 0; q5 = 0;
%     q1 = 1; q2 = 1; d3 = 1; q3 = pi; q4 = 0; q5 = pi/2;
%     q1 = 1; q2 = -1; d3 = 1; q3 = pi/2; q4 = pi/2; q5 = 0;

    [T00,T01,T12,T02,T03, T] =  forwardKinematicsPPwrits(q1, q2, d3, q3, q4, q5);

    Draw(T)
    hold on;
    
    axis equal
    DrawCoordFrame(T00, 'scale', 0.25, 'linewidth', 2)
    DrawCoordFrame(T01, 'scale', 0.25, 'linewidth', 2)
    DrawCoordFrame(T02, 'scale', 0.25, 'linewidth', 2)
    DrawCoordFrame(T03, 'scale', 0.25, 'linewidth', 2)
    
    function Draw(T)
        plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end))    
        xlabel('x'); ylabel('y'); zlabel('z');
    end

    function [T00,T01,T12,T02,T03, T] =  forwardKinematicsPPwrits(q1, q2, d3, q3, q4, q5)
        T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
        T01 = getTransformMatrixDH(0, pi/2, q1, pi/2);
        T12 = getTransformMatrixDH(0, pi/2, q2, 0);
        T23 = getTransformMatrixDH(0, pi/2, d3, q3);
        T34 = getTransformMatrixDH(0, pi/2, 0, q4);
        T534 = getTransformMatrixDH(0, pi/2, 0, q4);

        T02 = T00*T01*T12;
        T03 = T02*T23;
        
        T = [T00 T01 T02 T03];
    end
    
    function Ai = getTransformMatrixDH(a, alpha, d, theta)
        Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
    end