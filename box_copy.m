function box_copy(inpath,box,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Makes a copy of the box file with all its variables (version 7 to allow
% partial loading)
% Input: in and out paths and box number
% Author: Ingrid M. Angel-Benavides
%         BSH - EA-Rise
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Copying ' num2str(box) ' ...'])

filename=['ctd_' num2str(box)];

% get list of variables
var_list=whos('-file',[inpath filename]);
nvar=numel(var_list);
strv=[];
% load data and create a string
for i=1:nvar
    strv=[strv var_list(i).name ' '];
    eval(['load([inpath filename],' '''' var_list(i).name '''' ');'])
    if strcmp(var_list(i).class,'single')
        eval([var_list(i).name '=double(' var_list(i).name ');'])
    end
end


% saves file
if nargin<3
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end


