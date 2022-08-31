function [maxSpeed]=maxSpeed(xyz)
%******************************************************
% calculate the Maximum Speed with input trajectory in x, y, z respectively.
% 
% 
%*******************************************************
% modified from code in Wu et al., 2015
% modified by Ankita Vaswani, October 2017
%               
%******************************************************
% outputs the maximumSpeed with input x,y,z cell locations in the unit of length(um)

[fn,~]=size(xyz); % frame number of analysis    
    speed=zeros(fn-1,1);
    
    for dt= 1 : (fn-1) % loop through differnet time-lag            
            dxyz=xyz(1+dt,:)-xyz(dt,:);
            speed(dt)=sqrt(sum(dxyz.^ 2, 2))*6;            
    end
maxSpeed = max(speed);