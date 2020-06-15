%% simulation settings
simulationSettings = struct(...
  'simulationTime', 60, ... % [sec]
  'earthGravityModel', 'centralPlusJ2', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'on', ...
  'atmosphereModel', 'exponential', ...
  'absTol', 10^-10, ...
  'relTol', 10^-10);

simulationSettings_test = struct(...
  'simulationTime', 60, ... % [sec]
  'earthGravityModel', 'centralPlusJ2', ...
  'sunGravityModel', 'off', ...
  'moonGravityModel', 'off', ...
  'sunPressureModel', 'off', ...
  'atmosphereModel', 'exponential', ...
  'absTol', 10^-10, ...
  'relTol', 10^-10);
%% step 2 - spacecraft parameters
spacecraft = struct(...
  'mass', 3, ... % [kg]
  'dragCoefficient', 2.2, ... 
  'reflectivity', 1.5, ... % dimensionless
  'area', 300); % [m^2]

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

in_km = (EarthRadius + altitude)*m2km;

[r, v] = coe2rv( in_km, 0.000000046, inclination, 5,881760, 4,36332313, 0,383972);
rv = [r; v] / m2km;
r_test = [1526972.59899351; -5161953.72250970; 4737722.63950587];
v_test = [-1396.93459242548; 4722.35965818830; 5595.60586682747];
Torb = 2 * pi * (EarthRadius + altitude)^(3/2) / sqrt(EarthGravity);
simulationSettings.simulationTime = Torb*24;
simulationSettings_test.simulationTime = Torb*24;

initialConditions = struct(...
  'date', initialCondDate, ...
  'coordinatesECI', rv);

%% step 4 - simulation
opts = odeset('RelTol',simulationSettings.relTol,'AbsTol', simulationSettings.absTol);

simulationResults = ode45(@(t, rv) rhs(t, rv, simulationSettings, initialConditions, spacecraft), ...
                        [0 simulationSettings.simulationTime], rv, opts); 

simulationResults_test = ode45(@(t, rv) rhs(t, rv, simulationSettings_test, initialConditions, spacecraft2), ...
                        [0 simulationSettings_test.simulationTime], rv, opts);

%% step 5 - postprocessing and visualisation
figureCoM = plotCoM_elements( simulationResults, simulationResults_test);
