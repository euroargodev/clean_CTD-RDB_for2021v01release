function [perc_t,perc_s,confirm]=prof_compcontsimp(filein,ind,deept,th)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compares the contents of 2 TS profiles in a certain box
% The profiles are given by their indices (IND) and the path to the box file 
% (FILEIN).
% The comparison is done sample by sample (see function comp2prof.m)
% between the pressure levels given by the 2 element vector DEEPT and
% using 1 decimal digit for temperature and 2 decimal digits for salinity.
% The function returns the similarity of the profiles in
% percentage (PERC_T and PERC_S) and the CONFIRM variable that is 1 if the 
% profiles are content duplicates and 0 is they are not, taking into
% account the threshold of similarity TH, which is given as a fraction.
% For example if DEEPT = [800 2000] and TH = 0.95, the function will return a
% CONFIRM = 1 if the contents of the truncated salinity AND temperature 
% profiles are 95% equal between 800 and 2000 db.

% Input: 
% FILEIN is the box file. A full path plus filename must be provided 
%        if the file is not in the current folder.
% IND is a vector with the indices that are to be extracted.
% DEEPT is a two element vector giving the upper and lower pressure level
%       limits for the comparison
% TH is the fraction threshold to consider the profiles duplicates
% Output: 
% PERC_T and PERC_S are the outputs of comp2prof for temperature and
%                   salinity respectivey
% CONFIRM is 1 if the profiles are content duplicates and 0 is they are not. 
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compare profile content
data=extr_prof(filein,ind);
f=find(data.pres<=max(deept)&data.pres>=min(deept));
data.temp(f)=NaN;data.sal(f)=NaN;
perc_t = comp2prof(data.pres,data.temp,1);
perc_s = comp2prof(data.pres,data.sal,2);
% 
if perc_t >=th && perc_s >=th
   confirm=1;
else%if perc_t <75 && perc_s <75
   confirm=0;
%else 
%     plot_profpair(data)
%     tmp=input('Is this a duplicate? [1 yes] 0 no - ');
%     if isempty(tmp); tmp=1;end
%     if tmp>=0&&tmp<=1
%         confirm=tmp;
%     end  
end