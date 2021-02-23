clear variables
% Extract info and getting original indices
%% A1/ 
out='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\';
load([out 'a1_results.mat'])

for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    % bad samples
    for j=1:numel(boxlist)       
        if isempty(badsamples{i,j})==0
            ofr_S1{i,j}=badsamples{i,j}.outsal;
            ofr_T1{i,j}=badsamples{i,j}.outtemp;
            inc_samples1{i,j}=badsamples{i,j}.incomplete;
        else
            ofr_S1{i,j}=[];
            ofr_T1{i,j}=[];
            inc_samples1{i,j}=[];
        end
    end
    % bad profiles
    for j=1:numel(boxlist)
        N=output{i}(j,1);
        if isfinite(N)
            ind=1:N;
            ind0{i,j}=ind;
            excl=EXCL_all{i,j};
            if isempty(excl)
                ind1{i,j}=ind;
                excl1{i,j}=[];
                outofbox1{i,j}=[];
                shallow1{i,j}=[];
                nonmonotpres1{i,j}=[];
                extraprof1{i,j}=[];
            else
                tmp=ind;tmp(excl)=[];
                ind1{i,j}=tmp;
                excl1{i,j}=excl;
                outofbox1{i,j}=EXCL{i,j}{1};
                shallow1{i,j}=EXCL{i,j}{2};
                nonmonotpres1{i,j}=EXCL{i,j}{3};
                extraprof1{i,j}=EXCL{i,j}{4};
            end
        else
            ind1{i,j}=[];
            excl1{i,j}=[];
            outofbox1{i,j}=[];
            shallow1{i,j}=[];
            nonmonotpres1{i,j}=[];
            extraprof1{i,j}=[];
        end
    end
end
clear bad* excl EXCL* i ind j N output output_label tmp boxlist

%% A2/
load([out 'a2_results.mat'])
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        indpairs=IND{i,j};
        ind=ind1{i,j};
        if isempty(indpairs)==0
            % get the original index for the pairs
            pairs2{i,j}=ind(indpairs);
            excl=ind(EXCL{i,j});
            if isempty(excl)
                ind2{i,j}=ind;
                excl2{i,j}=[];
            else
                tmp=ind;tmp(EXCL{i,j})=[];
                ind2{i,j}=tmp;
                excl2{i,j}=excl;
            end
        else
            ind2{i,j}=ind;
            pairs2{i,j}=[];
            excl2{i,j}=[];
        end
    end
end

% getting exclusion details
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        if isempty(pairs2{i,j})==0
            tmp=pairs2{i,j};
            pairdet2{i,j}=[pairs2{i,j} CONF{i,j} SKI{i,j} PERCT{i,j} PERCS{i,j}];
            f=find(CONF{i,j}==1&SKI{i,j}==0);
            % check if it was deleted
            if isempty(excl2{i,j})==0
                pairdes2{i,j}=[pairs2{i,j}(f,1) ismember(pairs2{i,j}(f,1),excl2{i,j})...
                    pairs2{i,j}(f,2) ismember(pairs2{i,j}(f,2),excl2{i,j})...
                    DES{i,j}(f) DES2{i,j}(f)];
            end
        end
    end
end

pairdet2_label={'ind1','ind2','confirmed','skipped','temp. simil.','sal. simil.'};
pairdes_label={'ind1','excl1','ind2','excl2','decision1','decision2'};
des1_label={'profile','origin'};
des1_1_des2label=dlabel1;
des1_2_des2label=dlabel2;

clear CONF DES* dlabel* excl EXCL f i IND j PERC* SKI output output_Label

%% A3/
load([out 'a3_results.mat'])
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        indpairs=IND{i,j};
        ind=ind2{i,j};
        if isempty(indpairs)==0
            % get the original index for the pairs
            pairs3{i,j}=ind(indpairs);
            excl=ind(EXCL{i,j});
            if isempty(excl)
                ind3{i,j}=ind;
                excl3{i,j}=[];
            else
                tmp=ind;tmp(EXCL{i,j})=[];
                ind3{i,j}=tmp;
                excl3{i,j}=excl;
            end
        else
            ind3{i,j}=ind;
            pairs3{i,j}=[];
            excl3{i,j}=[];
        end
    end
end

% getting exclusion details
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        if isempty(pairs3{i,j})==0
            tmp=pairs3{i,j};
            pairdet3{i,j}=[pairs3{i,j} CONF{i,j} SKI{i,j} NEAR{i,j} PERCT{i,j} PERCS{i,j}];
            f=find(CONF{i,j}==1&SKI{i,j}==0);
            % check if it was deleted
            if isempty(excl3{i,j})==0
                pairdes3{i,j}=[pairs3{i,j}(f,1) ismember(pairs3{i,j}(f,1),excl3{i,j})...
                    pairs3{i,j}(f,2) ismember(pairs3{i,j}(f,2),excl3{i,j})...
                    DES{i,j}(f) DES2{i,j}(f)];
            end
        end
    end
end
pairdet3_label={'ind1','ind2','confirmed','skipped','near','temp. simil.','sal. simil.'};

clear CONF DES* dlabel* excl NEAR tmp EXCL f i ind indpairs IND j PERC* SKI output output_label 

%% A4/
load([out 'a4_results.mat'])
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        indpairs=IND{i,j};
        ind=ind3{i,j};
        if isempty(indpairs)==0
            % get the original index for the pairs
            pairs4{i,j}=ind(indpairs);
            excl=ind(EXCL{i,j});
            if isempty(excl)
                ind4{i,j}=ind;
                excl4{i,j}=[];
            else
                tmp=ind;tmp(EXCL{i,j})=[];
                ind4{i,j}=tmp;
                excl4{i,j}=excl;
            end
        else
            ind4{i,j}=ind;
            pairs4{i,j}=[];
            excl4{i,j}=[];
        end
    end
end

% getting exclusion details
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        if isempty(pairs4{i,j})==0
            tmp=pairs4{i,j};
            pairdet4{i,j}=[pairs4{i,j} CONF{i,j} SKI{i,j} PERCT{i,j} PERCS{i,j}];
            f=find(CONF{i,j}==1&SKI{i,j}==0);
            % check if it was deleted
            if isempty(excl4{i,j})==0
                pairdes4{i,j}=[pairs4{i,j}(f,1) ismember(pairs4{i,j}(f,1),excl4{i,j})...
                    pairs4{i,j}(f,2) ismember(pairs4{i,j}(f,2),excl4{i,j})...
                    DES{i,j}(f) DES2{i,j}(f)];
            end
        end
    end
end
pairdet4_label={'ind1','ind2','confirmed','skipped','temp. simil.','sal. simil.'};

clear CONF DES* dlabel* excl NEAR tmp EXCL f i ind indpairs IND j PERC* SKI output output_label  boxlist out
save removed_indices.mat