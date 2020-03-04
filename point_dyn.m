function point_dyn()
global mu

mu = 3.986 * 10^14;

x0 = 600; y0 = 400; z0 = 0;
vx0 = 8; vy0 = -8; vz0 = 4;

[tp, hp] = ode45(@point_calculate, [0 4000], [x0; y0; z0; vx0; vy0; vz0]);
xp = hp(:,1); yp = hp(:,2); zp = hp(:,3);

[tn, hn] = ode45(@point_calculate, [4000 0], [x0; y0; z0; vx0; vy0; vz0]);
xn = hn(:,1); yn = hn(:,2); zn = hn(:,3);

xn = transpose(xn);
xp = rot90(rot90(transpose(xp)));
yn = transpose(yn);
yp = rot90(rot90(transpose(yp)));
zn = transpose(zn);
zp = rot90(rot90(transpose(zp)));

x = [xn, xp];
y = [yn, yp];
z = [zn, zp];


plot3(x, y, z, 'r-');
end