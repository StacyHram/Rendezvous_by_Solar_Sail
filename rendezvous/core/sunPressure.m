function [pressSun, isVisible] = sunPressure(rECI, vECI, sunECI, sunPressureModel, spacecraft)
  
  global SunPressure;
  global AstronomicUnit;
  global rad2deg;

  switch sunPressureModel
    
    case 'off'
      pressSun = [0; 0; 0];
      isVisible = 0;
      
    case 'on'
      isVisible = sight(sunECI / 1000, rECI / 1000, 'e');

      if isVisible
        direction_cos = dot(vecnorm(sunECI), vecnorm(vECI));
        if direction_cos < cos(170)
            pressSun = 1 / spacecraft.mass * spacecraft.area * spacecraft.reflectivity * SunPressure * AstronomicUnit^2 * ...
                   (sunECI - rECI) / norm(sunECI - rECI)^3 * direction_cos;
        else
            pressSun = [0; 0; 0];
        end
      else
        pressSun = [0; 0; 0];
      end
      
    otherwise
      error('Unknown Sun pressure model!');
  end

end

