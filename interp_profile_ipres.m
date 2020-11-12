%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interp_profile_ipres 
% Interpolates boxes data (pres,temp,sal) to standard pressure levels given
% by ipres
% Author: Ingrid M. Angel-Benavides
%         BSH - MOCCA/EA-Rise (Euro-Argo)
%        (ingrid.angel@bsh.de)
% Last update: 09.10.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [itemp,isal]=interp_profile_ipres(pres,temp,sal,ipres)
% preallocate output
n=size(temp,2);
itemp=nan(numel(ipres),n);
isal=itemp;nan(numel(ipres),n);
% loop for profiles
for i=1:n
    %finds 
    % unique pressure values
    [~,ix1] = unique(pres(:,i));
    % valid data
    ix2=find(isnan(pres(:,i))==0);
    % selecting only valid data
    ix=intersect(ix1,ix2);
    % interpolating
    if isempty(ix)==0
    itemp(:,i)=interp1(pres(ix,i),temp(ix,i),ipres');
    isal(:,i)=interp1(pres(ix,i),sal(ix,i),ipres');
    end
end