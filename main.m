function point_dyn()
global  mu Rer Fsun jd
mu = 3.986 * 1e14;
Rer = 6371000;
rer = 7371000;
date = datetime(2020, 04, 20, 19, 26, 49); % Year, Month, Day, Hour, Minute, Second
Fsun = 0.03*2*4.56e-6;
jd = 2.4590e+06;

m2km = 1e-3;

% %ISS
% x0 = -4453.783586; y0 = -5038.203756; z0 = -426.384456;
% vx0 = 3.831888; vy0 = -2.887221; vz0 = -6.018232; 
% %sun-synchronous
% % x0 = -2290.301063; y0 = -6379.471940; z0 = 0;
% % vx0 = -0.883923; vy0 = 0.317338; vz0 = 7.610832;
% %GPS 
% x0 = 5525.33668; y0 = -15871.18494;z0 = -20998.992446;
% vx0 = 2.750341; vy0 = 2.434198; vz0 = -1.068884;
% %Molniya 
% x0 = -1529.894287; y0 = -2672.877357; z0 = -6150.115340;
% vx0 = 8.717518; vy0 = -4.989709; vz0 = 0; 
% %GEO
% x0 = 36607.358256; y0 = -20921.723703; z0 = 0;
% vx0 = 1.525636; vy0 = 2.669451; vz0 = 0;
%SunSynch coplanar
x0 = -797.339955; y0 = 6158.728267; z0 = 3718.968038;
vx0 = 1.046104; vy0 = -3.328342; vz0 = 6.522075;
%SunSynch orthograph
xo0 = -5820.224170; yo0 = -2049.5266671; zo0 = 3707.165787;
vxo0 = 3.529269; vyo0 = 1.403339; vzo0 = 6.395063;


iniCond = [x0; y0; z0; vx0; vy0; vz0] * 1e3;
km2m = [xo0; yo0; zo0; vxo0; vyo0; vzo0] * 1e3;


opts = odeset('RelTol',1e-10,'AbsTol',1e-10);

spec_h = cross(iniCond(1:3),iniCond(4:6)); %specific impulse
abs_h = vecnorm(spec_h);
spec_e = 0.5 * vecnorm(iniCond(4:6))^2 - mu / vecnorm(iniCond(1:3)); %specific energy
sma = - mu / (2 * spec_e); %semimajor axis
Torb = 2 * pi * sma^(3/2) / sqrt(mu); %orbital period
ecc = sqrt(1 + 2 * spec_e * (abs_h / mu)^2); %eccentricity
incl = acos(spec_h(3) / abs_h); %inclination

[tp, hp] = ode45(@SunSyn, [0 2*Torb], iniCond, opts);
[tp_test, hp_test] = ode45(@test, [0 2*Torb], iniCond, opts);
[t, rv] = ode45(@SunSyn, [0 2*Torb], km2m, opts);
[t_test, rv_test] = ode45(@test, [0 2*Torb], km2m, opts);


xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6); %rv with SRP
rx = hp_test(:,1); ry = hp_test(:,2); rz = hp_test(:,3); %rv without SRP
x = rv(:,1); y = rv(:, 2); z = rv(:,3);
x_test = rv_test(:,1); y_test = rv_test(:, 2); z_test = rv_test(:, 3);

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

plot (xp);
hold on
plot(rx, 'b.');

% plot3(x, y, z, 'r-');
% hold on
% plot3(x_test, y_test, z_test, 'b.');
% hold on
% plot3(xp, yp, zp, 'r-');
% hold on
% plot3(rx, ry, rz, 'b.');
% hold on
% plot_Earth_meters();
% axis equal
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

xlabel('X');
ylabel('Y');
zlabel('Z');
%[r(1:3),v(1:3)] = coe2rv(p, ecc, incl, omega, argp, nu);

end