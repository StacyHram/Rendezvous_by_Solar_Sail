function f = SunSyn(t, x)
    mu = 3.986 * 1e14;
    J2 = 0.0010827;
    jd = 2.4590e+06;
    Rer = 6371000;
    Fsun = 10*2*4.56e-6;
    r = sqrt(x(1)^2 + x(2)^2 + x(3)^2);
    rx = [x(1)/Rer, x(2)/Rer, x(3)/Rer];
    
    [lit] = light( rx, (jd + t/86400), 's' );
    if lit == 'yes'
        f = [x(4); x(5); x(6); (-mu/r^3)*x(1)+Fsun/10+mu*J2*Rer^2/2*(15*x(1)*x(3)^2/r^7 - 3*x(1)/r^5); (-mu/r^3)*x(2)+Fsun/10+mu*J2*Rer^2/2*(15*x(2)*x(3)^2/r^7 - 3*x(2)/r^5); (-mu/r^3)*x(3)+Fsun/10+mu*J2*Rer^2/2*(15*x(3)^2/r^7 - 9*x(3)/r^5)];
    else
        f = [x(4); x(5); x(6); (-mu/r^3)*x(1)+ mu*J2*Rer^2/2*(15*x(1)*x(3)^2/r^7 - 3*x(1)/r^5); (-mu/r^3)*x(2)+ mu*J2*Rer^2/2*(15*x(1)*x(3)^2/r^7 - 3*x(1)/r^5); (-mu/r^3)*x(3)+mu*J2*Rer^2/2*(15*x(3)^2/r^7 - 9*x(3)/r^5)];
    end
end