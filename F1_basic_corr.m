function F1_basic_corr(boxlist,inpath,outpath,nameout)
for j=1:numel(boxlist)
    box=boxlist(j);
    [output{1}(j,:),output_label,EXCL{1,j},badsamples{1,j},badprofiles{1,j}]=box_basic_corr(inpath,box,outpath);
    if sum(cellfun(@isempty,EXCL{1,j}))==4
        EXCL_all{1,j}=[];
    else
        EXCL_all{1,j}=cell2mat(EXCL{1,j}');
    end
end
%

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

save(nameout,'output*','boxlist','EXCL*','bad*');