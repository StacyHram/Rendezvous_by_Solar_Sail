function derivativeCoMCoordinates = rhs(t, rv, rv_test, simulationSettings, simulationSettings_test,...
    initialConditions, spacecraft, spacecraft2)

% Calculates right side of ODE for motion of single point (center of mass) motion

  %% constants
  global AstronomicUnit;
  global day2sec;
  global EarthGravity;


  %% coordinates
  
  rECI = rv(1:3);
  vECI = rv(4:6);
  rECI_test = rv_test(1:3);
  vECI_test = rv_test(4:6);
  
  %% differentials
  
  derivativeCoMCoordinates = zeros(6, 1);    
  derivativeCoMCoordinates(1:3) = vECI;
  derivativeCoMCoordinates_test = zeros(6, 1);    
  derivativeCoMCoordinates_test(1:3) = vECI_test;
  
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
  
  [pressSun, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
  [pressSun_test, ~] = sunPressure_test(rECI_test, vECI_test, sunECI, simulationSettings_test.sunPressureModel, spacecraft2);
    
  %% Sum all
  
  derivativeCoMCoordinates(4:6) = gEarthECI + aECI + gSunECI + gMoonECI + pressSun;
  derivativeCoMCoordinates_test(4:6) = gEarthECI_test + aECI_test + gSunECI + gMoonECI + pressSun_test;


end

