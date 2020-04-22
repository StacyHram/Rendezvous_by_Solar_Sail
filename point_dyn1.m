function point_dyn()
global  mu Rer Fsun jd
mu = 3.986 * 1e14;
Rer = 6371000;
rer = 7371000;
date = datetime(2020, 04, 20, 19, 26, 49); % Year, Month, Day, Hour, Minute, Second
Fsun = 0.03*2*4.56e-6;


m2km = 1e-3;

%ISS
x0 = -4453.783586; y0 = -5038.203756; z0 = -426.384456;
vx0 = 3.831888; vy0 = -2.887221; vz0 = -6.018232; 
%sun-synchronous
% x0 = -2290.301063; y0 = -6379.471940; z0 = 0;
% vx0 = -0.883923; vy0 = 0.317338; vz0 = 7.610832;
iniCond = [x0; y0; z0; vx0; vy0; vz0] * 1e3;


opts = odeset('RelTol',1e-10,'AbsTol',1e-10);

spec_h = cross(iniCond(1:3),iniCond(4:6)); %specific impulse
abs_h = vecnorm(spec_h);
spec_e = 0.5 * vecnorm(iniCond(4:6))^2 - mu / vecnorm(iniCond(1:3)); %specific energy
sma = - mu / (2 * spec_e); %semimajor axis
Torb = 2 * pi * sma^(3/2) / sqrt(mu); %orbital period
ecc = sqrt(1 + 2 * spec_e * (abs_h / mu)^2); %eccentricity
incl = acos(spec_h(3) / abs_h); %inclination

[tp, hp] = ode45(@point_calculate, [0 Torb], iniCond, opts);
[t_test, rv_test] = ode45(@test, [0 Torb], iniCond, opts);

rx = rv_test(:,1); ry = rv_test(:,2); rz = rv_test(:,3)
xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);
r = [hp(:,1)/Rer, hp(:,2)/Rer, hp(:,3)/Rer];
%[p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(1,1:3) * m2km, hp(1, 4:6) * m2km);

% incl = rad2deg(incl); %conversion radian to degrees
% omega = rad2deg(omega);
% argp = rad2deg(argp);
% nu = rad2deg(nu);

elements = double.empty(6, 0); %elements on all orbit
 for i=1:1:(size(hp))
     hp(i, 1:6);
     [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(i,1:3) * m2km, hp(i, 4:6) * m2km);
     elements(i,1) = a; elements(i,2) = ecc; elements(i, 3) = incl;
     elements(i, 4) = omega; elements(i, 5) = argp; elements(i, 6) = nu;
 end

%[p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(1,1:3) * m2km, hp(1, 4:6) * m2km);%elements in point 1

jd_start = juliandate(date); % Start date


[rsun,~,decl] = sun ( jd_start );%direction to sun

sun_side = zeros(i+1, 1);
for i=1:1:(size(r))
    [lit] = light( r(i,:), jd_start+tp(i)/86400, 's' );
    if lit == 'yes'
        sun_side(i,1) = 1;
    else
        sun_side(i,1) = 0;
    end
    
end



%plot(time_vector, sun_side)
axis equal
plot (xp);
hold on
plot(rx, 'b.');
% plot3(xp, yp, zp, 'r-');
% hold on
% plot3(rx, ry, rz, 'b.');

%plot_Earth_meters();
% рисуем Землю
% hold on

% time = [0:25:5554];
% hp = hp(1:223,5);
% figure; plot(time, elements(1:223,1))

% figure;plot(time, elements(1:223,2))
% figure;plot(time, elements(1:223,3))
% figure;plot(time, elements(1:223,4))
% figure;plot(time, elements(1:223,5))
% figure;plot(time, elements(1:223,6))


%[r(1:3),v(1:3)] = coe2rv(p, ecc, incl, omega, argp, nu);

end