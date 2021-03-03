addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\m_map'
clear variables;close all;
% From % b1_check_7DN1991_meta
% Fix the source and qclevel values for the CHHDO Cruise 77DN19910726 
% The longitude of one station is corrected
% Author: Ingrid M. Angel-Benavides
%         BSH - MOCCA/EA-Rise (Euro-Argo)
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Info
% Path

outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\A5';
indir=[outp '\**\'];
list=dir([indir 'ctd*.mat']);

% Cruise infos (longitude,latitude and station number)
% All data in H:\Datenbanken\CTD_for_2019\checks_per_source\ifremer\unique_source
load('77DN19910726_info.mat')
lo=convertlon(lo,360);

% Finds all profiles from this cruise and extracts their position and
% timestamp data
wmo_boxes= pos2wmo(la,lo);

% Preallocate
% Box and profile index
BOX=cell(numel(unique(wmo_boxes)),1);PROF=BOX;
% Position and timestamp
LAT=BOX;LONG=BOX;DATE=BOX;

% Loop for wmo boxes files
for k=1:numel(list)
    % load data
    file=list(k).name;
    %...................................................................c[]
    disp(['Reading file ' num2str(k) ' from ' num2str(numel(list))])  
    disp(file);
    %...................................................................c[]
    wmo_box(k)=str2double(file(end-7:end-4));
    
    % find profiles
    load([list(k).folder '\' file])
    f=find(strcmp('77DN19910726',source)==1)';
    
    % save profiles info
    % original matfile
    BOX{k,1}=repmat(wmo_box(k),numel(f),1);
    PROF{k,1}=f;
    % header
    LAT{k,1,1}=lat(f)';
    LONG{k,1}=long(f)';
    DATE{k,1}=dates(f)';
end

% Join all the stations from different boxes
PROF=cell2mat(PROF);
BOX=cell2mat(BOX);
lat=cell2mat(LAT);clear LAT;%LAT(~cellfun(@isempty,LAT)));clear LAT
long=cell2mat(LONG);clear LON;%(~cellfun(@isempty,LONG)));clear LON
dates=cell2mat(DATE);clear DATE
% 
% save a2temp.mat
%% Plot 77DN19910726 in the wmo boxes
% load a2temp.mat
% m_proj('lambert','long',[-25 160],'lat',[80 90]);
% cm=jet(numel(long));
% figure%('position',[5 646   912   484],'color','w')
% for i=1:numel(long)
% %m_plot(long(i),lat(i),'o','MarkerFaceColor',cm(i,:),'MarkerEdgeColor',cm(i,:))
% m_text(long(i),lat(i),num2str(i));
% hold on
% end
% m_grid('xtick',12,'ytick',80:2:88,'xtick',0:30:150,'linest','-');
% m_coast('patch',[.7 .7 .7],'edgecolor','k');
% title('Stations in the selected WMO boxes')

% figure
% for i=1:numel(lo)
% %m_plot(long(i),lat(i),'o','MarkerFaceColor',cm(i,:),'MarkerEdgeColor',cm(i,:))
% m_text(lo(i),la(i),num2str(i),'color','r');
% hold on
% end
% m_grid('xtick',12,'ytick',80:2:88,'xtick',0:30:150,'linest','-');
% m_coast('patch',[.7 .7 .7],'edgecolor','k');
% title('Stations in the nc files')
%% Assigning unique source values for each profile
%.......................................................................c[]
disp('')
disp('Assigning new values for qclevel and source (CRUISE_ST)')
%.......................................................................c[]

% round up longitude values
nlong=round(long,1);lo=round(lo,1);
nlat=round(lat,1);la=round(la,1);

% preallocate
stnmbr=zeros(numel(PROF),1);% station number
nsource=cell(numel(PROF),1);
nqclevel=cell(numel(PROF),1);

% Loop for profiles
for i=1:numel(PROF)
    % get station number and generates new source value (CRUISE_ST)
    t=find(nlong(i)==lo&nlat(i)==la);    
    if isempty(t)==0
        stnmbr(i,1)=st(t);
        nsource{i}=['77DN19910726_' num2str(st(t))];
    end
end
% 
indir=[outp(1:end-1) '6'];
% %% Change the mat files
ub=unique(BOX);
for k=1:numel(ub)
    list=dir([outp '\**\' 'ctd_' num2str(ub(k)) '.mat']);
    filein=[list.folder '\ctd_' num2str(ub(k)) '.mat'];
    fileout=[indir '\ctd_' num2str(ub(k)) '.mat'];
    eval(['copyfile ' filein ' ' fileout])
    
    m=matfile(fileout,'Writable',true);
    f=find(BOX==ub(k));
    f2=PROF(f);
    %m.qclevel(1,f2)
    for l=1:numel(f)
    m.source(1,f2(l))=nsource(f(l));
    end
end

save a6_source_change.mat BOX PROF nsource
%% clean samples % - Delete coastal profiles (Sognefjord)
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\corr'
box=1600;
list=dir([outp '\**\' 'ctd_' num2str(box) '.mat']);
filein=[list.folder '\ctd_' num2str(box) '.mat'];
fileout=[indir '\ctd_' num2str(box) '.mat'];
eval(['copyfile ' filein ' ' fileout])
m=matfile(fileout);
    
load fjord

excl_3=find(inpolygon(m.long,m.lat,x,y)==1);
%...............................................................c[]
disp(['Coastal profiles (Sognefjord): ' num2str(numel(excl_3)) ])

box_excl([indir '\'],1600,excl_3,[indir '\'])

save a6_fjord_excl.mat excl_3 box

%% 
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\A5';
indir=[outp '\**\'];
list=dir([indir 'ctd*.mat']);

op='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\A5\';

for i=1:numel(list)
    if exist([op list(i).name],'file')~= 2
       box=str2double(list(i).name(5:8));
       box_copy(outp,box,op) 
    end
end
