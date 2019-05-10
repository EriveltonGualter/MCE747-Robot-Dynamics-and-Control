function plotStates(t, Q, pax, Tau)

[~,n]=size(Q);

if n == 9
    Qtemp = Q;
    Q(:,1) = Qtemp(:,1);
    Q(:,4) = Qtemp(:,2);
%     Q(:,10)= Qtemp(:,3);
    Q(:,2) = Qtemp(:,4);
    Q(:,5) = Qtemp(:,5);
%     Q(:,11)= Qtemp(:,6);
    Q(:,3) = Qtemp(:,7);
    Q(:,6) = Qtemp(:,8);
%     Q(:,12)= Qtemp(:,9);
end  

plot(pax(1), t, Q(:,1), 'LineWidth', 1.5);  ylabel(pax(1), 'q1');
plot(pax(4), t, Q(:,4), 'LineWidth', 1.5);  ylabel(pax(4), 'q1dot');

plot(pax(2), t, Q(:,2), 'LineWidth', 1.5); ylabel(pax(2), 'q2');
plot(pax(5), t, Q(:,5), 'LineWidth', 1.5); ylabel(pax(5), 'q2dot');

plot(pax(3), t, Q(:,3), 'LineWidth', 1.5); ylabel(pax(3), 'q4');
plot(pax(6), t, Q(:,6), 'LineWidth', 1.5); ylabel(pax(6), 'q4dot');


plot(pax(7), t, Tau(:,1), '-r', 'LineWidth', 1.5);  ylabel(pax(7), 'Tau 1'); 
plot(pax(8), t, Tau(:,2), '-r', 'LineWidth', 1.5); ylabel(pax(8), 'Tau 2'); 
plot(pax(9), t, Tau(:,3), '-r', 'LineWidth', 1.5); ylabel(pax(9), 'Tau 3'); 

% [~,n]=size(Q);
% 
% if n == 9
%     Qtemp = Q;
%     Q(:,1) = Qtemp(:,1);
%     Q(:,4) = Qtemp(:,2);
%     Q(:,10)= Qtemp(:,3);
%     Q(:,2) = Qtemp(:,4);
%     Q(:,5) = Qtemp(:,5);
%     Q(:,11)= Qtemp(:,6);
%     Q(:,3) = Qtemp(:,7);
%     Q(:,6) = Qtemp(:,8);
%     Q(:,12)= Qtemp(:,9);
% end  
% 
% plot(pax(1), t, Q(:,1), 'LineWidth', 1.5);  ylabel('q1');
% plot(pax(4), t, Q(:,4), 'LineWidth', 1.5);  ylabel('q1dot');
% plot(pax(7), t, Q(:,10),'LineWidth', 1.5); ylabel('q1ddot'); 
% 
% plot(pax(2), t, Q(:,2), 'LineWidth', 1.5); ylabel('q2');
% plot(pax(5), t, Q(:,5), 'LineWidth', 1.5); ylabel('q2dot');
% plot(pax(8), t, Q(:,11),'LineWidth', 1.5); ylabel('q2ddot'); 
% 
% plot(pax(3), t, Q(:,3), 'LineWidth', 1.5); ylabel('q4');
% plot(pax(6), t, Q(:,6), 'LineWidth', 1.5); ylabel('q4dot');
% plot(pax(9), t, Q(:,12), 'LineWidth', 1.5); ylabel('q4ddot'); 

end

