function F = systemf(x,u)
        F = [x(1)^2-u;
             x(1)*x(2)^2-x(2)*u];
         