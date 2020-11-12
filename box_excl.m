function  box_excl(inpath,box,excl,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excludes all profiles in a box file according to the provided 
% list of indices (EXCL) and saves it in another matfile
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Excluding  profiles from box ' num2str(box) ' ...'])
filename=['ctd_' num2str(box)];

% get list of variables
var_list=whos('-file',[inpath filename]);
nvar=numel(var_list);
strv=[];
for i=1:nvar
    strv=[strv var_list(i).name ' '];
end

% load data & exclude data
nvar=numel(var_list);
% exclude profiles
if isempty(excl)==0   
    for i=1:nvar
        eval(['load ' inpath filename ' ' var_list(i).name])
        if var_list(i).size(1) ==1
            eval([var_list(i).name '(excl)=[];' ])
        else
            eval([var_list(i).name '(:,excl)=[];' ])
        end
    end
    disp(['  ' num2str(numel(excl)) ' profiles were deleted'])
else
    eval(['load ' inpath filename ])
    disp('  no profiles were deleted')
end


% saves file
if nargin<4
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end