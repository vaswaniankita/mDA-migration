%xys should be a cell array of n x 3 matrices
%Used to plot trajectories of slow, moderate and fast mDA neurons
% Last update:  02.06.2018
% Written by: Ankita Ravi Vaswani
%cannot be used on datasets with varying number of time-points in analysis


edges = [0 10 30 60 inf];
load('/Users/vaswani/Documents/MATLAB_MAC/cmap_from_prism.mat','cmap');
%cmap = hsv(256);

figure;
nrows = ceil(sqrt(numel(edges) - 1));



maxspeed = cellfun(@(v) max(sqrt(sum(diff(v,1,1).^2,2))), xys) * 6;
%maxspeed is in microns per hour

max_maxspeed = 120;
ax = [];
for u = 1:numel(edges) -1
    
    axh(u) = subplot(nrows, nrows, u);
    cells_for_this_plot = maxspeed >= edges(u) & maxspeed < edges(u + 1);
    plot_traj_multicolor(xys(cells_for_this_plot), ...
        maxspeed(cells_for_this_plot),0,max_maxspeed,cmap,axh(u));
    title(sprintf('max speed %g to %g microns / hour', edges(u), edges(u + 1)));
    
end
set(axh,'xlim',[-40 120],'ylim',[-40 60],'dataaspectratio', [1 1 1]);