% xys should be a cell array of n x 3 matrices
% Used to plot trajectories of slow, moderate and fast mDA neurons
% Called by multitrajplots.m
% Last update:  02.06.2018
% Written by: Ankita Ravi Vaswani
% cannot be used on datasets with varying number of time-points in analysis

function plot_traj_multicolor(xys, values, min_value, max_value, cmap, axh)
if ~exist('min_value', 'var') || isempty(min_value)
    min_value = min(values(:));
end
if ~exist('max_value', 'var') || isempty(max_value)
    max_value = max(values(:));
end
if ~exist('cmap','var') || isempty(cmap)
    cmap = parula(256);
end
if ~exist('axh', 'var') || isempty(axh)
    figure;
    axh = axes;
end

values_normed = (values - min_value) / (max_value - min_value);
ncolors = size(cmap, 1);
color_index = max(1, min(ceil(values_normed * ncolors), ncolors));
for c = 1:ncolors
   
    ii = color_index == c;
    plot_traj(xys(ii), axh, cmap(c, :));
    
end
colormap(cmap);
caxis([min_value, max_value]);
colorbar;