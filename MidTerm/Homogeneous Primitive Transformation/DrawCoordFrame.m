function DrawCoordFrame(varargin)
% Add frame to T-matrix
% axis x, y, and z correspond to colors: red, green and blue respectively.
% Example:
%   DrawCoordFrame(T)
%   DrawCoordFrame(T, 'scale', 0.25)
%   DrawCoordFrame(T, 'scale', 0.25, 'linewidth', 2)
%
% Author: Erivelton Gualter
% Created 02/10/2019
% https://github.com/EriveltonGualter

    % Initialize
    lw = 1; % Linewitdh
    s = 1;  % site of array
    
    T = varargin{1};
    for i = 2:2:numel(varargin)
        switch varargin{i}
            case 'linewidth'
                lw = varargin{i+1};
            case 'scale'
                s = varargin{i+1};
            otherwise
                % TODO - add check for properties in line or hgtransform, and
                % update property accordingly.
                warning(sprintf('Ignoring "%s," unexpected property.',varargin{i}));
        end
    end
    
    hold on;
    of = T(1:3,4);          % of: origin frame
    ef = of + T(1:3,1:3)*s; % ef: end frame

    frame(1) = plot3([of(1) ef(1,1)],[of(2) ef(2,1)],[of(3) ef(3,1)],'Color',[1,0,0],'LineWidth',lw);
    frame(2) = plot3([of(1) ef(1,2)],[of(2) ef(2,2)],[of(3) ef(3,2)],'Color',[0,1,0],'LineWidth',lw);
    frame(3) = plot3([of(1) ef(1,3)],[of(2) ef(2,3)],[of(3) ef(3,3)],'Color',[0,0,1],'LineWidth',lw);
end