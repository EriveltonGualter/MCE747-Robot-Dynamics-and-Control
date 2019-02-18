% Erivelton Gualter 

clear all
close all

%% Problem 1
R04 = Rotz(-sym(pi/2))*Roty(-sym(pi))*Rotx(sym(pi)/2)*Roty(sym(pi/2))

%% Problem 2
figure('Name','Problem 2 - Zero Angle Configuration','NumberTitle','off');
d1 = 1; d2 = 1; d3 = 1; th3 = 0; th4 = 0; d5 = 1; th5 = 0;
Draw(d1, d2, d3, th3, th4, d5, th5);

print('configuration0','-depsc')

figure('Name','Problem 2 - Configuration 1','NumberTitle','off');
d1 = 1; d2 = 1; d3 = 1; th3 = pi; th4 = 0; d5 = 1; th5 = pi/2;
Draw(d1, d2, d3, th3, th4, d5, th5);

print('configuration1','-depsc')

figure('Name','Problem 2 - Configuration 1','NumberTitle','off');
d1 = 1; d2 = -1; d3 = 1; th3 = pi/2; th4 = pi/2; d5 = 1; th5 = 0;
Draw(d1, d2, d3, th3, th4, d5, th5);

print('configuration2','-depsc')

t = 0:0.01:20;
d1 = sin(2*t);
d2 = cos(t);
th3 = t;
th4 = sin(2*t);
th5 = t;

figure;
for i=1:length(t)
    cla
    T =  forwardKinematicsPPWrist(d1(i), d2(i), d3, th3(i), th4(i), d5, th5(i));  
    XYZ(i,:) = T(1:3, end);        
end

%     Simulation
first_frame = true;
time = 0;
tic;
while time < t(end)
    cla
    % Compute the position of the system at the current real world time
    d1Draw = interp1(t',d1',time')';
    d2Draw = interp1(t',d2',time')';
    th3Draw = interp1(t',th3',time')';
    th4Draw = interp1(t',th4',time')';
    th5Draw = interp1(t',th5',time')';

    % Update current time
    time = toc;

    Draw(d1Draw, d2Draw, d3, th3Draw, th4Draw, d5, th5Draw);
    hold on;
    plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3), 'LineWidth',2); 
    axis([-2 2 -2 2 -2 2]);
    drawnow

    % gif utilities
    set(gcf,'color','w');   % set figure background to white
    frame = getframe(1);    % get desired frame
    im = frame2im(frame);   % Transform frame to image
    [imind,cm] = rgb2ind(im,256);  % Convert RGB image to indexed image
    outfile = 'simulation2.gif';    % GIF is the BEST. However, you can modify the extensions.

    % On the first loop, create the file. In subsequent loops, append.
    if first_frame
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf); 
        first_frame = false;
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'writemode','append');
    end
end 

figure
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3), 'LineWidth',2); 
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; box on; grid on; axis([-2 2 -2 2 -2 2]);
print('EndETraj3D','-depsc')

figure
subplot(223); plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3), 'LineWidth',2); box on; axis equal; view([0,0,1]);
subplot(221); plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3), 'LineWidth',2); box on; axis equal; view([0,1,0]);
subplot(222); plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3), 'LineWidth',2); box on; axis equal; view([1,0,0]);

figure
subplot(311); plot(t, XYZ(:,1)', 'LineWidth',2); ylabel('X');
subplot(312); plot(t, XYZ(:,2)', 'LineWidth',2); ylabel('Y');
subplot(313); plot(t, XYZ(:,3)', 'LineWidth',2); ylabel('Z'); xlabel('Time, s');

print('EndETrajTime1','-depsc')

%% Functions
function Draw(q1, q2, d3, q3, q4, d5, q5)
    T =  forwardKinematicsPPWrist(q1, q2, d3, q3, q4, d5, q5);
    str = horzcat('$d_1 = $',num2str(q1,2),' $d_2 = $',num2str(q2,2),' $\theta_3 = $',num2str(q3,2), ...
        ' $\theta_4 = $',num2str(q4,2),' $\theta_5 = $',num2str(q5,2));
    title(str,'interpreter','latex');
    hold on; axis equal;
    xlabel('x'); ylabel('y'); zlabel('z'); grid on; box on;

    plot3(T(1,4:4:end), T(2,4:4:end), T(3,4:4:end))    
    for i=1:4:length(T)
        DrawCoordFrame(T(:,i:i+3), 'scale', 0.25, 'linewidth', 2)
    end
    view(3)
end

function T =  forwardKinematicsPPWrist(q1, q2, d3, q3, q4, d5, q5)
    T00 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    T01 = getTransformMatrixDH(0, +pi/2, q1, pi/2);
    T12 = getTransformMatrixDH(0, +pi/2, q2, pi/2);
    T23 = getTransformMatrixDH(0, +pi/2, d3, q3);
    T34 = getTransformMatrixDH(0, -pi/2, 0,  q4);
    T450 = getTransformMatrixDH(d5,    0, 0,  q5);
    T45 = getTransformMatrixDH(0,  +pi/2, 0,  pi/2);

    T02 = T01*T12;
    T03 = T02*T23;
    T04 = T03*T34;
    T05 = T04*T450*T45;

    T = [T00 T01 T02 T03 T04 T05];
end

function Ai = getTransformMatrixDH(a, alpha, d, theta)
    Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
end