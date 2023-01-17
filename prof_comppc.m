function [w,d,dlabel]=prof_comppc(filein,ind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function compares the content of two profiles (pc, from profile content)
% and returns the index of the worst profile (W from "worst") and the
% reason why it was decided it was the worst profile in the form of an index 
% (D from "decision") that refers to the DLABEL cell, which contains all
% the possible reasons as text.
% The criteria used to decide which profile is worse/better are (in order of priority):
% - Salinity precision - sres -
% - Maximum recorded pressure - mrp - (only if the difference is larger than 50 dbar)
% - Data gap - gap - (only if is largest than 5 times the sampling distance)
% - Vertical resolution - vres - 
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
% W was the worst profile
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

% labels of each criteria
dlabel={'sres','mrp','gap','vres'};

% returns empty values if run with empty arguments
if isempty(filein)||isempty(ind)
    w=[];d=[];
else
    % extrats the profiles data
    data=extr_prof(filein,ind);    
    % calculates the salinity precision
    % obtains the median number of decimal digits of the salinity profiles 
    sres=[median(ndecimaldig(data.sal(:,1))) median(ndecimaldig(data.sal(:,2)))];
    
    % maximum recorded pressure
    mrp=round(max(data.pres,[],1),0);
    
    % vertical resolution
    % obtains the average number of samples per dbar (larger is better resolution)
    RP=max(data.pres,[],1)-min(data.pres,[],1);
    vres=round(RP./sum(isfinite(data.pres),1),1);
    
    % data gap
    % determines the larger vertical gap in the profiles
    mgap=max(diff(data.pres,1,1),[],1);
    % and compares it with the sample distance (sd)
    sd=1./vres;
    % if the gap is at least 5 times the sampling distance it is taken into
    % account. Otherwise it is ignored by assigning mgap.
    if mgap(1)<5*sd(1)
       mgap(1)=NaN;
    end
    if mgap(2)<5*sd(2)
       mgap(2)=NaN;
    end

    % Comparing all the criteria
    if diff(sres)==0 % 1. check salinity resolution
        if abs(diff(mrp))<50 % check maximum recorded pressure 
           %(only consider if the difference is larger than 50 db)
            if sum(isfinite(mgap))==0 % check the datagap
                if diff(vres)==0 % check the vertical resolution
                    w=0;d=0;
                else
                    [~,m]=min(vres);
                    w=m;d=4;
                end
            else
                [~,m]=min(mgap);
                w=m;d=3;
            end
        else
            [~,m]=min(mrp);
            w=m;d=2;
        end
    else
        [~,m]=min(sres);
        w=m;d=1;
    end
end