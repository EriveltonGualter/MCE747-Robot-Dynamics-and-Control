% Erivelton Gualter dos Santos
% 19/01/2019
%
% Homework 1 - Robotic

clear all
close all

% Set paramentes
l1 = 1;
l2 = 1;
delta = 0.1;
d = 0.2;
h = 0.5;
D = 0.75;

param = [l1 delta d h D];

figure('Name','RP Robot','NumberTitle','off');
hold on;
i=1;
for q1 = 0:0.1:2*pi
    for q2 = 0:0.1:D
        [x,y] = fowardRP(q1, q2, param); 
        if y>=0
            plotRP(x,y, param);
%             xs(i) = x(3);
%             ys(i) = y(3);
%             i=i+1;
        end
    end
end
% xs(i) = 0;
% ys(i) = h;
k = boundary(xs',ys');
plot(xs(k),ys(k),'-r');

hold on;
line([-1 1],[0 0],'Color','black','LineWidth',2);

figure('Name','PR Robot','NumberTitle','off');
i=1;
for q1 = 0:0.1:D
    for q2 = 0:0.1:2*pi
        [x,y] = fowardPR(q1, q2, param); 
        if y>=0
            plotPR(x,y, param)
%             xs(i) = x(2);
%             ys(i) = y(2);
%             i=i+1;
        end
    end
end
% k = boundary(xs',ys');
% plot(xs(k),ys(k),'-r');

%% Functions
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
    plot(x(3), y(3), '*b');
      
    axis equal
end


function [x,y] = fowardPR(q1, q2, param)
    
    l2 = param(1);
    delta = param(2);
    d = param(3);
    h = param(4);
    D = param(5);

    x1 = 0;
    y1 = q1+h;
      
    x2 = x1 + l2*cos(q2);
    y2 = y1 + l2*sin(q2);

    x = [x1 x2];
    y = [y1 y2];
end

function plotPR(x,y, param)

    d = param(3);
    h = param(4);
    
    hold on;
    line([0 0], [0 h],'LineStyle','--');
    line([0 x(1)], [h y(1)],'LineStyle','--');
    line([x(1) x(2)], [y(1) y(2)],'LineStyle','--');
        
    axis equal
end

