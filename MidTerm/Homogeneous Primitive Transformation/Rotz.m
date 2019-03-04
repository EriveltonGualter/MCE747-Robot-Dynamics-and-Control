function out = Rotz(alpha)
%Rot_z: Basic rotation matrix about the z-axes 
out = [cos(alpha) -sin(alpha) 0; ...
    sin(alpha) cos(alpha) 0; ...
    0 0 1]; 
end

