close all
clear all

A = [1 -1; 0 0];

hold on; box on;
plot([-1 1], [0 0]); 

x = linspace(-1,1,2); y = x;
plot(x, y, '-r')

grid on
axis equal
legend('Column space', 'Null space');

txt = '$\left[\begin{array}{c} -1\\ 0 \end{array}\right]$'
text(-1,0,txt,'FontSize',14,'interpreter', 'latex');

txt = '$\left[\begin{array}{c} 1\\ 0 \end{array}\right]$'
text(0.7,0,txt,'FontSize',14,'interpreter', 'latex');

txt = '$\left(\begin{array}{c} \frac{\sqrt{2}}{2}\\ \frac{\sqrt{2}}{2} \end{array}\right)$'
text(.5,.5,txt,'FontSize',14,'interpreter', 'latex');

print('prob2_1a','-depsc')

%% 

figure; 

B = [1 -1; 0 0];

hold on; box on;
plot([-1 1], [0 0]); 

x = linspace(-1,1,2); y = x;
plot(x, y, '-r')

grid on
axis equal
legend('Column space', 'null space');

txt = '$\left[\begin{array}{c} -1\\ 0 \end{array}\right]$'
text(-1,0,txt,'FontSize',14,'interpreter', 'latex');

txt = '$\left[\begin{array}{c} 1\\ 0 \end{array}\right]$'
text(0.7,0,txt,'FontSize',14,'interpreter', 'latex');

txt = '$\left(\begin{array}{c} \frac{\sqrt{2}}{2}\\ \frac{\sqrt{2}}{2} \end{array}\right)$'
text(.5,.5,txt,'FontSize',14,'interpreter', 'latex');
