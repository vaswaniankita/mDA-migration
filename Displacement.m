%xys should be a cell array of n x 3 matrices
%Used to plot total displacement (3D) of slow, moderate and fast mDA neurons
% Last update:  02.06.2018
% Written by: Ankita Ravi Vaswani
assert(exist('xys', 'var') && isa(xys,'cell'), 'xys must be a cell array');

%adjustable parameters
min_maxspeed = 0; %um / h
max_maxspeed = inf;
dimensions_to_use = [1 2 3]; %can be changed depending on 1D, 2D and 3D data
use_rms = true; %false for 1D data
hours_per_frame = 1 / 6; %can be changed depending on interval between frames
c = {'r', 'y', 'g'};


if ~use_rms
    
    assert(numel(dimensions_to_use) == 1, 'rms mode must be used when more than one dimensions is analyzed at once');
     
 end


maxspeed = cellfun(@(v) max(sqrt(sum(diff(v,1,1).^2,2))), xys) / hours_per_frame; % um / h
ok = (maxspeed >= min_maxspeed) & (maxspeed <= max_maxspeed);
xys_afterfilt = xys(ok);
maxspeed_ok = maxspeed(ok);

displacement_vectors = cellfun(@(v) diff(v(:, dimensions_to_use), 1, 1), xys_afterfilt, 'uniformoutput', false);
total_displacement_vectors = cellfun(@sum, displacement_vectors, 'uniformoutput', false); % displacement vector from first to last frame, for each neuron
total_displacement_vectors = cat(1, total_displacement_vectors{:}); %convert from cell array to numeric array, each neuron is a row
%code will not work with different durtions of imaging in the data; for
%slices imaged at different duration, data was analyzed separately and
%merged with other files.
total_displacement = sqrt(sum(total_displacement_vectors .^ 2, 2)); %total displacement traveled, each neuron

edges = [10 30 60 inf];
figure;
for j = 1:numel(edges) - 1
    ii = maxspeed_ok >= edges(j) & maxspeed_ok < edges(j+1);
    qr = plot(maxspeed_ok(ii), total_displacement(ii), 'o', 'markeredgecolor', 'none', 'markerfacecolor', c{j});
    if strcmpi(c{j}, 'y')
        set(qr,'markeredgecolor', 'k');
    end
    hold on;
end

ylabel('Total displacement');
xlabel('Max Speed (um/hr)');
tstring = ['n = ' num2str(sum(ok)) ', axes: ' num2str(dimensions_to_use) ', rms mode: ' num2str(use_rms)];
title(tstring);