function figureCoM = plotCoM(simulationResults)
 
figureCoM = plot_Earth_meters ();% рисуем Землю
axis equal
hold on
plot3(simulationResults.y(1, :), simulationResults.y(2, :), simulationResults.y(3, :) );
% hold on
% plot3(simulationResults_test.y(1, :), simulationResults_test.y(2, :), simulationResults_test.y(3, :) );

end
