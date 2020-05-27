function figureCoM = plotCoM_elements( simulationResults, simulationResults_test)

global m2km;

rv = simulationResults.y;
rv_test = simulationResults_test.y;
elements = double.empty(2664, 0); %elements on all orbit
 for i=1:1:(size(rv))
     rv(1:6, i);
     [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(rv(1:3, i) * m2km, rv(4:6, i) * m2km);
     elements(1, i) = a 
     elements(2, i) = ecc; elements(3, i) = incl;
     elements(4, i) = omega; elements(5, i) = argp; elements(6, i) = nu;
 end

 elements_test = double.empty(2666, 0); %elements on all orbit
 for i=1:1:(size(rv_test))
     rv_test(1:6, i);
     [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(rv(1:3, i) * m2km, rv(4:6, i) * m2km);
     elements_test(1, i) = a 
     elements_test(2, i) = ecc; elements_test(3, i) = incl;
     elements_test(4, i) = omega; elements_test(5, i) = argp; elements_test(6, i) = nu;
 end
 
figureCoM = figure;
plot( simulationResults.x, elements(1:2664, 1), '-b');
hold on
plot( simulationResults_test.x, elements_test(1:2666, 1), '-r'); 

end