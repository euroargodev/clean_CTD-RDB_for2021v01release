function [ind, noutput]=box_cleansamples(inpath,box,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function removes samples with out of range values and
% incomplete triplets (each sample should have valid pressure, temperature
% and salinity values)
% 
% Input: in (INPATH) and out (OUTPATH) paths and box number (BOX)
% Output:
% A new version cleaned version of the box file saved in the OUTPATH
% directory
% IND is a structure that contains all the information (indices) about the 
%     deleted samples and values
% NOUTPUT is a vector with the sample cleaning summary. Its elemenst are
%       number of profiles in the beginning, number of temp samples out 
%       of range, number of salinity samples out of range, number of 
%       incomplete samples and number of profiles with incomplete samples
%
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['Cleaning samples ' num2str(box) ' ...'])

% get name of the file
filename=['ctd_' num2str(box)];

% get list of variables
var_list=whos('-file',[inpath filename]);
[strv, ~] = varstring(var_list);

% load data
load([inpath filename]) %#ok<LOAD>

%% 1. Check ranges and replace out of range with NaN
% find out of range
if min(lat)<-40 || max(lat)>40 % it is different than the manual -
   % In e-mail exchange of 22.11.2021 (Ingrid + Christine) we agreed that the removal of negative temperature values will be done for south of 40°N and north of 40°S 
   ft=find(temp<-2.5|temp>40); %#ok<*NODEF>
else
   ft=find(temp<0|temp>40);
end
fs=find(sal<24|sal>41);
% replace out of range values 
temp(ft)=NaN;ptmp(ft)=NaN;sal(fs)=NaN;

% display the number of samples out of range
disp(['  ' num2str(numel(ft)) ' out of range temperature samples'])
disp(['  ' num2str(numel(fs)) ' out of range salinity samples'])

% get subindices of the cleaned values for the output 
% pre-allocate
FT=nan(numel(ft),2); FS=nan(numel(fs),2);
% temperature
for k=1:numel(ft)
    [a,b]=ind2sub(size(temp),ft(k));
    FT(k,:)=[b a];
end
% salinity
for k=1:numel(fs)
    [a,b]=ind2sub(size(sal),fs(k));
    FS(k,:)=[b a];
end

%% 2. Find incomplete triplets
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
% get indices of the incomplete samples
INC=[f2 f1];

% display the number of incomplete samples
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
pres=pres(1:max(n_samples),:); %#ok<*NASGU>
sal=sal(1:max(n_samples),:);
temp=temp(1:max(n_samples),:);
ptmp=ptmp(1:max(n_samples),:);

% saves new box file
if nargin<3
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end

% puts the information for the output together

noutput=[numel(lat) numel(ft) numel(fs) f1 f2]; % summary
% number of profiles in the beginning, number of temp samples out of range, number of
% salinity samples out of range, number of incomplete samples and number of
% profiles with incomplete samples

% puts all the information about the deleted samples and values in the 
% IND structure
% out of range temperature
if numel(ft)>0
   ind.outtemp=FT;
else
   ind.outtemp=[];
end
% out of range salinites
if numel(fs)>0
    ind.outsal=FS;
else
    ind.outsal=[];
end
% incomplete samples
if numel(ft)>0
   ind.incomplete=INC;
else
   ind.incomplete=[];
end
