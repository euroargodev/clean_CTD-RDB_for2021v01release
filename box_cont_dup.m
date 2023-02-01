function [ind,filename]=box_cont_dup(inpath,box,ipres)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checks for content duplicates comparing temperature and salinity
% interpolated to the levels given by IPRES
% Input: in (INPATH, string) and box number (BOX, number) and IPRES a 1 x n
% vector containig the n pressure levels to which the profiles
% will be interpolated 
% Output: 
% IND as the output of the FIND_DUP function
% FILENAME: is the full file name of the box being checked for duplicates
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de, ingrid.angelb@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename=[inpath 'ctd_' num2str(box) '.mat'];
disp(['Box number ' num2str(box)])

if nargin<3
    ipres=800:10:2000;
end

if isfile(filename)
    % interp data
    load(filename,'pres','temp','sal','long')
    [itemp,isal]=interp_profile_ipres(pres,temp,sal,ipres);
    % truncating temp
    itemp=truncate(itemp,1);
    % truncating sal
    isal=truncate(isal,2);
    %
    np=sum(isfinite(itemp),1);
    itemp(isfinite(itemp)==0)=0;
    nt=sum(itemp,1);
    isal(isfinite(isal)==0)=0;
    ns=sum(isal,1);
    
    header=[np' ns' nt'];
    % find indices
    [~,~,ib]=unique(header,'rows');
    if numel(unique(ib))<numel(long)
        disp('contains dupl')
        [dup,pair,ind]=find_dup(ib);
    else
        disp('nodupl')
        dup=[];pair=[];ind=[];
    end
else
    dup=[];pair=[];ind=[];
    disp('box does not exist')
end
