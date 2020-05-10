function gECEF = gravityEarth(rECEF, earthGravityModel)
% Computes acceleration due to Earth's gravity 

  global EarthGravity; 
  global EarthRadius;% [m]
  global m2km;
  J2 = 1.082636023e-03;
  
  switch earthGravityModel
    case 'off'
      gECEF = zeros(3, 1);
      
    case 'central'
      gECEF = -EarthGravity * rECEF / norm(rECEF)^3;
      
    case 'centralPlusJ2'
        gECEF = zeros(3, 1);
    
        r = norm(rECEF); 
        rr = (r/EarthRadius);
    
        ax = -EarthGravity * rECEF(1) * (1 + 1.5 * J2 * rr^2 * (1 - 5 * (rECEF(3)/r)^2)) / r^3;
        ay = -EarthGravity * rECEF(2) * (1 + 1.5 * J2 * rr^2 * (1 - 5 * (rECEF(3)/r)^2)) / r^3;
        az = -EarthGravity * rECEF(3) * (1 + 1.5 * J2 * rr^2 * (3 - 5 * (rECEF(3)/r)^2)) / r^3;
        gECEF(1, 1) = ax; gECEF(2,1) = ay; gECEF(3, 1) = az; %add J2 equations
           
    otherwise
      error('Unknown gravity model!');
  end
end
