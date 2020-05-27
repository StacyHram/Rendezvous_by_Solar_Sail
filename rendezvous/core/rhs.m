function derivativeCoMCoordinates = rhs(t, rv, simulationSettings, initialConditions, spacecraft)

% Calculates right side of ODE for motion of single point (center of mass) motion

  %% constants
  global AstronomicUnit;
  global day2sec;
  global EarthGravity;


  %% coordinates
  
  rECI = rv(1:3);
  vECI = rv(4:6);
  
  %% differentials
  
  derivativeCoMCoordinates = zeros(6, 1);    
  derivativeCoMCoordinates(1:3) = vECI;
  
  %% date processing
  
  dateVector = datevec(initialConditions.date + t / day2sec);
  dateJulian = juliandate(dateVector);
    
  %% Earth gravitational force
  
  gEarthECI = gravityEarth(rECI, simulationSettings.earthGravityModel);  
  
  %% atmosphere
  wEarth = [0; 0; 7.29211514670698e-05];
  vRelativeECI = vECI - cross(wEarth, rECI);
  
  aECI = atmosphere(rECI, vRelativeECI, simulationSettings.atmosphereModel, spacecraft);
  
  %% Moon gravity
  
  gMoonECI = [0; 0; 0];

  %% Sun gravity
  
  sunECI = sun(dateJulian)' * AstronomicUnit;
  gSunECI = [0; 0; 0];
  
  %% Sun pressure
  
  [pressSun, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
    
  %% Sum all
  
  derivativeCoMCoordinates(4:6) = gEarthECI + aECI + gSunECI + gMoonECI + pressSun;

end

