function figureCoM = plotCoM(simulationResults)
 
figureCoM = plot_Earth_meters ();% ������ �����
axis equal
hold on
plot3(simulationResults.y(1, :), simulationResults.y(2, :), simulationResults.y(3, :) );


end
