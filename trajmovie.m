function trajmovie(xy1, xy2, outputfile, color1, color2)
if nargin < 3 || isempty(outputfile)
    
    [ff, pp] = uiputfile('*.avi', 'Save movie', 'trajectories.avi');
    if isnumeric(pp) % user clicked cancel
        return;
    end
    outputfile = [pp ff];
    
end
if nargin < 4
    
    color1 = [0 0 0];
    
end
if nargin < 5
    
    color2 = [1 1 1] * .5;
    
end

relpos1 = cellfun(@(v) bsxfun(@minus, v(:, 1:2), v(1,1:2)), xy1,'uniformoutput',false);
relpos2 = cellfun(@(v) bsxfun(@minus, v(:, 1:2), v(1,1:2)), xy2,'uniformoutput',false);
allp = [cat(1, relpos1{:}); cat(1, relpos2{:})];
maxxy = max(allp, [], 1);
minxy = min(allp, [], 1);

nc1 = numel(xy1);
nc2 = numel(xy2);

nframes1 = cellfun(@(v) size(v, 1), xy1);
nframes2 = cellfun(@(v) size(v, 1), xy2);
if any(nframes1 ~= nframes1(1)) || any(nframes2 ~= nframes1(1))
    
    warning('not all cells are tracked for the same number of frames');
    
end

minframes = min(min(nframes1), min(nframes1));

f = figure;

ax = axes('parent', f,'dataaspectratio', [1 1 1], 'xlim', [minxy(1) maxxy(1)], 'ylim', [minxy(2), maxxy(2)],'xtick',[],'ytick',[],'box','off');

for c1 = 1:nc1
    
    h1(c1) = line(nan, nan, 'linestyle','-','marker','.','color',color1);
    
end
for c2 = 1:nc2
    
    h2(c2) = line(nan, nan, 'linestyle','-','marker','.','color',color2);
    
end

vidObj = VideoWriter(outputfile);
open(vidObj);

try
    
    for j = 1:minframes
        
        for c1 = 1:nc1
            
            if nframes1(c1) < j
                
                continue;
                
            end
            set(h1(c1), 'xdata', relpos1{c1}(1:j, 1), 'ydata', relpos1{c1}(1:j, 2));
            
        end
        
        for c2 = 1:nc2
            
            if nframes2(c2) < j
                
                continue;
                
            end
            
            set(h2(c2), 'xdata', relpos2{c2}(1:j, 1), 'ydata', relpos2{c2}(1:j, 2));
            
        end
        
        g = getframe(ax);
        writeVideo(vidObj, g);
        
    end
    
catch
    
end
close(vidObj);
close(f);
