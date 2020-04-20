function point_dyn()
global  mu Rer 
mu = 3.986 * 1e14;
Rer = 6371000;

m2km = 1e-3;

x0 = -2290.301063; y0 = -6379.471940; z0 = 0;
vx0 = -0.883923; vy0 = 0.317338; vz0 = 7.610832;
iniCond = [x0; y0; z0; vx0; vy0; vz0] * 1e3;

opts = odeset('RelTol',1e-10,'AbsTol',1e-10);

spec_h = cross(iniCond(1:3),iniCond(4:6)); %specific impulse
abs_h = vecnorm(spec_h);
spec_e = 0.5 * vecnorm(iniCond(4:6))^2 - mu / vecnorm(iniCond(1:3)); %specific energy
sma = - mu / (2 * spec_e); %semimajor axis
Torb = 2 * pi * sma^(3/2) / sqrt(mu); %orbital period
ecc = sqrt(1 + 2 * spec_e * (abs_h / mu)^2); %eccentricity
incl = acos(spec_h(3) / abs_h); %inclination

[tp, hp] = ode45(@point_calculate, [0 10*Torb], iniCond, opts);

xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);

energy = 0.5*dot(hp(:,4:6)',hp(:,4:6)')' - mu * vecnorm(hp(:,1:3), 2, 2).^(-1);
plot(tp, (energy - energy(1))/energy(1));
max(abs((energy - energy(1))/energy(1)))
%[p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(1,1:3) * m2km, hp(1, 4:6) * m2km);

% axis equal;
% plot3(xp, yp, zp, 'r-');

end