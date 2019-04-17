function out = Rotx(alpha)
%Rot_x: Basic rotation matrix about the x-axes 
out = [1 0 0 ; ...
    0 cos(alpha) -sin(alpha); ....
    0 sin(alpha) cos(alpha)]; 
end

