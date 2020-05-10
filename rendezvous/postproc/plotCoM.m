function figureCoM = plotCoM(simulationResults, simulationResults_test)
 
figureCoM = plot_Earth_meters ();% рисуем Землю
axis equal
hold on
plot3(simulationResults.y(1, :), simulationResults.y(2, :), simulationResults.y(3, :) );
figure;
plot( simulationResults.x, simulationResults.y(1, :), '-b');
hold on
plot( simulationResults_test.x, simulationResults_test.y(1, :), '-r'); 

end
