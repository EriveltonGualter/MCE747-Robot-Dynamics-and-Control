function zdot=hgoder_2link(t,x,y)

x1=x(1); %first joint position estimate
x2=x(2); %second joint position estimate
x3=x(3); %first joint velocity estimate
x4=x(4); %second joint velocity estimate

y1=y(1); %first joint measurement
y2=y(2); %second joint measurement

epsilon=0.01;
Hp=diag([1 1]);
Hv=diag([1 1]);

zdot1=[x3;x4]+Hp*[y1-x1;y2-x2]/epsilon;
zdot2=Hv*[y1-x1;y2-x2]/epsilon^2;

zdot=[zdot1;zdot2];

