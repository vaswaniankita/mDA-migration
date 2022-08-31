function [disFil]=dispFilter(xyz)
%******************************************************
% calculate the angle to the positive y-axis with input trajectory in x and y respectively.
% Can be used to filter out very small movements for angle calculation
% 
%*******************************************************
% 
% Last update:  12.19.2017
% Written by: Ankita Ravi Vaswani                   
%******************************************************
% calculate angle between direction of movement and midline with input x,y,z coordinates in the unit of length(nm)
% x position as first column, y position as 2nd column of tp

[fn,~]=size(xyz); % frame number of analysis    
             
            Dxyz=xyz(fn,:)-xyz(1,:);
            
            if sum(abs(Dxyz), 2)> 10
                
            disFil = 1;
            
            else
                disFil = 0;
           
    end
