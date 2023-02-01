function [itemp,isal]=interp_profile_ipres(pres,temp,sal,ipres)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolates boxes data (pres,temp,sal) to standard pressure levels given
% by ipres.
% Input:
% PRES is a ns x 2 matrix containing pressure, where ns is the (maximum*) number of
% samples
% TEMP is a ns x 2 matrix containing the temperature values 
% SAL is a ns x 2 matrix containing the salinity values 
% IPRES  is a 1 x n vector containig the n pressure levels to which the profiles
% will be interpolated 
% Output:
% ITEMP and ISAL are the TEMP and SAL matrices interpolated to the IPRES
% values
% Author: Ingrid M. Angel-Benavides
%         BSH - MOCCA/EA-Rise (Euro-Argo)
%        (ingrid.angel@bsh.de, ingrid.angelb@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    ix2=find(isnan(pres(:,i))==0); %#ok<COMPNOT>
    % selecting only valid data
    ix=intersect(ix1,ix2);
    % interpolating
    if isempty(ix)==0
    itemp(:,i)=interp1(pres(ix,i),temp(ix,i),ipres');
    isal(:,i)=interp1(pres(ix,i),sal(ix,i),ipres');
    end
end