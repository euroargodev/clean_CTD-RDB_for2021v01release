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