function [dup,pair,ind,filename]=box_meta_dup(inpath,box)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checks for metadata duplicates: same latitude, longitude and date 
% Input: in (INPATH, string) and box number (BOX, number)
% Output: 
% DUP, PAIR and IND are the outputs of the FIND_DUP function
% FILENAME: is the full file name of the box being checked for duplicates
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gets full filename for loading the box data
filename=[inpath 'ctd_' num2str(box) '.mat'];
disp(['Box number ' num2str(box)])

if isfile(filename)% if the file exists
    % gets the metadata variables
    load(filename,'long','lat','dates')
    % creates a matrix with those variables
    header=[double(lat)' double(long)' double(dates')];
    % uses the unique function to find duplicates
    [~,~,ib]=unique(header,'rows'); % the 'rows' options treat each row of 
    % the input (header) as a single entity. the output ib contains indices
    % that satisfies header = uniquevalues(ib,:). %see unique help 
    % checks if there are duplicates
    if numel(unique(ib))<numel(long) % if the number of unique rows is less
        % than the number of rows then there are duplicates
        disp('contains dupl')
        [dup,pair,ind]=find_dup(ib);        
    else % otherwise no duplicates
        disp('nodupl')
        dup=[];pair=[];ind=[];
    end
else % if the file does not exist
    dup=[];pair=[];ind=[];
    disp('box does not exist')
end