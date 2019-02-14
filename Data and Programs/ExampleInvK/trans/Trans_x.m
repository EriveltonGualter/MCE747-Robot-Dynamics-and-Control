function out = Transx(a)
%Trans_x: Translation matrix from y axes 
out = [eye(3) [a; 0; 0]; [0 0 0 1]];
end

