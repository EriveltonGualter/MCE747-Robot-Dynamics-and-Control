function xdot=deriv_fcn(x,u)

xdot1=x(1)^2-u;
xdot2=x(1)*x(2)^2-x(2)*u;

xdot=[xdot1;xdot2];
