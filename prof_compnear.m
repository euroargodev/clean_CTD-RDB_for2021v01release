function near=prof_compnear(filein,ind,time_t,dist_t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Evaluates if the profiles with the indices (IND) present in the file 
% (FILEIN) are near to each other based on two thresholds: time difference 
% (TIME_T) in days and distance (DIST_T) in kilometers. 

% Input: 
% FILEIN is the box file. A full path plus filename must be provided 
%        if the file is not in the current folder.
% IND is a vector with the indices of the profiles that are to be evaluated.
% TIME_T is the time threshold in days
% DIST_T is the distance threshold in kilometers. 
%
% Output:
% NEAR is 1 if profiles are near (BOTH the distance and time difference are
% equal or smaller than the thresholds)
%
% OBS. Uses m_map to calculate the distances
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract profiles
data=extr_prof(filein,ind);
% calculate time differences and distance
daten=dates2daten(data.dates);% converts date format to date number
tdiff=abs(diff(daten)); % time difference in days
dist=m_lldist(data.long,data.lat); %distance
% checks if is near or not and assign value
if dist<=dist_t && tdiff<=time_t
    near=1;
else
    near=0;
end      
