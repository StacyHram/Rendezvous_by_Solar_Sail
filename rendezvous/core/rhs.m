function derivativeCoMCoordinates = rhs(t, rv_all, simulationSettings, simulationSettings_sail,...
    initialConditions, spacecraft, spacecraft_sail)

% Calculates right side of ODE for motion of single point (center of mass) motion

  %% constants
  global AstronomicUnit;
  global day2sec;
  global EarthGravity;
  global deg2rad;
  global direct;
  global ctrl_settings;

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
  
  sunECI = [1; 0; 0] * AstronomicUnit;
  gSunECI = [0; 0; 0]; 
  
  %% Sun pressure

  direction_cos = dot(sunECI, vECI_sail)/(vecnorm(vECI_sail)*vecnorm(sunECI));

  Torb = 2 * pi * sqrt(vecnorm(rECI)^3 / EarthGravity);
  Torb_sail = 2 * pi * sqrt(vecnorm(rECI_sail)^3 / EarthGravity);
    
  if direction_cos < ctrl_settings.ctrl_arc_bound_cos  

    ang_distance = acos(dot(rECI, rECI_sail)/(vecnorm(rECI)*vecnorm(rECI_sail)));
    disp(ang_distance);
    disp(ctrl_settings.ctrl_phase);      
    disp(t / Torb);
    
    if ang_distance < ctrl_settings.ang_tolerance
        ctrl_settings.ctrl_phase = 'cpNone';
    elseif strcmp(ctrl_settings.ctrl_phase, 'cpNone')
        ctrl_settings.ctrl_phase = 'cpNone';
    elseif ang_distance < ctrl_settings.ini_ang_dist/1.8
        ctrl_settings.ctrl_phase = 'cpAcc';        
    else
        ctrl_settings.ctrl_phase = 'cpDec';
    end      
      
      switch ctrl_settings.ctrl_phase
          case 'cpDec'
      
            spacecraft_sail.area = 100;
            spacecraft_sail.reflectivity = 1;
          
          case 'cpAcc'
            spacecraft_sail.area = 100;
            spacecraft_sail.reflectivity = 1.91;
            
          
          otherwise
            spacecraft_sail.area = 0.03;
            spacecraft_sail.reflectivity = 1.3; 
            
      end
  end
 
  
  [aSRP_sail, ~] = sunPressure(rECI_sail, vECI_sail, sunECI, simulationSettings_sail.sunPressureModel, spacecraft_sail);
  [aSRP, ~] = sunPressure(rECI, vECI, sunECI, simulationSettings.sunPressureModel, spacecraft);

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