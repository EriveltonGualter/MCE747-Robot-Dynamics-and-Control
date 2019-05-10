
clear all

X = [ 5 17 -20 99 3.4 2 8 -6 ];

y = cleanUp(X)

function y = cleanUp(x)
  x([find(x>10) find(x<0)]) = NaN;
  y = x;
end