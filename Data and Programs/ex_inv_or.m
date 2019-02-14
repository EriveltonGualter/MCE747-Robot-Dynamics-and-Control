%ex_inv_or

%Example of inverse orientation solution by Euler

%Given rotation
R=Rx(pi/4)*Ry(pi/3)*Ry(-pi)*Rz(pi);

%r31 and r32 are not both zero

thp=atan2(sqrt(1-R(3,3)^2),R(3,3));
thm=atan2(-sqrt(1-R(3,3)^2),R(3,3));

phip=atan2(R(2,3),R(1,3));
phim=atan2(-R(2,3),-R(1,3));

psip=atan2(R(3,2),-R(3,1));
psim=atan2(-R(3,2),R(3,1));


%Check plus solution

Rcheck_plus=Rz(phip)*Ry(thp)*Rz(psip);
Rcheck_plus-R

%Check minus solution

Rcheck_minus=Rz(phim)*Ry(thm)*Rz(psim);
Rcheck_minus-R
