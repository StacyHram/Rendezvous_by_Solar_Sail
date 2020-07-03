function figureCoM = plotCoM_Torb( simulationResults)

global EarthGravity;

r = simulationResults.y (1:3,:);
v = simulationResults.y(4:6, :);
r_test = simulationResults.y (7:9,:);
v_test = simulationResults.y (10:12,:);


delta = double.empty(1, 0);
for i = 1 : 1 : (size(r_test,2))
    d = vecnorm(r_test(:, i) - r(:, i));
    delta(1, i) = d;
end

delta_v = double.empty(1, 0);
for i = 1 : 1 : (size(r_test,2))
    d = vecnorm(v_test(:, i) - v(:, i));
    delta_v(1, i) = d;
end


figureCoM = figure;
% plot( simulationResults.x ,T, '-b');
% hold on
% plot( simulationResults_test.x, T_test, '-r.'); 
plot( simulationResults.x, delta);
hold on
plot( simulationResults.x, delta_v, '-r');

% plot( simulationResults.x, simulationResults.y(7, :));

end


% T = double.empty(1, 0); %elements on all orbit
%      for i=1:1:(size(rv,2))
%          Torb = 2 * pi * EarthGravity/(2 * EarthGravity/sqrt(rv(1, i)^2+ rv(2, i)^2 + ...
%              rv(3, i)^2) - sqrt(rv(4,i)^2+ rv(5, i)^2 + rv(6, i)^2) ^ 2) ^ 3/2;
%          T(1, i) = Torb;
%      end
% 
% T_test = double.empty(1, 0); %elements on all orbit
%      for i=1:1:(size(rv_test,2))
%         Torb = 2 * pi * EarthGravity/(2 * EarthGravity/sqrt(rv_test(1, i)^2+ rv_test(2, i)^2 +...
%             rv_test(3, i)^2) - sqrt(rv_test(4,i)^2+ rv_test(5, i)^2 + rv_test (6, i)^2) ^ 2) ^ 3/2;
%         T_test(1, i) = Torb;
%      end