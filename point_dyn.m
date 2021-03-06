function point_dyn()
global  Rer gm
mu = 3.986 * 1e14;
gm = 5972e24;
alt = 600;
Rer = 6371;
pi2 = 2*pi;
mean_motion = sqrt(mu/(Rer+alt)^3);
p = (Rer + alt) * 10 ^ (-3);
ecc = 0.002;
incl = deg2rad(98);
omega = 0;
argp = deg2rad(98);


Torb = 2 *pi / mean_motion;

x0 = 2462; y0 = -3289; z0 = 5671;
vx0 = -3.5; vy0 = x0*mean_motion; vz0 = 4.6;

[tp, hp] = ode45(@point_calculate, [0 Torb], [x0; y0; z0; vx0; vy0; vz0]);
xp = hp(:,1); yp = hp(:,2); zp = hp(:,3); vxp = hp(:,4); vyp = hp(:,5); vzp = hp(:,6);

% [x1, x1i] = min(xp);
% [x2, x2i] = max(xp);
% 
% [y1, y1i] = min(yp);
% [y2, y2i] = max(yp);
% 
% b = sqrt((x2 - x1) ^ 2 + (yp(x2i) - yp(x1i)) ^ 2) / 2;
% a = sqrt((xp(y2i) - xp(y1i)) ^ 2 + (y2 - y1) ^ 2) / 2;
% p =  b ^ 2 / a;
% e = sqrt(1 - p / a);
% 
% h = zeros(282, 3);
% hk = zeros(282, 1);
% incl = zeros(282, 1);
% n = zeros(282, 3);
% omega = zeros(282, 1);
% 
% for i = 1:1:size(xp)
% 
%     h(i, 1:3)  = cross([xp(i); yp(i); zp(i)], [vxp(i), vyp(i), vzp(i)]);
%     hk(i, 1) = h(i, 3) / mag(h(i, 1:3));
%     incl(i) = rad2deg(acos(hk(i)));
%     k = [0, 0, 1];
%     n(i, 1:3) = cross(k(1:3), h(i, 1:3));
%     if(n(i, 2) >= 0)
%         omega(i) = acos(n(i, 1) / (sqrt(n(i, 2) ^ 2 + n(i, 1) ^ 2)));
%     else
%         omega(i) = 2 * pi - acos(n(i, 1) / (sqrt(n(i, 2) ^ 2 + n(i, 1) ^ 2)));
%     end
%     
%     if(n(i, 2) >= 0)
%         omega(i) = acos(n(i, 1) / (sqrt(n(i, 2) ^ 2 + n(i, 1) ^ 2)));
%     else
%         omega(i) = 2 * pi - acos(n(i, 1) / (sqrt(n(i, 2) ^ 2 + n(i, 1) ^ 2)));
%     end
% =======
%    
%     res(i, 1:2) = test;
% >>>>>>> Stashed changes
% end
% 
% 
% 


axis equal;

plot3(xp, yp, zp, 'r-');

end