function figureCoM = plotCoM_elements( simulationResults, simulationResults_test)

global m2km;

rv = simulationResults.y;
rv_test = simulationResults_test.y;

elements = double.empty(6, 0); %elements on all orbit
     for i=1:1:(size(rv,2))
         [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(rv(1:3, i) * m2km, rv(4:6, i) * m2km);
         elements(i, 1) = a; 
         elements(i, 2) = ecc; elements(i, 3) = incl;
         elements(i, 4) = omega; elements(i, 5) = argp; elements(i, 6) = nu;
     end

elements_test = double.empty(6, 0); %elements on all orbit
     for i=1:1:(size(rv_test,2))
         [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(rv_test(1:3, i) * m2km, rv_test(4:6, i) * m2km);
         elements_test(i, 1) = a; 
         elements_test(i, 2) = ecc; elements_test(i, 3) = incl;
         elements_test(i, 4) = omega; elements_test(i, 5) = argp; elements_test(i, 6) = nu;
     end
 
figureCoM = figure;
plot( elements(:, 2), '-b');
hold on
plot( elements_test(:, 2), '-r'); 

end