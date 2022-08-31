function avgAngle=get_angle(xys,dt,param)

%%%%%%%%%%%%%%%%%%%
%used to calculate angles of individual migratory movements
% Last update:  22.07.2018
% Written by: Ankita Ravi Vaswani
%modified from code in Wu et al., 2015

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

anglefin=zeros(Nt-1,Nc);
meanAngle=zeros(Nc,1);
stdAngle=zeros(Nc,1);
mxSpeed=zeros(Nc,1);
maxSpeedfilteredAngle=zeros(Nc,1);
stdFilteredAngle=zeros(Nc,1);

minmovethresh = 10 * dt;  % convert from microns / hour to microns / frame

for k=1:Nc
    xy=xys{k};
    
    moved = sum(diff(xy, 1, 1) .^ 2, 2) > minmovethresh ^ 2;
    
    angle=angcalc(xy);
    mxSpeed(k)= maxSpeed(xy);
    anglefin(:,k)=angle(:);     % output the angles
    meanAngle(k)= mean(angle(moved));
    stdAngle(k)= std(angle(moved));
    
    if mxSpeed >= 60 %Value can be set to filter for different maxspeeds
        maxSpeedfilteredAngle(k)= meanAngle(k);
        stdFilteredAngle(k)= stdAngle(k);
    else
        maxSpeedfilteredAngle(k)=0;
        stdFilteredAngle(k)=0;
    end
    
end
tii=[1:Nt-1]'*dt;

plot_traj(xys);

%%% plot histogram of average angles
figure;
polarhistogram(meanAngle, 12)
hold on


% output the data to the excel file
if param.saveres
    [filename, pathname] = uiputfile( ...
        {'*.xlsx',  'excel files (*.xlsx)'; ...
        '*.xls','excel file (*.xls)'}, ...
        'save MSD reuslts','MSD.xlsx');
    
    xlswrite([pathname,filename],[tii,anglefin],'individual timepoint angles');
    xlswrite([pathname,filename],[meanAngle, stdAngle],'average angles');
    xlswrite([pathname,filename],[mxSpeed, maxSpeedfilteredAngle, stdFilteredAngle],'filtered average angles');
    
    delete_extra_sheet(pathname,filename)
end

if nargout==0
    clear
end
end