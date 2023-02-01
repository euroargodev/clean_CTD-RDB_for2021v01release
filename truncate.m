function vec=truncate(vec,dd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function truncates a number to a certain number of digits after the
% decimal point (different than rounding)
% Input: 
% VEC is the vector to be truncted
% DD is the desired number of digits after the decimal point
% Output: 
% VEC is the modified (truncated) vector 
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de, ingrid.angelb@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(vec)
    % get value
    tmp=vec(i);
    % transform to string
    tmp=num2str(tmp);
    % decimal point position
    dpp=strfind(tmp,'.');
    % get the number with the desired decimal digits
    ind=min([dpp+dd numel(tmp)]);
    tmp=tmp(1:ind);
    % transform back to number
    vec(i)=str2double(tmp);
end