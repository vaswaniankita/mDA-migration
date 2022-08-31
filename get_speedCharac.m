function SpeedCharac=get_speedCharac(xys,~,param)
% 
% 
% 
% input:
%   xys (optional): a N*1 cell array, Each cell contains individual cell trajectory data matrice. 
%   The format of trajectory matrice must be in the the sequence of cell id, time frame, x, y, z ;      
%   Each trajectories  must have the same time length, Nt.
%   if xys is not provided, the "get_trajfile.m" will be called to
%   select and input trajectories file. (see get_trajfile for more
%   details). 
%   dt  (optional): time step size of trajectory data,
%   if not included, input the desired value through pop-up window.  
%   param (optional) : parameters setting , if not included a default value
%   of settting will be used.
%    param.dim :dimensionality of trajectories (either 2 or 3) (default: 2);
%    param.saveres : if true, data will be output to user-specified
%    excel file. Both individual and ensemble-averaged data will be saved in different sheet where . 
%    the first column is time lags. (default: true).  
%    param.showfig : if true, MSD result will be plotted into a figure. 
%    default: true)
%    param.markertype : Specify marker types in generated MSD graph (default: 'bo')
%    param.outfigurenum : Specify figure number (postive integer) for MSD graph(default : 301)
% 
% output: Excel file with speed characteristics of time spent at rest, in slow, moderate (int and fast migration 

% Modified from code in Wu et al., 2015
% Modified by: Ankita Ravi Vaswani
%
%%%%%%%%%%%%%%%%%%%

%%%% main program

% check input variables
if nargin==0
    xys=get_trajfile;
end
if nargin<=1 % if dt is not included in input variable, use default setting
    answer=inputdlg('Trajectory time step size','input time step size');
    dt=str2double(answer);
end

if nargin<=2 % if param is not included in the input variable, use default setting
    param.showfig=1;
    param.saveres=1;
    param.markertype='r-';
    param.outfigurenum=301;
    param.dim=2;
end

% main program
    Nc=length(xys);
    [~,~]=size(xys{1}); 
    
    fCount = 0;
    mCount = 0;
    sCount = 0;
    rCount = 0;
    timeAtRest=zeros(Nc,1);
    timeLatMigration= zeros(Nc,1);
    timeSlowMigration=zeros(Nc,1);
    timeIntMigration=zeros(Nc,1);
    timeFastMigration=zeros(Nc,1);
    
     for k=1:Nc  
        xy=xys{k};          
        timeAtRest(k)=rest(xy);
        timeSlowMigration(k)= slowMig(xy);
        timeIntMigration(k)= intMig(xy);
        timeFastMigration(k)= fastMig(xy);
        
        if timeFastMigration(k) > 0
            fCount = fCount + 1;
             
        else if timeFastMigration(k)== 0 && timeIntMigration(k) > 0
                mCount = mCount + 1;
                
            else if timeFastMigration(k)== 0 && timeIntMigration(k) == 0 &&  timeSlowMigration(k) > 0
                    sCount = sCount + 1;
                    
                else rCount = rCount + 1;
                end
            end
        end
        
        
        
       end
        meanTimeAtRest = mean(timeAtRest);
        stdTimeAtRest= std(timeAtRest);
        meanTimeLatMigration= mean(timeLatMigration);
     
        
        
  
        
          
 % output the data to the excel file
     if param.saveres
     [filename, pathname] = uiputfile( ...       
         {'*.xlsx',  'excel files (*.xlsx)'; ...
           '*.xls','excel file (*.xls)'}, ...             
           'save MSD reuslts','MSD.xlsx');          
        
        xlswrite([pathname,filename],[timeAtRest],'individual time spent at rest');
       
        xlswrite([pathname,filename],[timeLatMigration],'time in latmigration');
        
        xlswrite([pathname,filename],[timeSlowMigration],'time in SlowMigration');
        
        xlswrite([pathname,filename],[timeIntMigration],'time in IntMigration');
        
        xlswrite([pathname,filename],[timeFastMigration],'time in FastMigration');
        
        delete_extra_sheet(pathname,filename)
     end
          
     if nargout==0
         clear 
     end
end