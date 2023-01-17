function [ind, noutput]=box_cleanprofiles(inpath,box,outpath,minmrp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds and deletes profiles that: do not belong in the box,
% have maximum recorded pressure (MRP) shallower than a certain pressure value in 
% db (900db if the argument minmrp is not given), and have non
% monotonically increasing pressure (usually indicates more than 1 cast per
% profile, but it also weeds out profiles that need further quality control)

% Input: in (INPATH) and out (OUTPATH) paths and box number (BOX).
%        MINMRP is an optional input indicating the minimum depth of the
%        profiles. According to the Argo manual, the default value is 900
%        db.
%        OUTPATH is optional, if not given the cleaned box file will be 
%        saved in the current folder
% Output:
% A new version cleaned version of the box file saved in the OUTPATH or
% local directory
% IND is a structure that contains all the information (indices) about the 
%     deleted profiles
% NOUTPUT is a vector with the profile cleaning summary. The vector
%         elements are
%         number of profiles outside of the box, shallower than the min MRP, with
%         non-monotonically increasing pressure, total of profiles excluded
%
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% asssign default value for the MRP check
if nargin<4
   minmrp = 900;
end

disp(['Cleaning profiles ' num2str(box) ' ...'])

% getting data
filename=['ctd_' num2str(box)];
load([inpath filename],'long','lat','pres')

% A. find profiles outside of the box
% get box limits
lim=wmosquare(box);
lonlims=[lim(1) lim(2)];latlims=[lim(3) lim(4)];
% fix format
if sum(lonlims<=0) == 2
    long=convertlon(long,180);
else
    lonlims=convertlon(lonlims,360);
end
% get box polygon and find profiles outside
[lon_pts,lat_pts]=corners(lonlims,latlims);
in=inpolygon(long,lat,lon_pts,lat_pts);
ind{1,1}=find(in==0);
if isempty(ind{1,1})
    ind{1,1}=[];
end
disp(['  ' num2str(numel(ind{1})) ' profiles out of the box ...'])


% B. find profiles that are too shallow (check MRP)
MRP=max(pres,[],1); % maximum recorded pressure
ind{2,1}=union(find(MRP<minmrp),find(isnan(MRP)==1)); %#ok<COMPNOP>
if isempty(ind{2,1})
    ind{2,1}=[];
end
disp(['  ' num2str(numel(ind{2})) ' profiles shallower than 900 db ...'])

% C. Get profiles with non-monotonically increasing pressure (NMIP)
% Check for columns containing more than one profile or needing further
% quality control
[~,ic]=find((diff(pres,[],1))<0);
ind{3,1}=unique(ic)';
if isempty(ind{1,1})
    ind{3,1}=[];
end
disp(['  ' num2str(numel(ind{3})) ' profiles with non-monotonically increasing pressure ...'])


% put together the indices of all profiles that will be deleted
excl=union(union(ind{1},ind{2}),ind{3});
if isempty(excl)
    excl=[];
end

% if there is any profile to delete and displays a summary
if numel(excl)>0
    if nargin<3 % deletes profiles and saves it in the corresponding folder
        box_excl(inpath,box,excl)
    else
        box_excl(inpath,box,excl,outpath)
    end   
    disp([num2str(numel(excl)) ' profiles removed'])
else
    disp('No profiles removed')
end

% summary of deleted profiles
noutput=[numel(ind{1}),numel(ind{2}),numel(ind{3}) numel(excl)];
% number of profiles outside of the box, shallower than the min MRP, with
% non-monotonically increasing pressure, total of profiles excluded