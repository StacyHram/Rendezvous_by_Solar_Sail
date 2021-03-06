%% simulation settings
simulationSettings = struct(...
  'simulationTime', 60, ... % [sec]
  'earthGravityModel', 'central', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'on', ...
  'atmosphereModel', 'exponential', ...
  'absTol', 10^-12, ...
  'relTol', 10^-12);

simulationSettings_test = struct(...
  'simulationTime', 60, ... % [sec]
  'earthGravityModel', 'central', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'off', ...
  'atmosphereModel', 'exponential', ...
  'absTol', 10^-12, ...
  'relTol', 10^-12);
%% step 2 - spacecraft parameters
spacecraft = struct(...
  'mass', 3, ... % [kg]
  'dragCoefficient', 2.2, ... 
  'reflectivity', 1.95, ... % dimensionless
  'area', 100); % [m^2]

spacecraft2 = struct(...
  'mass', 3, ... % [kg]
  'dragCoefficient', 2.2, ... 
  'reflectivity', 1.3, ... % dimensionless
  'area', 0.3); % [m^2]
%% step 3 - initial conditions
initialCondDate = datetime(2020, 04, 20, 19, 26, 49);
altitude = 800000;
inclination = pi/2;

global EarthRadius;
global m2km; % meters -> kilometers
global EarthGravity;
 global direct;
direct=[];
% nu_delta = double.empty(1, 0);
% count = 1;


in_km = (EarthRadius + altitude)*m2km;

[r_test, v_test] = coe2rv( in_km, 0.000000046*0, inclination, pi, 4.36332313*0, pi/2, pi/2);
rv_test = [r_test; v_test] / m2km

[r, v] = coe2rv( in_km, 0.000000046*0, inclination, pi, 4.36332313*0, 0,0);
rv = [r; v] / m2km


rv_all = [rv; rv_test];

Torb = 2 * pi * (EarthRadius + altitude)^(3/2) / sqrt(EarthGravity);
time_sim = (0:1:6400);
% simulationSettings.simulationTime = Torb*24;
% simulationSettings_test.simulationTime = Torb*24;

initialConditions = struct(...
  'date', initialCondDate, ...
  'coordinatesECI', rv_all);


%% step 4 - simulation
opts = odeset('RelTol',simulationSettings.relTol,'AbsTol', simulationSettings.absTol);



simulationResults = ode45(@(t, rv_all) rhs(t, rv_all, simulationSettings, simulationSettings_test,...
    initialConditions, spacecraft, spacecraft2), time_sim, rv_all, opts);  %results of both satillite


%% step 5 - postprocessing and visualisation
figureCoM = plotCoM( simulationResults, nu_delta);
