%xys should be a cell array of n x 3 matrices
%%calculate the position of each cell relative to its starting position for
%all time points
% Last update:  02.06.2018
% Written by: Ankita Ravi Vaswani

function plot_traj(xys, axh, color)
%calculate the position of each cell relative to its starting position for
%all time points:
if ~exist('axh', 'var') || isempty(axh)
    figure;
    axh = axes;
end
if ~exist('color', 'var') || isempty(color)
    color = [1 0 0];
end    
pdiff = cellfun(@(v) bsxfun(@minus, v(:, 1:2), v(1,1:2)), xys,'uniformoutput',false);

pdiffmat = cat(2, pdiff{:});
meanx = mean(pdiffmat(:,1:2:end), 2);
meany = mean(pdiffmat(:,2:2:end), 2);

axes(axh);
hold on;

for k = 1:numel(pdiff)
    plot(pdiff{k}(:,1), pdiff{k}(:,2), '.-', 'color', color);
    hold on;
end
%plot(meanx, meany, 'k.-','linewidth',3);
set(gca, 'dataaspectratio', [1 1 1]);