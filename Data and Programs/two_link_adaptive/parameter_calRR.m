%Parameter_calcRR
%In-class example: two-link planar RR manipulator
m1=10;
m2=8;
l1=0.6;
l2=0.4;
I1=26;
I2=12;
g=9.8;


TH1_0=m1*l1^2/4+m2*(l1^2+l2^2/4)+I1+I2;
TH2_0=m2*l1*l2/2;
TH3_0=m2*l2^2/4+I2;
TH4_0=m1*l1/2+m2*l1;
TH5_0=m2*l2;
TH_0=[TH1_0;TH2_0;TH3_0;TH4_0;TH5_0];
%The above is taken to be the nominal (used in control law)

%Re-calculate TH using perturbed parameters (worst-case)
level=0.25;  %uncertainty level in individual parameters
m1_max=(1+level)*m1;
m2_max=(1+level)*m2;
l1_max=(1+level)*l1;
l2_max=(1+level)*l2;
I1_max=(1+level)*I1;
I2_max=(1+level)*I2;

TH1_max=m1_max*l1_max^2/4+m2_max*(l1_max^2+l2_max^2/4)+I1_max+I2_max;
TH2_max=m2_max*l1_max*l2_max/2;
TH3_max=m2_max*l2_max^2/4+I2_max;
TH4_max=m1_max*l1_max/2+m2_max*l1_max;
TH5_max=m2_max*l2_max;

DTH=[TH1_max-TH1_0;TH2_max-TH2_0;TH3_max-TH3_0;TH4_max-TH4_0;TH5_max-TH5_0];
rho=norm(DTH);

%Now generate actual perturbations for use in plant
m1=m1+m1*(1-2*rand)*level;
m2=m2+m2*(1-2*rand)*level;
l1=l1+l1*(1-2*rand)*level;
l2=l2+l2*(1-2*rand)*level;
I1=I1+I1*(1-2*rand)*level;
I2=I2+I2*(1-2*rand)*level;

Z0=[0;0;0;0]; %initial condition for plant integrator
