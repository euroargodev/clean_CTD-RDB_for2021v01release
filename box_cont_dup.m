function [ind,filename]=box_cont_dup(inpath,box,ipres)

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
