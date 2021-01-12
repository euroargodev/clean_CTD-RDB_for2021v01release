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

% get list of variables (default)
var_list={'dates';'lat';'long';'pres';'ptmp';'qclevel';'sal';'source';'temp'};
nvar=numel(var_list);
strv=[];
for i=1:nvar
    strv=[strv var_list{i} ' '];
end

% in file
fvar_list=whos('-file',[inpath filename]);
for i=1:numel(fvar_list)
    tmp{i}=fvar_list(i).name;
end
fvar_list=tmp;clear tmp

% load data and create a string
for i=1:nvar
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
    else
        eval(['load([inpath filename],' '''' fvar_list{f} '''' ');'])
        eval([var_list{i} '=' fvar_list{f} ';'])
        
    end
    
    clear f    
    if eval(['isa(' var_list{i} ',' '''' 'single' '''' ')'])
        eval([var_list{i} '=double(' var_list{i} ');'])
    end
end

% saves file
if nargin<3
    eval(['save ' filename ' ' strv ' -v7.3'])
else
    eval(['save ' outpath filename ' ' strv ' -v7.3']);
end


