%% simulation settings
simulationSettings = struct(...
  'simulationTime', 60, ... % [sec]
  'earthGravityModel', 'central', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'on', ...
  'atmosphereModel', 'off', ...
  'absTol', 10^-12, ...
  'relTol', 10^-12);

simulationSettings_sail = struct(...
  'simulationTime', 60, ... % [sec]
  'earthGravityModel', 'central', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'on', ...
  'atmosphereModel', 'off', ...
  'absTol', 10^-12, ...
  'relTol', 10^-12);
%% step 2 - spacecraft parameters
spacecraft = struct(...
  'mass', 3, ... % [kg]
  'dragCoefficient', 2.2, ... 
  'reflectivity', 1.3, ... % dimensionless
  'area', 0.03); % [m^2]

spacecraft_sail = struct(...
  'mass', 3, ... % [kg]
  'dragCoefficient', 2.2, ... 
  'reflectivity', 1.9, ... % dimensionless
  'area', 100); % [m^2]

%% step 3 - initial conditions
initialCondDate = datetime(2020, 04, 20, 19, 26, 49);
altitude = 800000;
inclination = pi/2;
LAN = 0; %longitude of the ascending node
ecc = 0; %eccentricity
AoP = 0; %argument of perigee

global EarthRadius;
global m2km; % meters -> kilometers
global EarthGravity;
 global direct;
direct=[];
% nu_delta = double.empty(1, 0);
% count = 1;

altitude_km = (EarthRadius + altitude) * m2km;

[r, v] = coe2rv( altitude_km, ecc, inclination, LAN, AoP, pi/360, pi/360);
rv = [r; v] / m2km;

[r_sail, v_sail] = coe2rv( altitude_km, ecc, inclination, LAN, AoP, 0, 0);
rv_sail = [r_sail; v_sail] / m2km;

rv_all = [rv; rv_sail];

Torb = 2 * pi * (EarthRadius + altitude)^(3/2) / sqrt(EarthGravity);
time_sim = (0:1:15*Torb);
% simulationSettings.simulationTime = Torb*24;
% simulationSettings_test.simulationTime = Torb*24;
trigger=0;
initialConditions = struct(...
  'date', initialCondDate, ...
  'coordinatesECI', rv_all);


%% step 4 - simulation
opts = odeset('RelTol',simulationSettings.relTol,'AbsTol', simulationSettings.absTol);

simulationResults = ode45(@(t, rv_all) rhs_sun(t, rv_all, simulationSettings, simulationSettings_sail,...
    initialConditions, spacecraft, spacecraft_sail, trigger), time_sim, rv_all, opts);  %results of both satillite


%% step 5 - postprocessing and visualisation
figureCoM = plotCoM_Torb( simulationResults);
