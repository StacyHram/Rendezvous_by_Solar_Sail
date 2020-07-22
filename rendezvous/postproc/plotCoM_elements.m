function figureCoM = plotCoM_elements( simulationResults)

global m2km;

rv = simulationResults.y(1:6, :);
rv_sail = simulationResults.y(7:12, :);

elements = double.empty(6, 0); %elements on all orbit
     for i=1:1:(size(rv,2))
         [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(rv(1:3, i) * m2km, rv(4:6, i) * m2km);
         elements(1, i) = a; 
         elements(2, i) = ecc; elements(3, i) = incl;
         elements(4, i) = omega; elements(5, i) = argp; elements(6, i) = nu;
     end

elements_test = double.empty(6, 0); %elements on all orbit
     for i=1:1:(size(rv_sail,2))
         [p, a, ecc, incl, omega, argp, nu, ~, ~, ~, ~] = rv2coe(rv_sail(1:3, i) * m2km, rv_sail(4:6, i) * m2km);
         elements_test(1, i) = a; 
         elements_test(2, i) = ecc; elements_test(3, i) = incl;
         elements_test(4, i) = omega; elements_test(5, i) = argp; elements_test(6, i) = nu;
     end
 
     
     
% figureCoM = figure;
% plot( simulationResults.x/60, elements(5, :), '-b');
% hold on
% plot( simulationResults.x/60, elements_test(5, :), '-r'); 
% xlabel ('Время, мин')
% ylabel ('Долгота восходящего узла, рад')

figureCoM = figure;
plot( simulationResults.x/60, elements(1, :), '-b');
hold on
plot( simulationResults.x/60, elements_test(1, :), '-r'); 
xlabel ('Время, мин')
ylabel ('Большая полуось, км')

figureCoM = figure;
plot( simulationResults.x/60, elements(2, :), '-b');
hold on
plot( simulationResults.x/60, elements_test(2, :), '-r'); 
xlabel ('Время, мин')
ylabel ('Эксцентриситет')

end