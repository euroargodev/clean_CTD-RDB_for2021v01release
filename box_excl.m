function  box_excl(inpath,box,excl,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excludes all profiles in a box file according to the provided 
% list of indices (EXCL) and saves it in another matfile.
% INPUT: in (INPATH) and out (OUTPATH) paths, box number (BOX) and indices
% of the files to be exluded (EXCL)
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['Excluding  profiles from box ' num2str(box) ' ...'])
filename=['ctd_' num2str(box)];

% get list of variables
var_list=whos('-file',[inpath filename]);
% makes a string for saving the new matfile later
[nvar, strv] = varstring(var_list);

% exclude profiles
if isempty(excl)==0   
    for i=1:nvar
        eval(['load ' inpath filename ' ' var_list(i).name])
        if var_list(i).size(1) ==1 % metadata
            eval([var_list(i).name '(excl)=[];' ])
        else % profiles
            eval([var_list(i).name '(:,excl)=[];' ])
        end
    end
    disp(['  ' num2str(numel(excl)) ' profiles were deleted'])
else
    eval(['load ' inpath filename ])
    disp(' no profiles were deleted')
end

% saves file
if nargin<4 % in the local folder if no outpath folder is specified
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end