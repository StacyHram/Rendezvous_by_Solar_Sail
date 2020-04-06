function point_dyn()
global  mu Rer 
mu = 3.986 * 1e14;
Rer = 6371000;

m2km = 1e-3;

x0 = -2290.301063; y0 = -6379.471940; z0 = 0;
vx0 = -0.883923; vy0 = 0.317338; vz0 = 7.610832;
iniCond = [x0; y0; z0; vx0; vy0; vz0] * 1e3;

opts = odeset('RelTol',1e-5,'AbsTol',1e-5);

spec_h = cross(iniCond(1:3),iniCond(4:6)); %specific impulse
abs_h = vecnorm(spec_h);
spec_e = 0.5 * vecnorm(iniCond(4:6))^2 - mu / vecnorm(iniCond(1:3)); %specific energy
sma = - mu / (2 * spec_e); %semimajor axis
Torb = 2 * pi * sma^(3/2) / sqrt(mu); %orbital period
ecc = sqrt(1 + 2 * spec_e * (abs_h / mu)^2); %eccentricity
incl = acos(spec_h(3) / abs_h); %inclination

[tp, hp] = ode45(@point_calculate, [0 2*Torb], iniCond, opts);

xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);



[p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(1,1:3) * m2km, hp(1, 4:6) * m2km);
incl = rad2deg(incl);
omega = rad2deg(omega);
argp = rad2deg(argp);
nu = rad2deg(nu);
elements = double.empty(6, 0);
 for i=1:1:(size(hp))
     hp(i, 1:6);
     [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(i,1:3) * m2km, hp(i, 4:6) * m2km);
     elements(i,1) = a; element(i,2) = ecc; elements(i, 3) = incl;
     elements(i, 4) = omega; elements(i, 5) = argp; elements(i, 6) = nu;
 end
 
 
%         hp(i, 1:6)
%     end
% end
        

[p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(hp(1,1:3) * m2km, hp(1, 4:6) * m2km);

ed = length(elements);
plot3(xp, yp, zp, 'r-');
axis equal;
xlabel('X, ì', 'FontSize',12,'FontWeight','bold','Color','b');
ylabel('Y, ì', 'FontSize',12,'FontWeight','bold','Color','b');
zlabel('Z, ì', 'FontSize',12,'FontWeight','bold','Color','b');
time = [0:25:5554];
hp = hp(1:223,5);
figure; plot(time, elements(1:223,1))

figure;plot(time, elements(1:223,2))
figure;plot(time, elements(1:223,3))
figure;plot(time, elements(1:223,4))
figure;plot(time, elements(1:223,5))
figure;plot(time, elements(1:223,6))


%[r(1:3),v(1:3)] = coe2rv(p, ecc, incl, omega, argp, nu);

end