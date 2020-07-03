function figureCoM = plotCoM(simulationResults, nu_delta)
 

sq = simulationResults.y(1, :).^2 + simulationResults.y(2, :).^2;

figure;
plot(sq);

figureCoM = plot_Earth_meters ();% рисуем Землю
axis equal
hold on
plot3(simulationResults.y(1, :), simulationResults.y(2, :), simulationResults.y(3, :) );
hold on
plot3(simulationResults.y(7, :), simulationResults.y(8, :), simulationResults.y(9, :) );
figure;
plot(nu_delta);
% hold on
% plot3(simulationResults_test.y(1, :), simulationResults_test.y(2, :), simulationResults_test.y(3, :) );

end
