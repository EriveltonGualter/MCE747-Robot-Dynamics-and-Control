%exampleSVD
%Geometric interpretation of the singular value decomposition
%H Richter, CSU 2015

A=[1 2;-3 4]; %some 2x2 matrix

%sweep the plane with a unit vector in polar coordinates
%compute images and plot
hold on
axis equal

th=[0:0.01:2*pi];
for i=1:length(th),
    x=cos(th(i));
    y=sin(th(i));
    outv=A*[x;y];
    plot(outv(1),outv(2),'k*')
end
grid
%Compare amplification factors in singular directions

[U,S,V]=svd(A)
%Process max amplification direction
Vmax=V(:,1);
umaxout=A*Vmax;
plot([0 umaxout(1)],[0 umaxout(2)],'r') %this should line up the ellipse's major axis
norm(umaxout) %this should match the max svd of A (since Vmax has norm=1)
norm(A,2) %this should also match the max svd of A by definition of 2-norm 
umaxout/norm(umaxout) %this should match one of the U columns!

%Process min amplification direction
Vmin=V(:,2);
uminout=A*Vmin;
plot([0 uminout(1)],[0 uminout(2)],'b') %this should line up the ellipse's minor axis
norm(uminout) %this should match the min svd of A (since Vmin has norm=1)
uminout/norm(uminout) %this should match the other U column


