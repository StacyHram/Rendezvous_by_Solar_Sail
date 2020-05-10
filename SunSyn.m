function f = SunSyn(t, x)
    mu = 3.986 * 1e14;
    J2 = 0.0010827;
    jd = 2.4590e+06;
    Rer = 6371000;
    Ver = 465.1013; 
    A = 10;
    Fsun = A*2*4.56e-6;
    r = sqrt(x(1)^2 + x(2)^2 + x(3)^2);
    rx = [x(1)/Rer, x(2)/Rer, x(3)/Rer];
    v = [x(4); x(5); x(6)];
    
    J2x = mu*J2*Rer^2/2*(15*x(1)*x(3)^2/r^7 - 3*x(1)/r^5);
    J2y = mu*J2*Rer^2/2*(15*x(2)*x(3)^2/r^7 - 3*x(2)/r^5);
    J2z = mu*J2*Rer^2/2*(15*x(3)^2/r^7 - 9*x(3)/r^5);

    [rhoAtmo] = rho(800);
    length_v = sqrt(x(4)^2 + x(5)^2 + x(6)^2);
    ort_v = -[x(4)/length_v; x(5)/length_v, x(6)/length_v];
    a_dyn = 0.5*A*2.2*rhoAtmo*(v - Ver)/10;
    
    [lit] = light( rx, (jd + t/86400), 's' );
    if lit == 'yes'
        f = [x(4); x(5); x(6); (-mu/r^3)*x(1) + Fsun/10 + J2x; (-mu/r^3)*x(2) + Fsun/10 + J2y; (-mu/r^3)*x(3) + Fsun/10 + J2z] ;
    else
        f = [x(4); x(5); x(6); (-mu/r^3)*x(1) + J2x; (-mu/r^3)*x(2) + J2y; (-mu/r^3)*x(3) + J2z];
    end
    
end
