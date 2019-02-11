function Example3_1(varargin)
% Example Example 3.1 Planar Elbow Manipulator
% Spong, Mark W., Seth Hutchinson, and Mathukumalli Vidyasagar. Robot modeling and control. Vol. 3. New York: Wiley, 2006.
% Code: Erivelton Gualter: https://eriveltongualter.github.io/
%
% Example:
%   example3_1
%   example3_1(th1, th2): 
%   example3_1(th1, th2, a1, a2)

    % Initialization
    a1 = 1;
    a2 = 1;
    th1 = pi/4;
    th2 = pi/4;
  
    for i = 1:1:numel(varargin)
        switch i
            case 1
                th1 = varargin{1};
            case 2
                th2 = varargin{2};
            case 3
                a1 = varargin{3};
            case 4
                a2 = varargin{4};
        end
    end
    
    [T00,T01,T12,T02, T] =  forwardKinematicsRR(th1, th2, a1, a2);

    Draw(T)
    hold on;

    axis equal
    view([0,0,1])

    DrawCoordFrame(T01, 'scale', 0.25, 'linewidth', 2)
    DrawCoordFrame(T02, 'scale', 0.25, 'linewidth', 2)

    function Draw(T)
        plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end))    
        xlabel('x'); ylabel('y'); zlabel('z');
    end

    function [T00,T01,T12,T02, T] =  forwardKinematicsRR(th1, th2, a1, a2)
        T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
        T01 = getTransformMatrixDH(a1, 0, 0, th1);
        T12 = getTransformMatrixDH(a2, 0, 0, th2);

        T02 = T00*T01*T12;
        T = [T00 T01 T02];
    end
end

