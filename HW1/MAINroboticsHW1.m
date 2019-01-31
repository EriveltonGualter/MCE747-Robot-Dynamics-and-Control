% Erivelton Gualter dos Santos
% 19/01/2019
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

%% RP Robot
figure('Name','RP Robot','NumberTitle','off');
hold on; box on;
i=1;
for q1 = 0:0.01:2*pi
    for q2 = 0:0.01:D
        [x,y] = fowardRP(q1, q2, param); 
        if y>=0
            xs(i) = x(3);
            ys(i) = y(3);
            i=i+1;
        end
    end
end
k = boundary(xs',ys',1);
plot(xs(k),ys(k),'-b','LineWidth',2);

hold on;
line([-1 1],[0 0],'Color','black','LineWidth',2);
title('Reachable workspace for a RP robot');
axis equal

% Example RP Robot
q1 = pi/4;
q2 = .75;
drawRP(q1, q2, param)
yaxis(2);

dim = [0.6 0.6 0.4 0.3];
str = {'Joints at ', [num2str(q1), 'rad and',num2str(q2), 'm']};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

print('rprobot','-depsc')

%% PR Robot
figure('Name','PR Robot','NumberTitle','off');
i=1;
for q1 = 0:0.01:D
    for q2 = 0:0.01:2*pi
        [x,y] = fowardPR(q1, q2, param); 
        if y>=0
            xs(i) = x(2);
            ys(i) = y(2);
            i=i+1;
        end
    end
end
k = boundary(xs',ys');
plot(xs(k),ys(k),'-b','LineWidth',2);
axis equal

line([-1 1],[0 0],'Color','black','LineWidth',2);
title('Reachable workspace for a RP robot');

% Example PR Robot
q1 = .75;
q2 = pi/4;
drawPR(q1, q2, param)

dim = [0.2 0.6 0.4 0.3];
str = {'Joints at ', [num2str(q1), 'rad and',num2str(q2), 'm']};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

print('prrobot','-depsc')

%% Functions
function [x,y] = fowardRP(q1, q2, param)
    
    l1 = param(1);
    delta = param(2);
    d = param(3);
    h = param(4);
    D = param(5);

    xbr = d/2*cos(q1);
    ybr = -d/2*sin(q1)+h;
    xbl = -d/2*cos(q1);
    ybl = d/2*sin(q1)+h;
    
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

    x = [x1 x2 x3 x1r x1l xbr xbl];
    y = [y1 y2 y3 y1r y1l ybr ybl];
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

function drawRP(q1, q2, param)
    [x,y] = fowardRP(q1, q2, param); 
    rectangle('Position',[-.4 -.05 .8 .8], 'Curvature', 1,'LineWidth',2,'FaceColor',[.6 .6 .6],'EdgeColor','k');
    rectangle('Position',[-.5 0 1 .35],'LineWidth',2,'FaceColor',[.6 .6 .6],'EdgeColor','k');
    
    xa = x(4:end)'; ya = y(4:end)';
    k = boundary(xa, ya);
    plot(xa(k),ya(k),'-k','LineWidth',2);
    
    line([x(2) x(3)], [y(2) y(3)],'LineWidth',2,'Color','black');

    rectangle('Position',[-.1 .4 .2 .2], 'Curvature', 1,'LineWidth',2,'FaceColor',[.6 .6 .6],'EdgeColor','k');
end

function drawPR(q1, q2, param)
    h = param(4);
    [x,y] = fowardPR(q1, q2, param); 
    rectangle('Position',[-.2 0 .4 .5],'LineWidth',2,'FaceColor',[.6 .6 .6],'EdgeColor','k');
    rectangle('Position',[-.1 0.5 .2 q1],'LineWidth',2,'FaceColor',[.6 .6 .6],'EdgeColor','k');
    
    line([x(1) x(2)], [y(1) y(2)],'LineWidth',2,'Color','black');
end

