function derivativeCoMCoordinates = rhs_sun(t, rv_all, simulationSettings, simulationSettings_sail,...
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
  disp(direction_cos);
  
  Torb = 2 * pi * (sqrt(rECI(1)^2 + rECI(2)^2 + rECI(3)^2))^(3/2) / sqrt(EarthGravity);

  Torb_sail = 2 * pi * (sqrt(rECI_sail(1)^2 + rECI_sail(2)^2 + rECI_sail(3)^2))^(3/2) / sqrt(EarthGravity);
  
  
  if ang_distance < 0.0044 && ang_distance > 0.0005
          trigger = 1;
          
  elseif ang_distance < 0.0005
          trigger = 2;
  end 
  
  if trigger == 0 && direction_cos < -0.98 
      
      spacecraft_sail.area = 100;
      spacecraft_sail.reflectivity = 1.9;
      
  elseif trigger == 1 && direction_cos > 0.98
          spacecraft_sail.area = 100;
          spacecraft_sail.reflectivity = 1.9;
    
      
  else
      spacecraft_sail.area = 0.03;
      spacecraft_sail.reflectivity = 1.3;
  end
  
  
  
%   if trigger == 2; 
%       spacecraft_sail.area = 0.03
%       spacecraft_sail.reflectivity = 1.3
%   end
 
  [aSRP_sail, ~] = sunPressure_last(rECI_sail, vECI_sail, sunECI, simulationSettings_sail.sunPressureModel, spacecraft_sail);
  [aSRP, ~] = sunPressure_last(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);

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
  
  %% atmosphere
  wEarth = [0; 0; 7.29211514670698e-05];
  vRelativeECI = vECI - cross(wEarth, rECI);
  vRelativeECI_test = vECI_sail - cross(wEarth, rECI_sail);
  
  aECI = atmosphere(rECI, vRelativeECI, simulationSettings.atmosphereModel, spacecraft);
  aECI_sail = atmosphere(rECI_sail, vRelativeECI_test, simulationSettings_sail.atmosphereModel, spacecraft_sail);
  %% Sum all
  
  derivativeCoMCoordinates(4:6,1) = gEarthECI + aECI + gSunECI + gMoonECI + aSRP;
  derivativeCoMCoordinates(10:12,1) = gEarthECI_sail + aECI_sail + gSunECI + gMoonECI + aSRP_sail;
end