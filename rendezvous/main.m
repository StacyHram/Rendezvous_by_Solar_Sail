%% simulation settings
simulationSettings = struct(...
  'simulationTime', 12000, ... % [sec]
  'earthGravityModel', 'centralPlusJ2', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'on', ...
  'atmosphereModel', 'exponential', ...
  'absTol', 10^-12, ...
  'relTol', 10^-12);

simulationSettings_test = struct(...
  'simulationTime', 12000, ... % [sec]
  'earthGravityModel', 'central', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'off', ...
  'atmosphereModel', 'off', ...
  'absTol', 10^-12, ...
  'relTol', 10^-12);
%% step 2 - spacecraft parameters
spacecraft = struct(...
  'mass', 3, ... % [kg]
  'dragCoefficient', 2.2, ... 
  'reflectivity', 1.3, ... % dimensionless
  'area', 0.3); % [m^2]

%% step 3 - initial conditions
initialCondDate = datetime(2020, 04, 20, 19, 26, 49);
altitude = 650000;
inclination = pi/2;

global EarthRadius;
global m2km; % meters -> kilometers
in_km = (EarthRadius + altitude)*m2km;

[r, v] = coe2rv( in_km, 0.000000046, inclination, 5,881760, 4,36332313, 0,383972);
rv = [r; v] / m2km;

initialConditions = struct(...
  'date', initialCondDate, ...
  'coordinatesECI', rv);

%% step 4 - simulation
opts = odeset('RelTol',simulationSettings.relTol,'AbsTol', simulationSettings.absTol);

simulationResults = ode45(@(t, rv) rhs(t, rv, simulationSettings, initialConditions, spacecraft), ...
                        [0 simulationSettings.simulationTime], rv, opts); 

simulationResults_test = ode45(@(t, rv) rhs(t, rv, simulationSettings_test, initialConditions, spacecraft), ...
                        [0 simulationSettings_test.simulationTime], rv, opts);
%% step 5 - postprocessing and visualisation
figureCoM = plotCoM(simulationResults, simulationResults_test);
