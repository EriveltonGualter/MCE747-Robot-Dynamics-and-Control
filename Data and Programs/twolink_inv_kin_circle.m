%twolink_inv_kin_circle
%Example: inverse kinematics using Corke's Robotics Toolbox
%Programmed by H. Richter, CSU, 2015


%startup_rvc
%load toolbox if not done earlier

mdl_twolink %load predefined robot
twolink.plot([pi/4,pi/4]) %plot some pose

%Define Cartesian points for circle using polar parameterization

r=0.5; %circle radius
xc=1;  %x-coordinate of center
yc=1;  %y-coordinate of center
th=[0:0.05:2*pi]; 
x=xc+r*cos(th);
y=yc+r*sin(th);

qguess=[pi/2 3*pi/4]; %close enough?

for i=1:length(x),
    %We don't care about the end effector orientation or the z coordinate. Assume arbitary
    %rotation component and z component
    H=[eye(3) [x(i);y(i);0];0 0 0 1];
    q(:,i)=twolink.ikine(H,qguess,[1 1 0 0 0 0])'; %the fourth argument is a mask telling ikine to ignore orientation and z.
    qguess=q(:,i)';
end

%Verification
figure(2)
hold on
for i=1:length(x),
    H=twolink.fkine(q(:,i)'); %pull out transformation
    check=H(1:3,4);      %look in 4th column to extract world coordinates of endpoint
    plot(check(1),check(2),'*')
end
axis equal   %we want to see a circle, not an ellipse


    

