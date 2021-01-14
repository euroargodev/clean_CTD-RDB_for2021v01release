function data=extr_prof(filein,ind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts the profiles with the indices (IND) present in the file 
% (FILEIN). Output is a structure (DATA)
%
% Author: Ingrid M. Angel-Benavides
%         BSH - MOCCA/EA-Rise (Euro-Argo)
%        (ingrid.angel@bsh.de)
% Last update: 09.10.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var_list=whos('-file',filein);
nvar=numel(var_list);

% get list of variables
var_list=whos('-file',filein);
strv=[];
for i=1:nvar
    strv=[strv var_list(i).name ' '];
end
nvar=numel(var_list);

% get data
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