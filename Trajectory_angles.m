%xys should be a cell array of n x 3 matrices
%Used to analyze trajectories of slow, moderate and fast mDA neurons
% Last update:  22.07.2018
% Written by: Ankita Ravi Vaswani

assert(exist('xys', 'var') && isa(xys,'cell'), 'xys must be a cell array');

%adjustable parameters
min_maxspeed = 10; %um / h
max_maxspeed = inf;
dimensions_to_use = [1 2 3];
use_rms = true;
hours_per_frame = 1 / 6;
c = {'g', 'y', 'g'};
edges = [10 inf];
%maxshift_plots = 10;
%skip_first_n_frames = 5; % can be zero

% if ~use_rms
%     
%     assert(numel(dimensions_to_use) == 1, 'rms mode must be used when more than one dimensions is analyzed at once');
%     
% end

%xys_afterskip = cellfun(@(v) v(skip_first_n_frames+1:end, :), xys, 'uniformoutput', false);

maxspeed = cellfun(@(v) max(sqrt(sum(diff(v,1,1).^2,2))), xys) / hours_per_frame; % um / h
ok = (maxspeed >= min_maxspeed) & (maxspeed <= max_maxspeed);
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
trajectory_angle = cellfun(@(v) atan2(v(:,1),v(:,2)), total_displacement_vectors,'uniformoutput', false);
total_displacement_vectors = cat(1, total_displacement_vectors{:}); %convert from cell array to numeric array, each neuron is a row
trajectory_angle = cat(1, trajectory_angle{:}); %convert from cell array to numeric array, each neuron is a row 
final_distance = sqrt(sum(total_displacement_vectors .^ 2, 2)); %total distance traveled, each neuron
trajectory_angle_fast = trajectory_angle;
deg_trajectory_angle_fast = rad2deg(trajectory_angle);
ang_mean_fast = rad2deg(circ_mean(trajectory_angle));
ang_median_fast = rad2deg(circ_median(trajectory_angle));
ang_std_fast=rad2deg(circ_std(trajectory_angle));

% at this point, y holds either displacement distances or signed displacements for each cell


figure;
for j = 1:numel(edges) - 1
    ii = maxspeed_ok >= edges(j) & maxspeed_ok < edges(j+1);
    h = polarhistogram(trajectory_angle(ii),12, 'FaceColor', c{j}, 'FaceAlpha', .3);
    hold on;
end

tstring = ['n = ' num2str(sum(ok)) ', axes: ' num2str(dimensions_to_use) ', rms mode: ' num2str(use_rms)];
title(tstring);

