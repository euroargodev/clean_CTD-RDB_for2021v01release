function [IND, output]=box_cleansamples(inpath,box,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% removing samples with out of range values and
% incomplete triplets (each sample should have valid pressure, temperature
% and salinity values)
% Input: in and out paths and box number
% Author: Ingrid M. Angel-Benavides
%         BSH - EA-Rise
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Cleaning samples ' num2str(box) ' ...'])
filename=['ctd_' num2str(box)];

% get list of variables
var_list=whos('-file',[inpath filename]);
nvar=numel(var_list);
strv=[];
for i=1:nvar
    strv=[strv var_list(i).name ' '];
end

% load data
load([inpath filename])

% 1. Check ranges and replace out of range with nan
if min(lat)<-50 || max(lat)>60
   ft=find(temp<-2.5|temp>40);
else
   ft=find(temp<0|temp>40);
end
fs=find(sal<24|sal>41);
temp(ft)=NaN;ptemp(ft)=NaN;sal(fs)=NaN;
disp(['  ' num2str(numel(ft)) ' out of range temperature samples'])
disp(['  ' num2str(numel(fs)) ' out of range salinity samples'])

% get subindices
for k=1:numel(fs)
[a,b]=ind2sub(size(sal),fs(k));
FS(k,:)=[b a];
end

for k=1:numel(ft)
[a,b]=ind2sub(size(temp),ft(k));
FT(k,:)=[b a];
end

% 2. Find Incomplete triplets
% Selects only samples with valid sal,temp and pres data columns
% (all must be present)
isn(:,:,1)=isnan(pres);% nans in pres
isn(:,:,2)=isnan(temp);% nans in temp
isn(:,:,3)=isnan(sal);% nans in sal
isn=sum(isn,3);
% Valid samples have a value of 3 and fill values are equal to 0
% (all equal to NAN). Everything in between is an invalid sample
% Finding invalid samples/profiles to be corrected
[f1,f2]=find(isn>0&isn<3);
% get indices
INC=[f2 f1];

f1=numel(f1);f2=numel(unique(f2));
disp(['  ' num2str(f1) ' incomplete samples in ' num2str(f2) ' profiles']) 

% Rearrange/clean profiles
% Extract indices of the valid samples for each profile
ind_samples=cell(1,size(isn,2));
n_samples=zeros(1,size(isn,2));
for i=1:size(isn,2)
    % stores it in ind_data
    ind_samples{1,i}=find(isn(:,i)==0);
    % stores the number of valid samples per profile
    n_samples(1,i)=numel(find(isn(:,i)==0));
end

% Now it replaces the profile by a vector containing only the valid data
disp('   replacing profiles with clean versions...') %..........c[]
var_list={'pres','temp','ptmp','sal'};
for j=1:numel(var_list) % indices of pressure, temperature and salinity
    eval(['tmp=' var_list{j} ';']);
    for i=1:size(tmp,2)
        TMP=nan(size(tmp,1),1);
        TMP(1:n_samples(i))=tmp(ind_samples{i},i);
        tmp(:,i)=TMP;clear TMP
    end
    eval([var_list{j} '=tmp;']);
end

% Cleans matrix
% removes the rows with only nans
pres=pres(1:max(n_samples),:);
sal=sal(1:max(n_samples),:);
temp=temp(1:max(n_samples),:);
ptmp=ptmp(1:max(n_samples),:);

% saves file
if nargin<3
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end

output=[numel(lat) numel(ft) numel(fs) f1 f2];
if numel(fs)>0
    IND.outsal=FS;
else
    IND.outsal=[];
end
if numel(ft)>0
   IND.outtemp=FT;
else
   IND.outtemp=[];
end
if numel(ft)>0
   IND.incomplete=INC;
else
   IND.incomplete=[];
end

