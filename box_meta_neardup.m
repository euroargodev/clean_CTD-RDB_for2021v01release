function [ind,filename]=box_meta_neardup(inpath,box)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checks for near metadata duplicates: similar latitude and longitude
% Similarity is checked by truncating values
% Input: in (INPATH, string) and box number (BOX, number)

% Output: 
% IND is the outputs of the FIND_DUP function but only for those profiles
% that have similar (truncated positions) and are less than one day appart
% in time.
% FILENAME: is the full file name of the box being checked for duplicates
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de, ingrid.angelb@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gets full filename for loading the box data
filename=[inpath 'ctd_' num2str(box) '.mat'];
disp(['Box number ' num2str(box)])

if isfile(filename)% if the file exists
    % gets the metadata variables
    load(filename,'long','lat','dates')
    
    % Similarity
    % truncating position - check if positions are similar using only one 
    % decimal digit
    lat=truncate(lat,1);
    long=truncate(long,1);
    
    % creates a matrix with those modified variables
    header=[double(lat)' double(long)'];
     % uses the unique function to find duplicates
    [~,~,ib]=unique(header,'rows'); % the 'rows' options treat each row of 
    % the input (header) as a single entity. the output ib contains indices
    % that satisfies header = uniquevalues(ib,:). %see unique help 
    % checks if there are duplicates
    
    if numel(unique(ib))<numel(long)% if the number of unique rows is less
        % than the number of rows then there are duplicates
        disp('contains dupl')
        % find duplicates
        [~,~,ind]=find_dup(ib);%[dup,pair,ind]=find_dup(ib);
        % check if the duplicates are near in time 
        daten=dates2daten(dates); % the units of datenum are days
        kp=false(1,size(ind,1));
        for i=1:size(ind,1)
            kp(i)=abs(diff(daten(ind(i,:))))<1; % so in this case it is 
            % checked if the duplicates are 1 day appart.
            % kp = 1 if the time difference between the profiles is less
            % than 1 day
        end
        % keep only duplicates that are near in time
        ind=ind(kp,:);        
    else
        disp('nodupl')
        ind=[];%dup=[];pair=[];
    end
else
    ind=[];%dup=[];pair=[];
    disp('box does not exist')
end