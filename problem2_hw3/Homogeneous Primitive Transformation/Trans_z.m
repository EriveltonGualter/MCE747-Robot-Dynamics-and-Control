function out = Trans_z(c)
%Trans_z: Translation matrix from z axes 
out = [eye(3) [0; 0; c]; [0 0 0 1]];
end

