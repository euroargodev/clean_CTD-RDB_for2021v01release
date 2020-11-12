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



function [dup,pair,IND]=find_dup(ib)
n=numel(ib);
dup=false(1,n);% duplicate flag
pair=zeros(1,n); % duplicate number
count=0; % counts number of duplicates


for i=1:n
    % if it has not been yet identified as duplicate
    if dup(i)==0
        % checks how many profiles have that header
        ind=ib(i);
        f=find(ib==ind);
        % if more than one profile has that header: DUPLICATE!!
        if numel(f)>1
            % increase the duplicate counter
            count=count+1;
            % assign the duplicate number
            pair(f)=count;
            dup(f)=1;
            hd(count).ind=f;
        end
    end
end


hd1=hd;clear hd
count=0;
for i=1:numel(hd1)
    n=numel(hd1(i).ind);
    C = nchoosek(1:n,2);
    for j=1:size(C,1)
        count=count+1;
        hd(count).ind=hd1(i).ind(C(j,:));
    end
end

for i=1:numel(hd)
    IND(i,:)=hd(i).ind;
end