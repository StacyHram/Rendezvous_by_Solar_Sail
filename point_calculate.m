function f = point_calculate(t, x)
    mu = 3.986 * 1e14;
    r = sqrt(x(1)^2 + x(2)^2 + x(3)^2);
    f = [x(4); x(5); x(6); (-mu/r^3)*x(1); (-mu/r^3)*x(2); (-mu/r^3)*x(3)];
    
end