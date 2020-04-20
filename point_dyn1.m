function point_dyn()
global  mu Rer 
mu = 3.986 * 1e14;
Rer = 6371000;
rer = 7371000;
real_time = clock();

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

xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);

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

 [jd, ~] = jday(real_time(1), real_time(2), real_time(3), real_time(4), real_time(5), real_time(6)); %julian date
 [jd_end, ~] = jday(real_time(1), real_time(2), real_time(3), real_time(4)+ fix(Torb/ (60^3)), real_time(5)+ mod(Torb, 60^2), real_time(6)+ mod(Torb,60)) %julian date
 ti = (jd_end - jd)/ length(elements)
 time_orb = [jd:ti:jd_end]
% 
[rsun,~,decl] = sun ( jd );%direction to sun
r = [x0, y0, z0];
enter_ex = zeros(i, 1);
for i=1:1:(size(elements))
      t = time_orb(i);
    elements( i, 1);
    [lit] = light ( r, t, 's' )
    %enter_ex(i,1) = lit;
end
[lit] = light ( r, jd, 's' );

%eccentric anomaly of shadow points
% enter_ex = zeros(i, 2);
% for i=1:1:(size(elements))
%     enter_ex( i, 1:2);
%     [ Een, Eex ] = ShadowEntryExit( rsun, Rer, a, ecc, incl, omega, argp, nu, mu );
%     enter_ex(i,1) = Een; enter_ex(i,2) = Eex;
% end
%hold on
plot(enter_ex)
hold on
plot3(xp, yp, zp, 'r-');
hold on
plot_Earth_meters();
% рисуем «емлю
% hold on
% plot3(rsun(1), rsun(2), rsun(3))

axis equal;
xlabel('X, м', 'FontSize',12,'FontWeight','bold','Color','b');
ylabel('Y, м', 'FontSize',12,'FontWeight','bold','Color','b');
zlabel('Z, м', 'FontSize',12,'FontWeight','bold','Color','b');

% x = linspace(1, 2, 100);
% y = linspace(-Rer, Rer);
% z = sqrt(Rer ^ 2 - y.^2);
% % z =( -x.*rsun(1) - y.*rsun(2)) / rsun(3)
% x = [x, x(end:-1:1)];
% y = [y, y(end:-1:1)];
% z = [z, -z];
% X = x.*cos(decl)-z.*sin(decl);
% Z = x.*sin(decl)+z.*cos(decl);
% hold on
% plot3(X, y, Z)
% 
% xn = linspace(0, 2*Rer, 100);
% 
% yn = linspace(0, 0, 100);
% zn = linspace(0, 0, 100);
% XN = xn.*cos(decl)-zn.*sin(decl);
% ZN = xn.*sin(decl)+zn.*cos(decl);
% hold on
% plot3(XN, yn, ZN)
% 
% xh = linspace(xn(end), xn(end) + 1, 100);
% yh = linspace(yn(end) - Rer, yn(end)+Rer);
% zh = sqrt(Rer ^ 2 - (yh-yn(end)).^2);
% xh = [xh, xh(end:-1:1)];
% yh = [yh, yh(end:-1:1)];
% zh = [zh, -zh];
% XH = xh.*cos(decl)-zh.*sin(decl);
% ZH = xh.*sin(decl)+zh.*cos(decl);
% 
% hold on
% plot3(XH, yh, ZH, 'r-')
% 
% x_l = double.empty(2, 0);
% y_l = double.empty(2, 0);
% z_l = double.empty(2, 0);
% for i=1:1:200
%     x_l(i, 1) = X(i);
%     x_l(i, 2) = XH(i);
%     y_l(i, 1) = y(i);
%     y_l(i, 2) = yh(i);
%     z_l(i, 1) = Z(i);
%     z_l(i, 2) = ZH(i);
% end
% hold on
% plot([x_l(1) x_l(2)])


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