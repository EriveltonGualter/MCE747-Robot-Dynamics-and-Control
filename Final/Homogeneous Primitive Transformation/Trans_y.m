function out = Trans_y(b)
%Trans_y: Translation matrix from y axes 
out = [eye(3) [0; b; 0]; [0 0 0 1]];
end

