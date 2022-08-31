function [timeinIntMigration]=intMig(xyz)
%******************************************************
% calculate the % of time spent at rest by a neuron (speed < 10um/hr)
% 
% 
%*******************************************************
% 
% Last update:  02.06.2018
% Written by: Ankita Ravi Vaswani              
%******************************************************


[fn,~]=size(xyz); % frame number of analysis    
    n=0;
   
    for dt= 1 : (fn-1) % loop through differnet time-lag            
            speedxyz=sqrt((xyz(1+dt,1)-xyz(dt,1))^2+(xyz(1+dt,2)-xyz(dt,2))^2+(xyz(1+dt,3)-xyz(dt,3))^2)*6;
            if 30 <= speedxyz && 60> speedxyz
                n=n+1;
            end
            

    end
   timeinIntMigration = n/(fn-1)*100; 
end
