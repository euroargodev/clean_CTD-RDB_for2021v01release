function [strv, nvar] = varstring(var_list)
% makes a string with the name of the variables given a list of variables 
% (var_list)as returned by "var_list = whos('-file',filein)". it also
% returns the numbe of variables (nvar)
nvar=numel(var_list); strv=[];
for i=1:nvar
    strv=[strv var_list{i} ' ']; %#ok<AGROW>
end