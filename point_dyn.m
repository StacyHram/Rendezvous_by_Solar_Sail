function point_dyn()
global mu

mu = 3.986 * 1e14;
alt = 600000;
Rer = 6371000;

mean_motion = sqrt(mu/(Rer+alt)^3);

Torb = 2 *pi / mean_motion;

x0 = Rer + alt; y0 = 0; z0 = 0;
vx0 = 0; vy0 = x0*mean_motion; vz0 = 0;

[tp, hp] = ode45(@point_calculate, [0 Torb], [x0; y0; z0; vx0; vy0; vz0]);
xp = hp(:,1); yp = hp(:,2); zp = hp(:,3);

plot3(xp, yp, zp, 'r-');
end