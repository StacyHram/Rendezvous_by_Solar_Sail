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
    delta(1, i) = d;
end

delta_v = double.empty(1, 0);
for i = 1 : 1 : (size(r_sail,2))
    d = vecnorm(v_sail(:, i) - v(:, i));
    delta_v(1, i) = d;
end


figureCoM = figure;
% plot( simulationResults.x ,T, '-b');
% hold on
% plot( simulationResults_test.x, T_test, '-r.'); 
plot( simulationResults.x, delta);
figure; plot( simulationResults.x, delta_v, '-r');

% plot( simulationResults.x, simulationResults.y(7, :));
T = double.empty(1, 0); %elements on all orbit
     for i=1:1:(size(r,2))
         Torb = 2 * pi * EarthGravity/(2 * EarthGravity/sqrt(r(1, i)^2+ r(2, i)^2 + ...
             r(3, i)^2) - sqrt(v(1,i)^2+ v(2, i)^2 + v(3, i)^2) ^ 2) ^ 3/2;
         T(1, i) = Torb;
     end

T_sail = double.empty(1, 0); %elements on all orbit
     for i=1:1:(size(r_sail,2))
        Torb = 2 * pi * EarthGravity/(2 * EarthGravity/sqrt(r_sail(1, i)^2+ r_sail(2, i)^2 +...
            r_sail(3, i)^2) - sqrt(v_sail(1,i)^2+ v_sail(2, i)^2 + v_sail (3, i)^2) ^ 2) ^ 3/2;
        T_sail(1, i) = Torb;
     end
     
figure;
plot(T);
hold on
plot(T_sail, 'g.');

% [p, a, ecc, incl, argp, lan, nu] = [r, v]*m2km;
% [p_sail, a_sail, ecc_sail, incl_sail, argp_sail, lan_sail, nu_sail] = [r_sail, v_sail]* m2km;
% 
% plot(simulationResults.x, )
end


