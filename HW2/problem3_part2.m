% Erivelton Gualter
%
% Peter Corke Toolbox

clear all
close all

a1 = .325; 
a2 = .255; 
d1 = .359; 
d2 = .071;
d = .225; 
d4 = d1+d2-d;
a4 = .03;

L(1) = Link([0, d1, a1, 0,  0],'standard');
L(2) = Link([0, d2,  a2, pi, 0],'standard');
L(3) = Link([0, 0,  0,  0,  1],'standard');
L(4) = Link([0, d4,  0,  0,  0],'standard');
L(5) = Link([0, 0,  a4,  0,  0],'standard');

scara = SerialLink(L,'name','SCARA');

hold on;
q = [0 0 0 0 0];
DrawCylinder('none','b'); 
DrawBase();
view(45, 180/6);
scara.plot(q,'workspace',[-0.2 0.8 -0.4 0.4 -0.3 0.6])
zlim([0 .6]);
title('Zero Angle Configuration - SCARA Robot');
set(gcf, 'Position', get(0, 'Screensize'));

print('toolboxZero','-depsc')

[Ox, Oy, Oz, th, t] = getTrajectory(20, 0.1);

O = [Ox(1); Oy(1); Oz(1); th(1)];
[th1, th2, d3, th4] = inverseKinematicsPPWrist(O,a1,a2,4,a4);
qg = [th1 th2 d3 th4 0];

display('Computing Inverse Kinematics ...');
%% Inverse Kinematics
for i=1:length(t)
    ox = Ox(i);
    oy = Oy(i);
    oz = Oz(i);
    oth = th(i);

    O = [ox; oy; oz];
    H = [Rotz(oth) O; 0 0 0 1];
    q = scara.ikine(H,qg,[-.1 1 -.5 .5 0 .6]);
    qg = q;
    
    th1(i) = q(1);
    th2(i) = q(2);
    d3(i) = q(3);
    th4(i) = q(4);
    
    H05 = scara.fkine([th1(i) th2(i) d3(i) th4(i) 0]);
    O2(:,i) = H05(1:3,end);
end

display('OK');
display('RMS:');

rms([Ox-O2(1,:)])
rms([Oy-O2(2,:)])
rms([Oz-O2(3,:)])

figure;
title('Results from Inverse and Forward Kinematics'); 
subplot(311); hold on; plot(t,Ox,'-r', 'LineWidth',2); plot(t, O2(1,:),'--k', 'LineWidth',1.5); box on; ylabel('Ox'); ylim([.4 .5]); legend('Direct','Inverse');
subplot(312); hold on; plot(t,Oy,'-r', 'LineWidth',2); plot(t, O2(2,:),'--k', 'LineWidth',1.5); box on; ylabel('Oy');
subplot(313); hold on; plot(t,Oz,'-r', 'LineWidth',2); plot(t, O2(3,:),'--k', 'LineWidth',1.5); box on; ylabel('Oz'); xlabel('Time, s');

print('INVvsDIR2','-depsc')

% %% Simulation
% time = 0;
% oxp2 = []; oyp2 = []; ozp2 = [];
% tic;
% while time < t(end)
% 
%     % Compute the position of the system at the current real world time
%     q1 = interp1(t',th1',time')';
%     q2 = interp1(t',th2',time')';
%     q3 = interp1(t',d3',time')';
%     q4 = interp1(t',th4',time')';
%     
%     oxp = interp1(t',Ox',time')';
%     oyp = interp1(t',Oy',time')';
%     ozp = interp1(t',Oz',time')';
% 
%     % Update current time
%     time = toc;
%     q = [q1 q2 q3 q4 0];
%     scara.plot(q,'workspace',[-0.2 0.8 -0.4 0.4 -0.3 0.6])
%     oxp2 = [oxp2 oxp];
%     oyp2 = [oyp2 oyp];
%     ozp2 = [ozp2 ozp];
%     hold on; plot3(oxp2,oyp2,ozp2,'.r');    % Plot Cut 
%     hold off;
%     view(45, 180/6);
% 
%     drawnow
% end 

%% Functions
function [th1, th2, d3, th4] = inverseKinematicsPPWrist(O,a2,a3,d,a4)
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

function DrawCylinder(linestyle, color)
    r=50;
    [X,Y,Z] = cylinder(r, 100);
    X = X + 400;
    Z = Z*175 + [75; 0];
    X = X*1e-3;
    Y = Y*1e-3;
    Z = Z*1e-3;
    mesh(X,Y,Z,'facecolor',[.7 .7 .7], 'LineStyle', linestyle, 'EdgeColor', color, 'FaceAlpha',0.7);
end

function DrawBase()
    cube_plot([.1,-.1,0],.4,.2,.075,'blue');
end

function cube_plot(origin,X,Y,Z,color)
% CUBE_PLOT plots a cube with dimension of X, Y, Z.
% http://jialunliu.com/how-to-use-matlab-to-plot-3d-cubes/
    ver = [1 1 0; 0 1 0; 0 1 1; 1 1 1; 0 0 1; 1 0 1; 1 0 0; 0 0 0];
    fac = [1 2 3 4; 4 3 5 6; 6 7 8 5; 1 2 8 7; 6 7 1 4; 2 3 5 8];

    cube = [ver(:,1)*X+origin(1),ver(:,2)*Y+origin(2),ver(:,3)*Z+origin(3)];
    patch('Faces',fac,'Vertices',cube,'FaceColor',color, 'FaceAlpha',0.4);
end

function [Ox, Oy, Oz, th, t] = getTrajectory(tf, ts)
    t = 0:ts:tf;
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

    Ox = Ox*1e-3;
    Oy = Oy*1e-3;
    Oz = Oz*1e-3;
end
