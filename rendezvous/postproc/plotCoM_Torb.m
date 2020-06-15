function figureCoM = plotCoM_Torb( simulationResults)


Torb = 2 * pi * EarthGravity/(2 * EarthGravity/sqrt(r(1, 1)^2+ r(2, 1)^2 +...
    r(3, 1)^2) - sqrt(v(1, 1)^2+ v(2, 1)^2 + v(3, 1)^2) ^ 2) ^ 3/2;
figureCoM = figure;
plot( simulationResults,Torb, '-b');
%hold on
%plot( simulationResults_test.x, simulationResults_test.y(3, :), '-r'); 

end