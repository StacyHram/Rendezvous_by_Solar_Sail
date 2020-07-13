function derivativeCoMCoordinates = rhs(t, rv_all, simulationSettings, simulationSettings_sail,...
    initialConditions, spacecraft, spacecraft_sail, trigger)

% Calculates right side of ODE for motion of single point (center of mass) motion

  %% constants
  global AstronomicUnit;
  global day2sec;
  global EarthGravity;
  global m2km;
  global direct;


  %% coordinates
  
  rECI = rv_all(1:3);
  vECI = rv_all(4:6);
  rECI_sail = rv_all(7:9);
  vECI_sail = rv_all(10:12);
  
  %% differentials 
  
  derivativeCoMCoordinates = zeros(12, 1);    
  derivativeCoMCoordinates(1:3) = vECI;
  derivativeCoMCoordinates(7:9) = vECI_sail;
  
  %% date processing
  
  dateVector = datevec(initialConditions.date + t / day2sec);
  dateJulian = juliandate(dateVector);
    
  %% Earth gravitational force
  
  gEarthECI = gravityEarth(rECI, simulationSettings.earthGravityModel);
  gEarthECI_sail = gravityEarth(rECI_sail, simulationSettings_sail.earthGravityModel);
  
  %% atmosphere
  wEarth = [0; 0; 7.29211514670698e-05];
  vRelativeECI = vECI - cross(wEarth, rECI);
  vRelativeECI_test = vECI_sail - cross(wEarth, rECI_sail);
  
  aECI = atmosphere(rECI, vRelativeECI, simulationSettings.atmosphereModel, spacecraft);
  aECI_sail = atmosphere(rECI_sail, vRelativeECI_test, simulationSettings_sail.atmosphereModel, spacecraft_sail);
  
  %% Moon gravity
  
  gMoonECI = [0; 0; 0];

  %% Sun gravity
  
  sunECI = [1;0;0] * AstronomicUnit;
  gSunECI = [0; 0; 0]; 
  
  %% Sun pressure

  direction_cos = dot(sunECI, vECI_sail)/(vecnorm(vECI_sail)*vecnorm(sunECI));
  %direct = [direct; direction_cos];
  ang_distance = acos(dot(rECI, rECI_sail)/(vecnorm(rECI)*vecnorm(rECI_sail)));
  disp(ang_distance);
  
   
  
  if trigger == 0 && direction_cos < -0.82   
      
      spacecraft_sail.area = 100;
  else
      spacecraft_sail.area = 0.03;
  end
  
  if ang_distance < 0.00044 
      
      trigger = 1;
  end
  
  if trigger == 1 && direction_cos > 0.82
      spacecraft_sail.area = 100
  else
      spacecraft_sail.area = 0.03;
  end
  
   
  if ang_distance < 0.0001
      trigger = 2; 
      gt = 3
      spacecraft_sail.area = 0.03
  end
 
  [aSRP_sail, ~] = sunPressure(rECI_sail, vECI_sail, sunECI, simulationSettings_sail.sunPressureModel, spacecraft_sail);
  [aSRP, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);

  %delta = nu - nu_sail;
  
  %if delta >= 0.009
  %    b = 1
  %    [pressSun, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
  %elseif delta < 0.009 && delta > 0.001 
  %    c = 2
  %    [pressSun, ~] = sunPressure_plus(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
  %else
  %    pressSun = [0; 0; 0];
  %end 
  
  %% Sum all
  
  derivativeCoMCoordinates(4:6,1) = gEarthECI + aECI + gSunECI + gMoonECI + aSRP;
  derivativeCoMCoordinates(10:12,1) = gEarthECI_sail + aECI_sail + gSunECI + gMoonECI + aSRP_sail;
end