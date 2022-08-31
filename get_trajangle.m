function trajAngle=get_trajangle(xys,dt,param)

%%%%%%%%%%%%%%%%%%%
%outputs trajectory angle of all neurons
% Last update:  02.06.2018
%modified from code in Wu et al., 2015
% Written by: Ankita Ravi Vaswani     
%%%% main program

% check input variables
if nargin==0;
    xys=get_trajfile;
end
if nargin<=1; % if dt is not included in input variable, use default setting
    answer=inputdlg('Trajectory time step size','input time step size');
    dt=str2double(answer);
end

if nargin<=2; % if param is not included in the input variable, use default setting
    param.showfig=1;
    param.saveres=1;
    param.markertype='r-';
    param.outfigurenum=301;
    param.dim=2;
end

% main program
Nc=length(xys);
[Nt,dim]=size(xys{1});

trajAngle=zeros(Nc,1);
mxSpeed=zeros(Nc,1);
maxSpeedfilteredAngle=zeros(Nc,1);


for k=1:Nc
    xy=xys{k};
   
        
        mxSpeed(k)= maxSpeed(xy);
        trajAngle(k)= angtrajcalc(xy);
    
         if mxSpeed(k) >= 60
        maxSpeedfilteredAngle(k)= trajAngle(k);  
         end
        

    
end
tii=[1:Nt-1]'*dt;

plot_traj(xys);

%%% plot histogram of average angles
figure;
polarhistogram(trajAngle, 12)
figure;
polarhistogram(maxSpeedfilteredAngle, 12)
hold on


% output the data to the excel file
if param.saveres
    [filename, pathname] = uiputfile( ...
        {'*.xlsx',  'excel files (*.xlsx)'; ...
        '*.xls','excel file (*.xls)'}, ...
        'save MSD reuslts','MSD.xlsx');
    
    xlswrite([pathname,filename],[trajAngle],'all traj angles');
    xlswrite([pathname,filename],[mxSpeed, maxSpeedfilteredAngle],'filtered traj angles');
    
    delete_extra_sheet(pathname,filename)
end

if nargout==0
    clear
end
end