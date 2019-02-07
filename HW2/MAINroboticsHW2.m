% Erivelton Gualter 

clear all
close all

figure('Name','atan2 studying','NumberTitle','off');
axis equal
hold on

rectangle('Position',[-1 -1 2 2], 'Curvature', 1);

XY = [-1; 1];
plotline(XY)

atan2(XY(2),XY(1))




function plotline(XY)
    line([0 XY(1)], [0 XY(2)],'Color','black','LineWidth',2);
    txt = num2str(XY);
    text(XY(1), XY(2),txt,'FontSize',14,'interpreter', 'latex');
end
