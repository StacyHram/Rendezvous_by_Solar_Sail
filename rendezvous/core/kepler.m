function dx = kepler(t, x)
%������� ���������� ������ ����� ���������������� ��������� ������������ ��������
%�������� � ���� ������� ����� (������������ �� J2; �������� J3 � J4 ����������������)

% ������ ����� - ������ ��� Matlab � ����� ������� �������� ���������� (��. ��������� � ������� �������)

%%����������� ��������
mu = 3.986004415e14; % [m^3 / (kg * s^2)]
J2 = 1.082636023e-03;
J3 = -2.532435e-06;
J4 = -1.619331e-06;
EarthRadius = 6371009; % [m]

%%���������� ��������������� �������
r = norm(x(1:3)); 
rr = (r/EarthRadius);
dx = zeros(6,1); 

%% ����������� ������ ������ ���. ��������� �� �������� ������� ��������� x
dx(1) = x(4);
dx(2) = x(5);
dx(3) = x(6);
dx(4) = -mu * x(1) * (1 + 1.5 * J2 * rr^2 * (1 - 5 * (x(3)/r)^2)) / r^3;
dx(5) = -mu * x(2) * (1 + 1.5 * J2 * rr^2 * (1 - 5 * (x(3)/r)^2)) / r^3;
dx(6) = -mu * x(3) * (1 + 1.5 * J2 * rr^2 * (3 - 5 * (x(3)/r)^2)) / r^3;
end
% dx(4) = -mu * x(1) * (1 + 1.5 * J2 * rr^2 * (1 - 5 * (x(3)/r)^2) + 2.5 * J3 * rr^3 * (3 - 7 * (x(3)/r)^2) * (x(3)/r) - 0.625 * J4 * rr^4 *(3 - 42 * (x(3)/r)^2 + 63 * (x(3)/r)^4)) / r^3;
% dx(5) = -mu * x(2) * (1 + 1.5 * J2 * rr^2 * (1 - 5 * (x(3)/r)^2) + 2.5 * J3 * rr^3 * (3 - 7 * (x(3)/r)^2) * (x(3)/r) - 0.625 * J4 * rr^4 *(3 - 42 * (x(3)/r)^2 + 63 * (x(3)/r)^4)) / r^3;
% dx(6) = -mu * x(3) * (1 + 1.5 * J2 * rr^2 * (3 - 5 * (x(3)/r)^2) + 2.5 * J3 * rr^3 * (6 - 7 * (x(3)/r)^2) * (x(3)/r)) / r^3 + ...
%          mu * 1.5 * J3 * rr^3 / r^2 + mu * x(3) * 0.625 * J4 * rr^4 * (15 - 70 * (x(3)/r)^2 + 63 * (x(3)/r)^4) / r^3 ;

