function out = getOptimal(t, Q)
    time = 0:.1:10;
    q1 = interp1(time,Q(:,1),t')';
    q2 = interp1(time,Q(:,2),t')';
    q4 = interp1(time,Q(:,3),t')';
    
    q1d = interp1(time,Q(:,4),t')';
    q2d = interp1(time,Q(:,5),t')';
    q4d = interp1(time,Q(:,6),t')';
    
    q1dd = interp1(time,Q(:,7),t')';
    q2dd = interp1(time,Q(:,8),t')';
    q4dd = interp1(time,Q(:,9),t')';

    out = [q1 q2 q4 q1d q2d q4d q1dd q2dd q4dd];
%     
end