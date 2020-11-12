function box_sortdates(inpath,box,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Makes a copy of the box file with all its variables (version 7 to allow
% partial loading) but sorted by dates
% Input: in and out paths and box number
% Author: Ingrid M. Angel-Benavides
%         BSH - EA-Rise
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Sorting box ' num2str(box) ' by date'])
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

% sort by date
[B,I] = sort(dates);
for j=1:numel(var_list)
    eval(['tmp=' var_list(j).name ';']);
    if size(tmp,1)==1 % if is a vector variable and not a cell array
        tmp=tmp(I);
    else % if matrix
        tmp=tmp(:,I);
    end
    %assign to variable
    eval([var_list(j).name '=tmp;']);
    clear tmp
end

% saves file
if nargin<3
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end