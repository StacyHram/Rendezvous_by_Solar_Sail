function figureCoM = plotCoM_test( simulationResults)
figureCoM = figure;
plot( simulationResults.y(), simulationResults.y(3, :), '-b');
hold on
plot( simulationResults_test.x, simulationResults_test.y(3, :), '-r'); 

end