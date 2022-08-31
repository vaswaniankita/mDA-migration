function [angendtraj]=angtrajcalc(xyz)
%******************************************************
% calculate the angle to the positive y-axis with input trajectory in x and y respectively.
% Calculates angle for trajectory of each neuron based on first and last
% positions
% 
%*******************************************************
% 
% Last update:  10.25.2017
% Written by: Ankita Ravi Vaswani               
%******************************************************
% calculate angle between direction of movement and midline with input x,y,z coordinates in the unit of length(um)
% x position as first column, y position as 2nd column

[fn,~]=size(xyz); % frame number of analysis    
             
            Dxyz=xyz(fn,:)-xyz(1,:);
                
            angendtraj = atan2d(Dxyz(1), Dxyz(2));
 
           
    end

