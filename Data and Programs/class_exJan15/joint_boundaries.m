%joint_boundaries
%Plots the joint space boundaries of the workspace of a 2-link planar arm

%The locus of the joint angle combinations yielding a specific end link orientation 
%(dexterous set) is also plotted

%MCE/EEC 647/747
%Code by H Richter, Spring 2015

L1=2; %link length
L2=2; %link length

hold on

for q1=0:0.05:pi, %range of first joint
    D=L2^2-L1^2*(sin(q1))^2; 
    if D<0, %the second link can revolve without touching base
        q2min=-pi;
        q2max=pi; %the range of q2 in this case is essentially unlimited. Choosing [-pi,pi] arbitarily
        plot(q1,q2min,'*',q1,q2max,'*');
    else
        if q1<pi/2,
            x=L1*cos(q1)-sqrt(D) %intersection near the origin, first quadrant
            bet=asin(L1*sin(q1)/L2);
            gam=asin(x*sin(q1)/L2);
            q2min=-q1-bet;
            q2max=pi+gam;
            plot(q1,q2min,'*',q1,q2max,'*');
        else
            q1sym=pi-q1; 
            x=L1*cos(q1sym)-sqrt(D) %intersection near the origin, third quadrant
            bet=asin(L1*sin(q1sym)/L2);
            gam=asin(x*sin(q1sym)/L2);
            q2max=q1sym+bet;
            q2min=-pi-gam;
            plot(q1,q2min,'*',q1,q2max,'*');
        end
    end
end
%Superimpose end frame orientation. Example shown for second link vertical in the world frame (q1+q2=-pi/2)
q1=[0:0.05:pi];
q2=-pi/2-q1;
plot(q1,q2,'k-')

    
