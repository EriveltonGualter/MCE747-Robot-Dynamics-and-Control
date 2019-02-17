%ExampleInvK
%Example: inverse kinematics using Corke's Robotics Toolbox
%Class example: motion and orientation tracking 
%Programmed by H. Richter, CSU, 2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NOTE: Edit to use your own rotation and homogeneous
%transformation functions.
%This code assumes that Rotx,Rotz,Transx,Transz (4x4 homogeneous) and 
%Rot_x, Rot_z (3x3 rotation) are available as Matlab functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%startup_rvc
%load toolbox if not done earlier

d1=1;  
d6=0.5; %location of point of interest on z6 axis

L(1)=Link([0 d1 0 0]);
L(2)=Link([0 0 0 -pi/2 1]);
L(3)=Link([0 0 0 0 1]);
L(4)=Link([0 0 0 -pi/2]);
L(5)=Link([0 0 0 pi/2]);
L(6)=Link([0 d6 0 0]); %For the toolbox solution, the last frame has origin
%at the point of interest o. For the analytical solution, the last frame
%has origin at wrist center.

robot=SerialLink(L,'name','myrobot');
%isspherical(robot)


W=[-10 10 -10 10 -10 10]; 
robot.plot([pi/4 1 1 0 0 pi/2],'workspace',W); %plot some pose



%Define Cartesian points for circle using polar parameterization

r=4; %circle radius
xcir=0;  %x-coordinate of center
ycir=0;  %y-coordinate of center
zcir=10;  %z-coordinate of center

w=2; %angular speed of object p on circle

t=[0:0.1:1]'; %time vector 
n=length(t);
px=xcir+r*cos(w*t);
py=ycir+r*sin(w*t);
pz=zcir*ones(n,1);

%Line to be followed by end effector

ox=0.5+t/4;
oy=0.5+t/4;
oz=1.5+t/2;

%Analytical solution
x0=[1;0;0];y0=[0;1;0];z0=[0;0;1]; %world frame
for i=1:n,
    %Find required orientation (z6 directed from o to p)
    z6=[px(i)-ox(i);py(i)-oy(i);pz(i)-oz(i)];z6=z6/norm(z6);
    %Arbitrary x6 but orthogonal to z6:
    x6=[0;-z6(3);z6(2)]; x6=x6/norm(x6);
    %Complete with y6:
    y6=cross(z6,x6);
    %Build rotation matrix:
    R=[x6'*x0 y6'*x0 z6'*x0;x6'*y0 y6'*y0 z6'*y0;x6'*z0 y6'*z0 z6'*z0];
    %Calculate desired wrist center world position:
    xc(i)=ox(i)-d6*R(1,3);
    yc(i)=oy(i)-d6*R(2,3);
    zc(i)=oz(i)-d6*R(3,3);
    
    %Enter inverse position sub-problem:
    q1(i)=atan2(-xc(i),yc(i)); %
    
    %Positive q1 and q3 leads to oc in second quadrant. 
    %See problem solution notes!
    
    
    q2(i)=zc(i)-d1;
    q3(i)=sqrt(xc(i)^2+yc(i)^2);
    
    %Enter inverse orientation sub-problem:
    R30=Rot_z(q1(i))*Rot_x(-pi/2);
    R30 = R30(1:3,1:3);
    R63=inv(R30)*R;
    
    %Decompose this by Euler
    %assume r31 and r32 are not both zero

    thp=atan2(sqrt(1-R63(3,3)^2),R63(3,3));
    thm=atan2(-sqrt(1-R(3,3)^2),R(3,3));

    phip=atan2(R63(2,3),R63(1,3));
    phim=atan2(-R(2,3),-R(1,3));

    psip=atan2(R63(3,2),-R63(3,1));
    psim=atan2(-R(3,2),R(3,1));

   %Map Euler to DH (see SHV p. 106)
   q4(i)=phip;
   q5(i)=thp;
   q6(i)=psip;

end

%Verification of analytical solution
figure(2)
%Plot desired trajectory
plot3([ox(1) ox(end)],[oy(1) oy(end)],[oz(1) oz(end)],'r-');

hold on
for i=1:n,

    %Manual transformation:
    H10=Rot_z(q1(i))*Trans_z(d1);
    H21=Trans_z(q2(i))*Rot_x(-pi/2);
    H32=Trans_z(q3(i));
    H30=H10*H21*H32;
    H43=Rot_z(q4(i))*Rot_x(-pi/2);
    H54=Rot_z(q5(i))*Rot_x(pi/2);
    H65=Rot_z(q6(i));
    H60=H30*H43*H54*H65;
    
    %Find world position of point of interest:
    ocheck=H60*[0;0;d6;1]; ocheck=ocheck(1:3);
    
    %Plot point of interest
    plot3(ocheck(1),ocheck(2),ocheck(3),'b+')
end
view(75,25)
grid


%Toolbox solution
for i=1:n,
    qguess=[q1(i) q2(i) q3(i) q4(i) q5(i) q6(i)]; %initial analytical solution
    %Find required orientation (z6 directed from o to p)
    z6=[px(i)-ox(i);py(i)-oy(i);pz(i)-oz(i)];z6=z6/norm(z6);
    %Arbitrary x6 but orthogonal to z6:
    x6=[0;-z6(3);z6(2)]; x6=x6/norm(x6);
    %Complete with y6:
    y6=cross(z6,x6);
    %Build rotation matrix:
    R=[x6'*x0 y6'*x0 z6'*x0;x6'*y0 y6'*y0 z6'*y0;x6'*z0 y6'*z0 z6'*z0];
    H=[R [ox(i);oy(i);oz(i)];0 0 0 1];
    qnum(:,i)=robot.ikine(H,qguess,[1 1 1 0 0 1])'; %ignore x,y components of orientation
    qguess=qnum(:,i)';
end

%Verification

for i=1:n,
    H=robot.fkine(qnum(:,i)'); %pull out transformation
    check=H(1:3,4);%look in 4th column to extract world coordinates of endpoint
    plot3(check(1),check(2),check(3),'ko')
end
title('Trajectory: Desired, Analytical and Toolbox')
xlabel('x_0')
ylabel('y_0')
zlabel('z_0')


%Show joint trajectory solutions
figure(3)
subplot(3,2,1)
plot(t,q1,'r',t,qnum(1,:),'k-+')
legend('Analytical','Toolbox')
ylabel('q_1')
title('Joint space solutions')

subplot(3,2,2)
plot(t,q2,'r',t,qnum(2,:),'k-+')
ylabel('q_2')

subplot(3,2,3)
plot(t,q3,'r',t,qnum(3,:),'k-+')
ylabel('q_3')

subplot(3,2,4)
plot(t,q4,'r',t,qnum(4,:),'k-+')
ylabel('q_4')

subplot(3,2,5)
plot(t,q5,'r',t,qnum(5,:),'k-+')
ylabel('q_5')
xlabel('time')

subplot(3,2,6)
plot(t,q6,'r',t,qnum(6,:),'k-+')
ylabel('q_6')
xlabel('time')



