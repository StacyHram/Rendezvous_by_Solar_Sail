function derivativeCoMCoordinates = rhs(t, rv_all, simulationSettings, simulationSettings_test,...
    initialConditions, spacecraft, spacecraft2)

% Calculates right side of ODE for motion of single point (center of mass) motion

  %% constants
  global AstronomicUnit;
  global day2sec;
  global EarthGravity;


  %% coordinates
  
  rECI = rv_all(1:3);
  vECI = rv_all(4:6);
  rECI_test = rv_all(7:9);
  vECI_test = rv_all(10:12);
  
  %% differentials
  
  derivativeCoMCoordinates = zeros(12, 1);    
  derivativeCoMCoordinates(1:3) = vECI;
  derivativeCoMCoordinates(7:9) = vECI_test;
  
  %% date processing
  
  dateVector = datevec(initialConditions.date + t / day2sec);
  dateJulian = juliandate(dateVector);
    
  %% Earth gravitational force
  
  gEarthECI = gravityEarth(rECI, simulationSettings.earthGravityModel);
  gEarthECI_test = gravityEarth(rECI_test, simulationSettings_test.earthGravityModel);
  
  %% atmosphere
  wEarth = [0; 0; 7.29211514670698e-05];
  vRelativeECI = vECI - cross(wEarth, rECI);
  vRelativeECI_test = vECI_test - cross(wEarth, rECI_test);
  
  aECI = atmosphere(rECI, vRelativeECI, simulationSettings.atmosphereModel, spacecraft);
  aECI_test = atmosphere(rECI_test, vRelativeECI_test, simulationSettings_test.atmosphereModel, spacecraft2);
  
  %% Moon gravity
  
  gMoonECI = [0; 0; 0];

  %% Sun gravity
  
  sunECI = sun(dateJulian)' * AstronomicUnit;
  gSunECI = [0; 0; 0];
  
  %% Sun pressure
  [pressSun_test, ~] = sunPressure_test(rECI_test, vECI_test, sunECI, simulationSettings_test.sunPressureModel, spacecraft2);
  [pressSun, ~] = sunPressure_plus(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
%   d = vecnorm(rECI_test - rECI);
%   if d > 3895000 && d < 1000
%       [pressSun, ~] = sunPressure_plus(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
%   else
%       [pressSun, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
%   end
  
  %% Sum all
  
  derivativeCoMCoordinates(4:6) = gEarthECI + aECI + gSunECI + gMoonECI + pressSun;
  derivativeCoMCoordinates(10:12) = gEarthECI_test + aECI_test + gSunECI + gMoonECI + pressSun_test;


end

