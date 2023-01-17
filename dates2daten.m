function daten=dates2daten(dates)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function converts the Argo CTD reference database date format
% yyyymmddHHMMSS in the matlab serial date numbers (day units)
% 
% Input: 
% DATES vector with yyyymmddHHMMSS (double) dates
% Output: vector with matlab serial date numbers (day units)
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% preallocate output
daten=zeros(size(dates)); 
for i=1:numel(daten) % for each date
    % convert to string
    Date_1=num2str(dates(i));
    % separate the dates into a date vector [yyyy mm dd hh mm ss]
    full_time_1=[str2double(Date_1(1:4)) str2double(Date_1(5:6))...
        str2double(Date_1(7:8)) str2double(Date_1(9:10))...
        str2double(Date_1(11:12)) str2double(Date_1(14:14))];
    % convert to date number
    daten(i)= datenum(full_time_1);
end