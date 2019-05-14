function end_eff_pos=forward_kin_2link(q)
%Two-link planar manipulator:
%Calculates the position of the origin of the end-effector

l1=0.6;
l2=0.4; %using nominal quantities
x=l1*cos(q(1))+l2*cos(q(1)+q(2));
y=l1*sin(q(1))+l2*sin(q(1)+q(2));  %see SHV p.85
end_eff_pos=[x;y];
