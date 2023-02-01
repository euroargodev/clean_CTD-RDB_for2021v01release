function [strv, nvar] = varstring(var_list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function makes a string with the name of the variables separated by
% spaces given a cell list of variables (var_list)as returned by 
% "var_list = whos('-file',filein)" 
% which is appropriate to use to save files using the eval function. It also
% returns the number of variables (nvar)
% Input: 
% VAR_LIST: cell list of strings as returned by  "var_list = whos('-file',filein)" 
% % Output: 
% STRV: string with values of VAR_LIST separated by spaces
% NVAR: number of elements in the var_list
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de, ingrid.angelb@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(var_list)
   tmp=var_list;clear var_list
   for i=1:numel(tmp)
       var_list{i}=tmp(i).name;
   end
end

nvar=numel(var_list); strv=[];
for i=1:nvar
    strv=[strv var_list{i} ' ']; %#ok<AGROW>
end