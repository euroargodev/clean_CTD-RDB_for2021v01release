function data=extr_prof(filein,ind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts the profiles with the indices (IND) present in the file 
% (FILEIN). Output is a structure (DATA)
% Input: 
% FILEIN is the box file. A full path plus filename must be provided 
%        if the file is not in the current folder.
% IND is a vector with the indices that are to be extracted.
% Output: 
% DATA structure containing all the profile info without filling NaNs
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de, ingrid.angelb@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get list of variables
var_list=whos('-file',filein);
nvar=numel(var_list);

% load data
if isempty(ind)==0
    for i=1:nvar
        eval(['load ' filein ' ' var_list(i).name])
        if var_list(i).size(1) ==1 && strcmp(var_list(i).class,'char')==0
            eval(['tmp=' var_list(i).name '(ind);' ])
            eval(['data.' var_list(i).name '=tmp;']);
        elseif strcmp(var_list(i).class,'char')
        else
            eval(['tmp=' var_list(i).name '(:,ind);' ])
            eval(['data.' var_list(i).name '=tmp;']);
        end
    end
end

% removes lines filled only with nans if they exist
if isfield(data,'pres')
    f=find(sum(isnan(data.pres),2)==size(data.pres,2)); %#ok<*NODEF>
    if isempty(f)==0
        data.pres(f,:)=[];data.temp(f,:)=[];data.ptmp(f,:)=[];data.sal(f,:)=[];
    end
end