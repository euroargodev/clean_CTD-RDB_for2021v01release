function [w,wqcl,wsrc,d,dlabel,qcl]=prof_compqc(filein,ind,qc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function compares the origin of two profiles (qc, from qc level)
% and returns the index of the best profile (W from "winner") and the
% reason why it was decided it was the best profile in the form of an index 
% (D from "decision") that refers to the DLABEL cell, which contains 
% the possible reasons as text. It also returns the qclevel and source
% value of the worst profile.
% The criteria used to decide which profile is worse/better are 
% (in order of priority):
% 
% The profiles are given by their indices (IND) and the path to the box file 
% (FILEIN).
%
% Input: 
% FILEIN is the box file. A full path plus filename must be provided 
%        if the file is not in the current folder.
% IND is a vector with the indices that are to be compared.
% Output:
% W index of the worst profile
% D index (related to DLABEL) indicating the reason why it was decided that
% W was the worse profile
% DLABEL cell: which contains all the possible reasons as text
% 
% See also Section 7.2.3 of the MOCCA 
% report 4.4.5 Report on the update of the CTD reference database for salinity 
% Delayed-Mode Quality Control in the Nordic Seas
% https://www.euro-argo.eu/content/download/142333/file/D4.4.5%20Report%20on%20the%20update%20of%20the%20CTD%20reference%20database%20for%20Salinity%20DMQC%20in%20the%20Nordic%20Seas_v1.0.pdf
%  
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if numel(ind)>2
   disp(['WARNING: the function can only compare two profiles, it will compare'...
       ' the first two indices in the IND vector'])
end

% defining the default qclevel priority in the case that none was provided
if nargin<3
   qc={'SPI','GSD','GSH','CCH','DPY','UDA','PAN','BSH','OCL','COR','ICE'};
end

% labels of each criteria
dlabel={'qclevel','source'};

% returns empty values if run with empty arguments
if isempty(filein)||isempty(ind)
    w=[];d=[];wqcl=[];wsrc=[];qcl=[];
else 
    % extracts the profiles data
    data=extr_prof(filein,ind);
    
    % evaluates the qclevel
    for i=1:2
        % find the position of the qclevel value in the priority list qc
        if isempty(find(strcmp(data.qclevel(i),qc)==1))==0 %#ok<EFIND>
            qcl(i)=find(strcmp(data.qclevel(i),qc)==1); %#ok<*AGROW>
        else
            disp('The qclevel of one profile is ')
            disp(data.qclevel(i))
            disp(', which is not included in the qc priority list')
        end
    end
    
    % finds the worst qclevel
    if diff(qcl)==0
        wqcl=0;
    else
        [~,m]=max(qcl);
        wqcl=m;
    end
 
    %%%% for ices also extracts the source value that seems to be assigned
    %%%% at the end of the file. I think this comes from the way the source
    %%%% value was assigned for ices profiles coming through coriolis. This
    %%%% needs to be checked to see if can be removed in the next versions 
    %%%% since look that it was to solve a very specific problem!!
    fices=find(ismember(qcl,find(contains(qc,'ICE'))));
    if isempty(fices)==0
        for ii=1:numel(fices) 
            s=data.source(fices(ii));
            s=strsplit(s{1},'_');
            if numel(s)==3
                s2=s{3};
            elseif numel(s)==1
                s2=s{1};
            end
            data.source{fices(ii)}=s2;
        end
    end
    %%%%%
    
    % evluates the source. this only applies if the source is a number and
    % the number indicates which profile is newer (newer profiles
    % pressumably have better quality)
    src=[str2double(data.source(1)) str2double(data.source(2))];
    
    % finds the worst source
    if sum(isnan(src))==0
        if src(1)==src(2)
            wsrc=0;
        else
            [~,m]=min(src);
            wsrc=m;
        end
    else % in case that the source does not give info of better\worst profile
        wsrc=NaN;
    end
    
    % initially w is defined to have 1-0 values if there is - there is not-
    % a worst profile taking into account its qclevel (first value) 
    % and its source (second value)
    w=[wqcl>0 isfinite(wsrc)];
    % then depending in the combinations it is decided which is the worst
    % profile (w) and the reason why
    if sum(w==[0 1])==2 % if only source provides info (same qclevel)
        w=wsrc;d=2;
    elseif sum(w==[0 0])==2 % if none provides info
        w=0;d=0;
    elseif sum(w==[1 0])==2 || sum(w==[1 NaN])==2 % if only the qclevel provides info
        w=wqcl;d=1;
    elseif sum(w==[1 1])==2 % if both provide info
        if wsrc==0
            w=wqcl;d=1;
        else
            w=wsrc;d=2;
        end
    end
end