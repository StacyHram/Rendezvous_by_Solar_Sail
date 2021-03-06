function figureCoM = plotCoM_Torb( simulationResults)

global EarthGravity;
global m2km;

r = simulationResults.y (1:3,:);
v = simulationResults.y(4:6, :);
r_sail = simulationResults.y (7:9,:);
v_sail = simulationResults.y (10:12,:);



delta = double.empty(1, 0);
for i = 1 : 1 : (size(r_sail,2))
    d = vecnorm(r_sail(:, i) - r(:, i));
    delta(1, i) = d/1000;
end

delta_v = double.empty(1, 0);
for i = 1 : 1 : (size(r_sail,2))
    d = vecnorm(v_sail(:, i) - v(:, i));
    delta_v(1, i) = d/1000;
end


figureCoM = figure;
% plot( simulationResults.x ,T, '-b');
% hold on
% plot( simulationResults_test.x, T_test, '-r.'); 
plot( simulationResults.x/60, delta);
xlabel('�����, ���');
ylabel('����������, ��')
figure; plot( simulationResults.x/60, delta_v, '-r');
xlabel('�����, ���');
ylabel('������� ���������, ��');

% plot( simulationResults.x, simulationResults.y(7, :));
% T = double.empty(1, 0); %elements on all orbit
%      for i=1:1:(size(r,2))
%          Torb = 2 * pi * (sqrt(r(1, i)^2 + r(2, i)^2 + r(3, i)^2))^(3/2) / sqrt(EarthGravity);
% 
%          T(1, i) = Torb;
%      end
% 
% T_sail = double.empty(1, 0); %elements on all orbit
%      for i=1:1:(size(r_sail,2))
%         Torb = 2 * pi * (sqrt(r_sail(1, i)^2 + r_sail(2, i)^2 + r_sail(3, i)^2))^(3/2) / sqrt(EarthGravity);
% 
%         T_sail(1, i) = Torb;
%      end
%      
% figure;
% plot(T, 'r.');
% hold on
% plot(T_sail, 'g-');


end


