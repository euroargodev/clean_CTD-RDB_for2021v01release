function ndd = ndecimaldig(vec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the number of decimal digits (NND) for each element of a
% numerical vector (VEC)
% Input: 
% VEC is a vector of numerical values
% Output: 
% NDD is the number of decimal digits for each element
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% selects only the numerical data (excludes nan)
vec=vec(isfinite(vec));
% preallocate output
ndd = zeros(numel(vec),1);
for i=1:numel(vec) % for each element / sample
    % converts to string
    tmp=num2str(vec(i));
    % splits the string in the . separator
    tmp=strsplit(tmp,'.');
    if numel(tmp)==1 
       % if the value has no decimal point the number of decimal digits is
       % 0
        ndd(i,1)=0;
    else
        % otherwhise checks the number of characters after the decimal
        % digit
        tmp=tmp{2};
        ndd(i,1)=numel(tmp);
    end
end