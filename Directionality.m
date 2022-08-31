%xys should be a cell array of n x 3 matrices
%Used to plot directionality and coefficient of variation of slow, moderate and fast mDA neurons
% Last update:  02.06.2018
% Written by: Ankita Ravi Vaswani


assert(exist('xys', 'var') && isa(xys,'cell'), 'xys must be a cell array');

%adjustable parameters
min_maxspeed = 10; %um / h
max_maxspeed = inf;
dimensions_to_use = [1 2 3]; %can be changed depending on 1D, 2D and 3D data
use_rms = true; %false for 1D data
hours_per_frame = 1 / 6; %can be changed depending on interval between frames
c = {'r', 'y', 'g'};


if ~use_rms
    
    assert(numel(dimensions_to_use) == 1, 'rms mode must be used when more than one dimensions is analyzed at once');
    
end


maxspeed = cellfun(@(v) max(sqrt(sum(diff(v,1,1).^2,2))), xys) / hours_per_frame; % um / h
ok = (maxspeed >= min_maxspeed) & (maxspeed < max_maxspeed); % filter based on max.speeds
xys_afterfilt = xys(ok);
maxspeed_ok = maxspeed(ok);

displacement_vectors = cellfun(@(v) diff(v(:, dimensions_to_use), 1, 1), xys_afterfilt, 'uniformoutput', false);
x_velocity_vectors = cellfun(@(v) diff(v(:, 1), 1, 1) / hours_per_frame, xys_afterfilt, 'uniformoutput', false);
distance_each_frame = cellfun(@(v) sqrt(sum(v .^ 2, 2)), displacement_vectors, 'uniformoutput', false);
mean_distance = cellfun(@mean, distance_each_frame); % for each neuron
std_distance = cellfun(@std, distance_each_frame); %for each neuron
cv_distance = std_distance ./ mean_distance;
pathlength = cellfun(@sum, distance_each_frame); %pathlength for each neuron
total_displacement_vectors = cellfun(@sum, displacement_vectors, 'uniformoutput', false); % displacement vector from first to last frame, for each neuron
total_displacement_vectors = cat(1, total_displacement_vectors{:}); %convert from cell array to numeric array, each neuron is a row
total_displacement = sqrt(sum(total_displacement_vectors .^ 2, 2)); %total displacement traveled, each neuron
mean_x_position = cellfun(@(v) mean(v(:,1)), xys_afterfilt, 'uniformoutput', false); %mean x-position
mean_x_position = cat(1, mean_x_position{:}); %convert from cell array to numeric array, each neuron is a row


edges = [0 30 60 inf];
figure;
for j = 1:numel(edges) - 1
    ii = maxspeed_ok > edges(j) & maxspeed_ok < edges(j+1);
    q = plot(maxspeed_ok(ii), pathlength(ii)./total_displacement(ii), 'o', 'markeredgecolor', 'none', 'markerfacecolor', c{j});
    if strcmpi(c{j}, 'y')
        set(q,'markeredgecolor', 'k');
    end
    hold on;
end

ylabel('Path length/ Total displacement');
xlabel('Max Speed (um/hr)');
tstring = ['n = ' num2str(sum(ok)) ', axes: ' num2str(dimensions_to_use) ', rms mode: ' num2str(use_rms)];
title(tstring);

edges = [0 30 60 inf];
figure;
for j = 1:numel(edges) - 1
    ii = maxspeed_ok >= edges(j) & maxspeed_ok < edges(j+1);
    q = plot(maxspeed_ok(ii), cv_distance(ii), 'o', 'markeredgecolor', 'none', 'markerfacecolor', c{j});
    if strcmpi(c{j}, 'y')
        set(q,'markeredgecolor', 'k');
    end
    hold on;
end

ylabel('Coefficient of variation in distance traveled');
xlabel('Max Speed (um/hr)');
tstring = ['n = ' num2str(sum(ok)) ', axes: ' num2str(dimensions_to_use) ', rms mode: ' num2str(use_rms)];
title(tstring);

edges = [0 30 60 inf];
figure;
for j = 1:numel(edges) - 1
    ii = maxspeed_ok > edges(j) & maxspeed_ok < edges(j+1);
    q = plot(maxspeed_ok(ii), mean_x_position(ii), 'o', 'markeredgecolor', 'none', 'markerfacecolor', c{j});
    if strcmpi(c{j}, 'y')
        set(q,'markeredgecolor', 'k');
    end
    hold on;
end