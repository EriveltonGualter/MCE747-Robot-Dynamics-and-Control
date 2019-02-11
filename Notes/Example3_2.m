function Example3_2(varargin)
% Example Example 3.2 Three-Link Cylidrical Robot
% Spong, Mark W., Seth Hutchinson, and Mathukumalli Vidyasagar. Robot modeling and control. Vol. 3. New York: Wiley, 2006.
% Code: Erivelton Gualter: https://eriveltongualter.github.io/
%
% Example:
%   example3_1
%   example3_1(th1, d1, d2, d3)

    % Initialization
    th1 = 0;
    d1 = 1;
    d2 = 1;
    d3 = 1;
    
    for i = 1:1:numel(varargin)
        switch i
            case 1
                th1 = varargin{1};
            case 2
                d1 = varargin{2};
            case 3
                d2 = varargin{3};
            case 4
                d3 = varargin{4};
        end
    end
    
    [T00,T01,T12,T02, T] =  forwardKinematicsRPP(th1, d1, d2, d3);

    Draw(T)
    hold on;

    axis equal
%     view([0,0,1])

    DrawCoordFrame(T00, 'scale', 0.25, 'linewidth', 2)
    DrawCoordFrame(T01, 'scale', 0.25, 'linewidth', 2)
    DrawCoordFrame(T02, 'scale', 0.25, 'linewidth', 2)
    DrawCoordFrame(T03, 'scale', 0.25, 'linewidth', 2)

    function Draw(T)
        plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end))    
        xlabel('x'); ylabel('y'); zlabel('z');
    end

    function [T00,T01,T12,T02, T] =  forwardKinematicsRPP(th1, d1, d2, d3)
        T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
        T01 = getTransformMatrixDH(0, 0, d1, th1);
        T12 = getTransformMatrixDH(0, -pi/2, d2, 0);
        T23 = getTransformMatrixDH(0, 0, d3, 0);

        T02 = T00*T01*T12;
        T03 = T00*T01*T12*T23;
        
        T = [T00 T01 T02 T03];
    end
end

