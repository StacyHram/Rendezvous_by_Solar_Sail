function figureCoM = plotCoM_test( simulationResults, simulationResults_test)

figureCoM = figure;
plot( simulationResults.x, simulationResults.y(3, :), '-b');
hold on
plot( simulationResults_test.x, simulationResults_test.y(3, :), '-r'); 

end