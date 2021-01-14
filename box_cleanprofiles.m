function [ind, output]=box_cleanprofiles(inpath,box,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds and deletes profiles that: do not belong in the box,
% have maximum recorded pressure shallower than 900 db, and have non
% monotonically increasing pressure (usually indicates more than 1 cast per
% profile)
% Input: in and out paths and box number
% Author: Ingrid M. Angel-Benavides
%         BSH - EA-Rise
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Cleaning profiles ' num2str(box) ' ...'])

filename=['ctd_' num2str(box)];

% load data
load([inpath filename],'long','lat','pres')

% A. get outside of the box indices
lim=wmosquare(box);
lonlims=[lim(1) lim(2)];latlims=[lim(3) lim(4)];
if sum(lonlims<=0) == 2
    long=convertlon(long,180);
else
    lonlims=convertlon(lonlims,360);
end
[lon_pts,lat_pts]=corners(lonlims,latlims);
in=inpolygon(long,lat,lon_pts,lat_pts);
ind{1,1}=find(in==0);
disp(['  ' num2str(numel(ind{1})) ' profiles out of the box ...'])


% B. Get shallow MRP
MRP=max(pres,[],1);
ind{2,1}=find(MRP<900);
disp(['  ' num2str(numel(ind{2})) ' profiles shallower than 900 db ...'])

% C. Get profiles with non-monotonically increasing pressure (NMIP)
% Check for columns containing more than one profile
[il,ic]=find((diff(pres,[],1))<0);
ind{3,1}=unique(ic)';
disp(['  ' num2str(numel(ind{3})) ' profiles with non-monotonically increasing pressure ...'])

% getting profiles to be deleted
excl=union(union(ind{1},ind{2}),ind{3});

if numel(excl)>0
    if nargin<3
        box_excl(inpath,box,excl)
    else
        box_excl(inpath,box,excl,outpath)
    end   
    disp([num2str(numel(excl)) ' profiles removed'])
else
    disp('No profiles removed')
end

output=[numel(ind{1}),numel(ind{2}),numel(ind{3}) numel(excl)];