function point_dyn()
global  Rer gm
mu = 3.986 * 1e14;
gm = 5972e24;
alt = 600000;
Rer = 6371000;
pi2 = 2*pi;
mean_motion = sqrt(mu/(Rer+alt)^3);

Torb = 2 *pi / mean_motion;

x0 = Rer + alt; y0 = 0; z0 = 0;
vx0 = 0; vy0 = x0*mean_motion; vz0 = 0;

[tp, hp] = ode45(@point_calculate, [0 Torb], [x0; y0; z0; vx0; vy0; vz0]);
xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);

res = zeros(101, 2);

for i = 1:1:size(xp)
   
    test = pkepler([xp(i); yp(i); zp(i)], [vxp(i); vyp(i); vzp(i)],1,1,1);
    res(i, 1:2) = test;
end

axis equal;

plot3(xp, yp, zp, 'r-');

end