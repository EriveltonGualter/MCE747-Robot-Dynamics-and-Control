   %Calculates the external force term for the 2-link planar robot
   %MCE647 Case Study, Spring 2015

   %         | Ft pos
   %         |
   %         |
   %         V
   %     ENDPOINT<------Fn pos
   %        /
   %       /
   %      /
   %     /
   
   
   syms a1 a2
   syms q1 q2  Ft Fn
   
   %Kinematic Jacobian at the end effector (from other codes)
   Jv=[- a2*sin(q1 + q2) - a1*sin(q1) -a2*sin(q1 + q2); a2*cos(q1 + q2) + a1*cos(q1)  a2*cos(q1 + q2)];
   
   Te=Jv.'*[-Fn;Ft];
   %Verify that the components of Te try to decelerate the joints when Fn
   %and Ft are positive and oriented as in the sketch
   
   %Fn will be modeled as a normal force due to stiffness
   %Ft will be modeled as a tangential force due to dry+viscous friction
   


