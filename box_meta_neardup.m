function [ind,filename]=box_meta_neardup(inpath,box)
%inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2018V02\';
%box=1701;
filename=[inpath 'ctd_' num2str(box) '.mat'];
disp(['Box number ' num2str(box)])

if isfile(filename)
    % get header
    load(filename,'long','lat','dates')
    
    % rounding
    %dates=(floor((dates)./1000000));
    lat=truncate(lat,1);
    long=truncate(long,1);
    
    header=[double(lat)' double(long)'];% just in case
    % find indices
    [~,~,ib]=unique(header,'rows');
    if numel(unique(ib))<numel(long)
        disp('contains dupl')
        [dup,pair,ind]=find_dup(ib);
        % check if the duplicates are near in time
        daten=dates2daten(dates);
        kp=false(1,size(ind,1));
        for i=1:size(ind,1)
            kp(i)=abs(diff(daten(ind(i,:))))<1;
        end
        ind=ind(kp,:);
        
    else
        disp('nodupl')
        dup=[];pair=[];ind=[];
    end
else
    dup=[];pair=[];ind=[];
    disp('box does not exist')
end