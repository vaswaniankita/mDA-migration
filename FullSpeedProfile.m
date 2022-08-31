%Used to generate maximum, average and stddev. in soma speeds for the
%population of neurons
% Last update:  02.06.2018
% Written by: Ankita Ravi Vaswani


assert(exist('xys', 'var') && isa(xys,'cell'), 'xys must be a cell array');
dimensions_to_use = [1 2 3]; %can be changed depending on 1D, 2D and 3D data
fillcolors = {'r', 'b', 'y', 'g'};
hours_per_frame = 1/6; %can be changed depending on interval between frames

maxspeed = cellfun(@(v) max(sqrt(sum(diff(v,1,1).^2,2))), xys) / hours_per_frame; % um / h
displacement_vectors = cellfun(@(v) diff(v(:, dimensions_to_use), 1, 1), xys, 'uniformoutput', false);
distance_each_frame = cellfun(@(v) sqrt(sum(v .^ 2, 2)), displacement_vectors, 'uniformoutput', false);
mean_distance = cellfun(@mean, distance_each_frame); % for each neuron
av_speed = mean_distance*6;
std_distance = cellfun(@std, distance_each_frame); %for each neuron

[sorted_maxspeed,I] = sort(maxspeed);

figure; 

edges = [0 10 30 60 inf];

for j = 1:numel(edges) - 1
    
    ii = find(sorted_maxspeed >= edges(j) & sorted_maxspeed < edges(j + 1));  % ii is already sorted
    ii = ii(:)'; %make sure ii is a row vector
    xfill = [ii ii(end:-1:1) ii(1)];
    xfill(xfill == ii(1)) = ii(1) - 0.5;
    xfill(xfill == ii(end)) = ii(end) + 0.5;
    yfill = [zeros(1, numel(ii)) reshape(sorted_maxspeed(ii(end:-1:1)),1,[]) 0];
    patch(xfill',yfill',fillcolors{j});
    hold on
    
end

x=cat(2, 1:numel(maxspeed), numel(maxspeed):-1:1, 1);
y=cat(1, (av_speed(I)-std_distance(I)*6), av_speed(I(end:-1:1))+std_distance(I(end:-1:1))*6, av_speed(I(1)) - std_distance(I(1))*6)';

y2=max(y,0);
patch(x',y2','g');



hold on
plot(sorted_maxspeed);
plot(av_speed(I));