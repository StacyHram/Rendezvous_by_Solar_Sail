function point_dyn()
global  mu Rer 
mu = 3.986 * 1e14;
Rer = 6371000;

m2km = 1e-3;

x0 = -4453.783586; y0 = -5038.203756; z0 = -426.384456;
vx0 = 3.831888; vy0 = -2.887221; vz0 = -6.018232;
iniCond = [x0; y0; z0; vx0; vy0; vz0] * 1e3;

opts = odeset('RelTol',1e-5,'AbsTol',1e-5);

spec_h = cross(iniCond(1:3),iniCond(4:6)); %specific impulse
abs_h = vecnorm(spec_h);
spec_e = 0.5 * vecnorm(iniCond(4:6))^2 - mu / vecnorm(iniCond(1:3)); %specific energy
sma = - mu / (2 * spec_e); %semimajor axis
Torb = 2 * pi * sma^(3/2) / sqrt(mu); %orbital period
ecc = sqrt(1 + 2 * spec_e * (abs_h / mu)^2); %eccentricity
incl = acos(spec_h(3) / abs_h); %inclination

[tp, hp] = ode45(@point_calculate, [0 Torb], iniCond, opts);

xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);

axis equal;

[p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(1,1:3) * m2km, hp(1, 4:6) * m2km)
raan = rad2deg(0.7967)
aop = rad2deg(2.6513)
ta = rad2deg(0.571)

plot3(xp, yp, zp, 'r-');

[r(1:3),v(1:3)] = coe2rv(p, a, ecc, incl, omega, argp, nu)

end