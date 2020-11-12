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

