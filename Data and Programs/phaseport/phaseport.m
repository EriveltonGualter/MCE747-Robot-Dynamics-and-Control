%phaseport
%Example code to display a phase portrait of a 2nd order autonomous system
%Programmed by H. Richter
%Cleveland State University, 2015
%Uses adjust_quiver_arrowhead_size from Matlab Exchange / Kevin Delaney

%From the class example:

%x1dot=-2*x1+x2*u
%x2dot=-x1*u

%Set up a grid around the equilibrium point
u=1;
x1=[-1:0.15:1];
x2=[-1:0.15:1];
for i=1:length(x1),
    for j=1:length(x2),
    x1dot=-2*x1(i)+x2(j)*u;
    x2dot=-x1(i)*u;
        %normalize vector field
        uv=0.075*[x1dot;x2dot]/norm([x1dot;x2dot]);
        %plot
        q=quiver(x1(i),x2(j),uv(1),uv(2),'r','LineWidth',1.5);hold on
        adjust_quiver_arrowhead_size(q, 8);
    end
end
 axis tight