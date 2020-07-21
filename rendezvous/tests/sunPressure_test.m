function [pressSun_test, isVisible] = sunPressure_test(rECI, vECI, sunECI, sunPressureModel, spacecraft)
  
  global SunPressure;
  global AstronomicUnit;
  global deg2rad;

  switch sunPressureModel
    
    case 'off'
      pressSun_test = [0; 0; 0];
      isVisible = 0;
      
    case 'on'
      isVisible = sight(sunECI / 1000, rECI / 1000, 'e');

      if isVisible
          pressSun_test = 1 / spacecraft.mass * spacecraft.area * spacecraft.reflectivity * SunPressure * AstronomicUnit^2 * ...
                   (sunECI - rECI) / norm(sunECI - rECI)^3 ;
       
      else
        pressSun_test = [0; 0; 0];
      end
      
    otherwise
      error('Unknown Sun pressure model!');
  end

end

