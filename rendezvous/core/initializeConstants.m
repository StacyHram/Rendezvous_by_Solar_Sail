global EarthGravity;
EarthGravity = 3.986004415e14; % [m^3 / (kg * s^2)]

global EarthRadius;
EarthRadius = 6371009; % [m]

global EarthEquatorialRadius;
EarthEquatorialRadius = 6.378136300e6; % [m]

global MoonGravity;
MoonGravity = 4902.801 * 10^9; % [m^3 / (kg * s^2)]

global SunGravity;
SunGravity = 132712440017.987 * 10^9; % [m^3 / (kg * s^2)]

global SunPressure;
SunPressure = 4.56 * 10^-6; % [N / m^2]

global AstronomicUnit;
AstronomicUnit = 149597870691; % [m]

global rad2deg; % radian -> degress
rad2deg = 180 / pi;

global deg2rad; % degrees -> radian
deg2rad = pi / 180;

global rad2sec; % radians -> seconds
rad2sec = pi / (180.0 * 3600.0);

global day2sec; % days -> seconds
day2sec = 24 * 60 * 60;

global year2sec; % years -> seconds
year2sec = 365 * day2sec;

global m2km; % meters -> kilometers
m2km = 0.001;

global JULIAN_DATE_TO_1950
JULIAN_DATE_TO_1950 = 2433282.0; % [days]

global JD_OF_1997_JAN_1; % [days]
JD_OF_1997_JAN_1 = 2450450.0;

global modifiedJDStart; % [days]
modifiedJDStart = 2400000.5;