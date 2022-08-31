function [angtraj]=angcalc(xyz)
%******************************************************
% calculate the angle to the positive y-axis with input trajectory in x and y respectively.
% calculates angles of individual movements (for migratory phase angles)
% 
%*******************************************************
% 
% Last update:  10.25.2017
% Written by: Ankita Ravi Vaswani              
%******************************************************
% calculate angle between direction of movement and midline with input x,y,z coordinates in the unit of length(nm)
% x position as first column, y position as 2nd column of tp

[fn,~]=size(xyz); % frame number of analysis    
    angtraj=zeros(fn-1,1);
    for dt= 1 : (fn-1) % loop through differnet time-lag            
            dxyz=xyz(1+dt,:)-xyz(dt,:);
            m=dxyz(2)/dxyz(1);
            
            angtraj(dt)= atan2d(dxyz(1), dxyz(2));
           
    end

