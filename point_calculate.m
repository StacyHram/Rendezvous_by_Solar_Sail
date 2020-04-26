function f = point_calculate(t, x)
    mu = 3.986 * 1e14;
    jd = 2.4590e+06;
    Rer = 6371000;
    Fsun = 0.03*2*4.56e-6;
    r = sqrt(x(1)^2 + x(2)^2 + x(3)^2);
    rx = [x(1)/Rer, x(2)/Rer, x(3)/Rer];
    
    [lit] = light( rx, (jd + t/86400), 's' );
    if lit == 'yes'
        f = [x(4); x(5); x(6); (-mu/r^3)*x(1)+Fsun; (-mu/r^3)*x(2)+Fsun; (-mu/r^3)*x(3)+Fsun];
    else
        f = [x(4); x(5); x(6); (-mu/r^3)*x(1); (-mu/r^3)*x(2); (-mu/r^3)*x(3)];
    end
end