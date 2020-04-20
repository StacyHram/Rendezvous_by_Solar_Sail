function orbit_with_sun()

global  mu Rer 
mu = 3.986 * 1e14;
Rer = 6371000;
c = clock();       %time

m2km = 1e-3;

x0 = -2290.301063; y0 = -6379.471940; z0 = 0;
vx0 = -0.883923; vy0 = 0.317338; vz0 = 7.610832;
%Sun-Sync -2290.301063 -6379.471940 0 -0.883923 0.317338 7.610832 MEO GPS 5525.33668 -15871.18494 -20998.992446 2.750341 2.434198 -1.068884 HEO Molniya -1529.894287 -2672.877357 -6150.115340 8.717518 -4.989709 0 GEO GEO 36607.358256 -20921.723703 0 1.525636 2.669451 0

iniCond = [x0; y0; z0; vx0; vy0; vz0] * 1e3;

opts = odeset('RelTol',1e-5,'AbsTol',1e-5);

spec_h = cross(iniCond(1:3),iniCond(4:6));      %specific impulse
abs_h = vecnorm(spec_h);
spec_e = 0.5 * vecnorm(iniCond(4:6))^2 - mu / vecnorm(iniCond(1:3)); %specific energy
sma = - mu / (2 * spec_e); %semimajor axis
Torb = 2 * pi * sma^(3/2) / sqrt(mu); %orbital period
ecc = sqrt(1 + 2 * spec_e * (abs_h / mu)^2); %eccentricity
incl = acos(spec_h(3) / abs_h); %inclination

[tp, hp] = ode45(@point_calculate, [0 2*Torb], iniCond, opts);

rv = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);

[p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(1,1:3) * m2km, hp(1, 4:6) * m2km);

incl = rad2deg(incl); %conversion radian to degrees
omega = rad2deg(omega);
argp = rad2deg(argp);
nu = rad2deg(nu);

elements = double.empty(6, 0); %elements on all orbit
 for i=1:1:(size(hp))
     hp(i, 1:6);
     [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(i,1:3) * m2km, hp(i, 4:6) * m2km);
     elements(i,1) = a; elements(i,2) = ecc; elements(i, 3) = incl;
     elements(i, 4) = omega; elements(i, 5) = argp; elements(i, 6) = nu;
 end
 [x, y, z] = cylinder(Rer)
 surface(x, y, z)
end

