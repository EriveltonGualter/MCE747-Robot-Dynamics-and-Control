% Erivelton Gualter dos Santos
% 19/01/2019
%
% Homework 1 - Robotic

clear all
close all

% Set paramentes
l1 = 1;
delta = 0.1;
d = 0.2;
h = 0.5;
D = 0.75;

param = [l1 delta d h D];

hold on;
for q1 = 0:0.1:2*pi
    for q2 = 0:0.01:D
        [x,y] = fowardRP(q1, q2, param); 
        if y>=0
            plotRP(x,y, param)
        end
    end
end

function [x,y] = fowardRP(q1, q2, param)
    
    l1 = param(1);
    delta = param(2);
    d = param(3);
    h = param(4);
    D = param(5);

    x1 = l1*cos(q1);
    y1 = l1*sin(q1)+h;
    
    x1r = x1 + 0.5*d*sin(q1);
    y1r = y1 - 0.5*d*cos(q1);
    x1l = x1 - 0.5*d*sin(q1);
    y1l = y1 + 0.5*d*cos(q1);
        
    x2 = x1 - delta*cos(q1);
    y2 = y1 - delta*sin(q1);

    x3 = x2 + q2*sin(q1);
    y3 = y2 - q2*cos(q1);

    x = [x1 x2 x3 x1r x1l];
    y = [y1 y2 y3 y1r y1l];
end

function plotRP(x,y, param)

    d = param(3);
    h = param(4);
    
    hold on;
    line([0 0], [0 h],'LineStyle','--');
    line([0 x(1)], [h y(1)],'LineStyle','--');
    line([x(2) x(3)], [y(2) y(3)],'LineStyle','--');
    line([x(4) x(5)], [y(4) y(5)],'Color','black');
    
%     rectangle('Position', [-.5*d -.5*d d d], 'Curvature', 1)
    
    axis equal
end



