function box_copy(inpath,box,outpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Makes a copy of the box file with all its variables (version 7 to allow
% partial loading)
% Input: in (INPATH) and out (OUTPATH) paths and box number (BOX)
% Output: no variable, but a new mat file in disk.
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['Copying ' num2str(box) ' ...'])
filename=['ctd_' num2str(box)];

% get list of variables (default)
var_list={'dates';'lat';'long';'pres';'ptmp';'qclevel';'sal';'source';'temp'};

% makes a string for saving the new matfile later
[nvar, strv] = varstring(var_list);

% get variables in file
fvar_list=whos('-file',[inpath filename]);
for i=1:numel(fvar_list)
    tmp{i}=fvar_list(i).name; %#ok<AGROW>
end
fvar_list=tmp;clear tmp

% for each required variable: 
% - finds the corresponding variable in the file,
% this includes checking if the variable name is written in upper case, 
% a bit different (ptemp vs ptmp, psal vs sal) or with another name (dates
% vs juld)
% - loads the variable and saves it in the copy file with the required name
% (as in var_list)
% - if the variable is numeric, converts it to double type
% In case that the qclevel variable is not available, then it gives the
% option to assign a (unique) value for all the profiles in the file
for i=1:nvar
    % find and load the variables
    f=find(contains(fvar_list,var_list{i}));
    if isempty(f)
        f=find(contains(fvar_list,upper(var_list{i})));
        if strcmp(var_list{i},'ptmp')
            f=find(contains(fvar_list,'ptemp'));
            if isempty(f)
                f=find(contains(fvar_list,upper('ptemp')));
            end
        elseif strcmp(var_list{i},'sal')
            f=find(contains(fvar_list,'psal'));
            if isempty(f)
                f=find(contains(fvar_list,upper('psal')));
            end
        elseif strcmp(var_list{i},'dates')
            f=find(contains(fvar_list,'juld'));
            if isempty(f)
                f=find(contains(fvar_list,upper('juld')));
            end
            eval(['load([inpath filename],' '''' fvar_list{f} '''' ');'])
            eval([var_list{i} '=' fvar_list{f} ';'])
        end
        if isempty(f) && strcmp(var_list{i},'qclevel')
            disp('Box without qclevel. Please assign a string that will be applied for all profiles.')
            disp('path:')
            disp(inpath)
            qclevel{1}=input('string :');
            qclevel=repmat(qclevel{1}, size(lat));
        end
        if isempty(f) && strcmp(var_list{i},'source')
            disp('Box without source. Please assign a string that will be applied for all profiles.')
            disp('path:')
            disp(inpath)
            source{1}=input('string :');
            source=repmat(source{1}, size(lat));
        end
    else
        eval(['load([inpath filename],' '''' fvar_list{f} '''' ');'])
        eval([var_list{i} '=' fvar_list{f} ';'])        
    end
    clear f    
    % change type of numeric variables
    if eval(['isa(' var_list{i} ',' '''' 'single' '''' ')'])
        eval([var_list{i} '=double(' var_list{i} ');'])
    end
end

% saves file
if nargin<3 % in the local folder if no outpath folder is specified
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end