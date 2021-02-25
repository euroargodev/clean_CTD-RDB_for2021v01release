function F5_get_orindices(file1,file2,file3,file4,fileout)
% Extract info and getting original indices
load(file1)
% bad samples
for j=1:numel(boxlist)
    if isempty(badsamples{1,j})==0
        ofr_S1{1,j}=badsamples{1,j}.outsal;
        ofr_T1{1,j}=badsamples{1,j}.outtemp;
        inc_samples1{1,j}=badsamples{1,j}.incomplete;
    else
        ofr_S1{1,j}=[];
        ofr_T1{1,j}=[];
        inc_samples1{1,j}=[];
    end
end
% bad profiles
for j=1:numel(boxlist)
    N=output{1}(j,1);
    if isfinite(N)
        ind=1:N;
        ind0{1,j}=ind;
        excl=EXCL_all{1,j};
        if isempty(excl)
            ind1{1,j}=ind;
            excl1{1,j}=[];
            outofbox1{1,j}=[];
            shallow1{1,j}=[];
            nonmonotpres1{1,j}=[];
            extraprof1{1,j}=[];
        else
            tmp=ind;tmp(excl)=[];
            ind1{1,j}=tmp;
            excl1{1,j}=excl;
            outofbox1{1,j}=EXCL{1,j}{1};
            shallow1{1,j}=EXCL{1,j}{2};
            nonmonotpres1{1,j}=EXCL{1,j}{3};
            extraprof1{1,j}=EXCL{1,j}{4};
        end
    else
        ind1{1,j}=[];
        excl1{1,j}=[];
        outofbox1{1,j}=[];
        shallow1{1,j}=[];
        nonmonotpres1{1,j}=[];
        extraprof1{1,j}=[];
    end
end

clear bad* excl EXCL* i ind j N output output_label tmp boxlist

% FILE2
load(file2)
for j=1:numel(boxlist)
    indpairs=IND{1,j};
    ind=ind1{1,j};
    if isempty(indpairs)==0
        % get the original index for the pairs
        pairs2{1,j}=ind(indpairs);
        excl=ind(EXCL{1,j});
        if isempty(excl)
            ind2{1,j}=ind;
            excl2{1,j}=[];
        else
            tmp=ind;tmp(EXCL{1,j})=[];
            ind2{1,j}=tmp;
            excl2{1,j}=excl;
        end
    else
        ind2{1,j}=ind;
        pairs2{1,j}=[];
        excl2{1,j}=[];
    end
end

% getting exclusion details
for j=1:numel(boxlist)
    if isempty(pairs2{1,j})==0
        tmp=pairs2{1,j};
        pairdet2{1,j}=[pairs2{1,j} CONF{1,j} SKI{1,j} PERCT{1,j} PERCS{1,j}];
        f=find(CONF{1,j}==1&SKI{1,j}==0);
        % check if it was deleted
        if isempty(excl2{1,j})==0
            pairdes2{1,j}=[pairs2{1,j}(f,1) ismember(pairs2{1,j}(f,1),excl2{1,j})...
                pairs2{1,j}(f,2) ismember(pairs2{1,j}(f,2),excl2{1,j})...
                DES{1,j}(f) DES2{1,j}(f)];
        end
    else
       pairdet2{1,j}=[];
       pairdes2{1,j}=[];
    end
end

pairdet2_label={'ind1','ind2','confirmed','skipped','temp. simil.','sal. simil.'};
pairdes_label={'ind1','excl1','ind2','excl2','decision1','decision2'};
des1_label={'profile','origin'};
des1_1_des2label=dlabel1;
des1_2_des2label=dlabel2;

clear CONF DES* dlabel* excl EXCL f i IND j PERC* SKI output output_Label

% FILE3
load(file3)
for j=1:numel(boxlist)
    indpairs=IND{1,j};
    ind=ind2{1,j};
    if isempty(indpairs)==0
        % get the original index for the pairs
        pairs3{1,j}=ind(indpairs);
        excl=ind(EXCL{1,j});
        if isempty(excl)
            ind3{1,j}=ind;
            excl3{1,j}=[];
        else
            tmp=ind;tmp(EXCL{1,j})=[];
            ind3{1,j}=tmp;
            excl3{1,j}=excl;
        end
    else
        ind3{1,j}=ind;
        pairs3{1,j}=[];
        excl3{1,j}=[];
    end
end

% getting exclusion details
for j=1:numel(boxlist)
    if isempty(pairs3{1,j})==0
        tmp=pairs3{1,j};
        pairdet3{1,j}=[pairs3{1,j} CONF{1,j} SKI{1,j} NEAR{1,j} PERCT{1,j} PERCS{1,j}];
        f=find(CONF{1,j}==1&SKI{1,j}==0);
        % check if it was deleted
        if isempty(excl3{1,j})==0
            pairdes3{1,j}=[pairs3{1,j}(f,1) ismember(pairs3{1,j}(f,1),excl3{1,j})...
                pairs3{1,j}(f,2) ismember(pairs3{1,j}(f,2),excl3{1,j})...
                DES{1,j}(f) DES2{1,j}(f)];
        end
    else
       pairdet3{1,j}=[];
       pairdes3{1,j}=[];
    end
end

pairdet3_label={'ind1','ind2','confirmed','skipped','near','temp. simil.','sal. simil.'};

clear CONF DES* dlabel* excl NEAR tmp EXCL f i ind indpairs IND j PERC* SKI output output_label

% FILE3
load(file4)
for j=1:numel(boxlist)
    indpairs=IND{1,j};
    ind=ind3{1,j};
    if isempty(indpairs)==0
        % get the original index for the pairs
        pairs4{1,j}=ind(indpairs);
        excl=ind(EXCL{1,j});
        if isempty(excl)
            ind4{1,j}=ind;
            excl4{1,j}=[];
        else
            tmp=ind;tmp(EXCL{1,j})=[];
            ind4{1,j}=tmp;
            excl4{1,j}=excl;
        end
    else
        ind4{1,j}=ind;
        pairs4{1,j}=[];
        excl4{1,j}=[];
    end
end


% getting exclusion details

for j=1:numel(boxlist)
    if isempty(pairs4{1,j})==0
        tmp=pairs4{1,j};
        pairdet4{1,j}=[pairs4{1,j} CONF{1,j} SKI{1,j} PERCT{1,j} PERCS{1,j}];
        f=find(CONF{1,j}==1&SKI{1,j}==0);
        % check if it was deleted
        if isempty(excl4{1,j})==0
            pairdes4{1,j}=[pairs4{1,j}(f,1) ismember(pairs4{1,j}(f,1),excl4{1,j})...
                pairs4{1,j}(f,2) ismember(pairs4{1,j}(f,2),excl4{1,j})...
                DES{1,j}(f) DES2{1,j}(f)];
        end
    else
       pairdet4{1,j}=[];
       pairdes4{1,j}=[];
    end
end
pairdet4_label={'ind1','ind2','confirmed','skipped','temp. simil.','sal. simil.'};

clear CONF DES* dlabel* excl NEAR tmp EXCL f i ind indpairs IND j PERC* SKI output output_label  boxlist out
save(fileout)