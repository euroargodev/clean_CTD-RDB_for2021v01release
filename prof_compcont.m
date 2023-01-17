function [perc_t,perc_s,confirm]=prof_compcont(filein,ind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compares the contents of 2 TS profiles in a certain box
% The profiles are given by their indices (IND) and the path to the box file 
% (FILEIN).
% The comparison is done sample by sample (see function comp2prof.m) 
% using 1 decimal digit for temperature and 2 decimal digits for salinity.
% The function returns the similarity of the profiles in
% percentage (PERC_T and PERC_S) and the CONFIRM variable that is 1 if the 
% profiles are content duplicates and 0 is they are not. This is
% established based on the workflow described in the Fig 12. of the MOCCA 
% report 4.4.5 Report on the update of the CTD reference database for salinity 
% Delayed-Mode Quality Control in the Nordic Seas
% https://www.euro-argo.eu/content/download/142333/file/D4.4.5%20Report%20on%20the%20update%20of%20the%20CTD%20reference%20database%20for%20Salinity%20DMQC%20in%20the%20Nordic%20Seas_v1.0.pdf
% In some cases this function requires that the user takes a decision based
% on a visual comparison of the profiles.

% Input: 
% FILEIN is the box file. A full path plus filename must be provided 
%        if the file is not in the current folder.
%        IND is a vector with the indices that are to be extracted.
% Output: 
% PERC_T and PERC_S are the outputs of comp2prof for temperature and
%                   salinity respectivey
% CONFIRM is 1 if the profiles are content duplicates and 0 is they are not. 
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if numel(ind)>2
   disp(['WARNING: the function can only compare two profiles, it will compare'...
       ' the first two indices in the IND vector'])
end

% extract data from the box file
data=extr_prof(filein,ind);
% compare temperature 
perc_t = comp2prof(data.pres,data.temp,1);
% compares salinity
perc_s = comp2prof(data.pres,data.sal,2);

% Establishing if the profiles are content duplicates
% If both temperature and salinity have more than 95% of similarity the
% profiles are duplicates
if perc_t >=95 && perc_s >=95
   confirm=1;
% If both temperature and salinity have less than 75% of similarity the
% profiles are not duplicates
elseif perc_t <75 && perc_s <75
   confirm=0;
else % If either temperature or salinity have more than 75% of similarity
% the user makes a decision based on a visual comparison
    plot_profpair(data) % plots profiles
    % asks for user input
    tmp=input('Is this a duplicate? [1 yes] 0 no - '); % yes is the default
    % value if no input is given
    if isempty(tmp)
        tmp=1;
    end
    % check input and assign confirm variable
    if tmp==0 || tmp ==1
       confirm=tmp;
    else
       disp('Wrong input! either 1 (profiles are duplicates) or 0 (profiles are not duplicates)')
    end  
end