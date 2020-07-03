function derivativeCoMCoordinates = rhs(t, rv_all, simulationSettings, simulationSettings_test,...
    initialConditions, spacecraft, spacecraft2)

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
  
  sunECI = [1;0;0] * AstronomicUnit;
  gSunECI = [0; 0; 0];
  
  direction_cos = dot(sunECI, vECI)/(vecnorm(vECI)*vecnorm(sunECI));
  direct = [direct; direction_cos];
  
%   if direction_cos < -0.999
%       [~, ~, ~, ~, ~, ~, nu_test, ~, ~, ~, ~] = rv2coe(rECI_test, vECI_test);
%   end
  
  
  %% Sun pressure
  nu =0;
  nu_test = 0;
  
  if (rECI(1)^2 + rECI(2)^2)^0.5 < 10000
      [~, ~, ~, ~, ~, ~, nu, ~, ~, ~, ~] = rv2coe(rECI, vECI);
      [~, ~, ~, ~, ~, ~, nu_test, ~, ~, ~, ~] = rv2coe(rECI_test, vECI_test);
      
  end
  
  
  
  
  [pressSun_test, ~] = sunPressure_test(rECI_test, vECI_test, sunECI, simulationSettings_test.sunPressureModel, spacecraft2);
  %[pressSun, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);

  delta = nu_test - nu;
  
  if delta >= 0.009
      b = 1
      [pressSun, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
  elseif delta < 0.009 && delta > 0.001 
      c = 2
      [pressSun, ~] = sunPressure_plus(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);
  else
      pressSun = [0; 0; 0];
  end
  
  


  
  
  %% Sum all
  
  derivativeCoMCoordinates(4:6,1) = gEarthECI + aECI + gSunECI + gMoonECI + pressSun;
  derivativeCoMCoordinates(10:12,1) = gEarthECI_test + aECI_test + gSunECI + gMoonECI + pressSun_test;


end

