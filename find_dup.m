function [dup,pair,IND]=find_dup(ib)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% From the third output of the matlab unique function, it extracts
% information about the duplicates.
% INPUT: IB third output from the matlab unique function,
% OUTPUT: 
% DUP duplicate flag (is this element duplicated? yes = 1 no = 0)
% PAIR: duplicate number (for identifying the duplicate group)
% IND: a 2 column matrix containing all combinations of duplicated elements
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=numel(ib);
% preallocate outputs
dup=false(1,n);% duplicate flag (is this element duplicated? yes = 1 no = 0)
pair=zeros(1,n); % duplicate number 
count=0; % counts number of duplicates

% for each element 
for i=1:n
    % if it has not been yet identified as duplicate
    if dup(i)==0
        % checks how many elements (aka. profiles) have that index (ex. same header)
        f=find(ib==ib(i));
        % if more than one profile has that index: that element (profile)
        % is DUPLICATED!!
        if numel(f)>1 
            count=count+1;% increase the duplicate counter
            % assign a duplicate number to all the duplicated elements
            pair(f)=count;
            % assign 1 to the duplicate flag 
            dup(f)=1;
            % store info in a structure (hd) with the indices of each 
            % duplicate group(one element may be duplicated more than once)
            hd(count).ind=f;
        end
    end
end

% now for each duplicated element
hd1=hd;clear hd
count=0;
for i=1:numel(hd1)
    % check how many times is the element present
    n=numel(hd1(i).ind);
    % generates all possible combinations (Binomial coefficient or all
    % combinations)
    C = nchoosek(1:n,2);
    % store each combination
    for j=1:size(C,1)
        count=count+1;
        hd(count).ind=hd1(i).ind(C(j,:));
    end
end

% IND is a 2 column matrix containing all combinations of duplicated elements.
for i=1:numel(hd)
    IND(i,:)=hd(i).ind;
end