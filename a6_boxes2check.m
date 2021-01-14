clear variables
%% Extract info and getting original indices
% A1/ Shallow profiles
out='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\base\';
outp=[out 'A1\'];
load([out 'a1_results.mat'])

for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        N=output{i}(j,1);
        if isfinite(N)
            ind=1:N;
            ind0{i,j}=ind;
            excl=EXCL_all{i,j};
            if isempty(excl)
                ind1{i,j}=ind;
                shallow{i,j}=[];
            else
                tmp=ind;tmp(excl)=[];
                shallow{i,j}=EXCL{i,j}{2};
                ind1{i,j}=tmp;
            end
        end
    end
end
s1_shallow_ind=shallow;
% A2/Same metadata different contents
clearvars -except ind0 ind1 shallow out
outp=[out 'A2\'];
load([out 'a2_results.mat'])

for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        indpairs=IND{i,j};
        ind=ind1{i,j};
        if isempty(indpairs)==0
            excl=EXCL{i,j};
            d=DES{i,j};
            if isempty(excl)
                ind2{i,j}=ind;
                des2_4{i,j}=[];            
            else
                tmp=ind;tmp(excl)=[];
                ind2{i,j}=tmp;
                f=find(d==4);
                tmp=indpairs(f,:);
                des2_4{i,j}=ind(tmp);
            end
        else
            ind2{i,j}=ind;
            des2_4{i,j}=[];         
        end
    end
end
clearvars -except ind0 ind1 ind2 des2_4 shallow out 

% A3/Same contents different metadata (3 days, 3 km difference)
outp=[out 'A3\'];
load([out 'a3_results.mat'])

for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        indpairs=IND{i,j};
        ind=ind2{i,j};
        if isempty(indpairs)==0
            excl=EXCL{i,j};
            d=DES{i,j};
            if isempty(excl)
                ind3{i,j}=ind;
                des3_4{i,j}=[];                
            else
                tmp=ind;tmp(excl)=[];
                ind3{i,j}=tmp;
                f=find(d==4);
                tmp=indpairs(f,:);
                des3_4{i,j}=ind(tmp);
            end
        else
            ind3{i,j}=ind;
            des3_4{i,j}=[];         
        end
    end
end

clearvars -except ind0 ind1 ind2 ind3 des2_4  des3_4 shallow
save boxes2check.mat
%% Extract infos to check the problems easily
clear variables;close all

warning('off','MATLAB:ui:javaframe:PropertyToBeRemoved')
load boxes2check
load regions

% shorten paths
spath_short=spath;
for i=1:numel(spath)
    if isempty(spath{i})==0
       C = strsplit(spath{i},'\');
       spath_short{i}=C{end-1};
    end
end

% A1/ Shallow profiles
b1=boxesmat(find(~cellfun(@isempty,shallow)));
   
for i=1:numel(b1)
    showporc(i,numel(b1),5)
    b=b1(i);
    fb=find(boxesmat==b);
    ipath=spath{fb};
    boxfile=[ipath 'ctd_' num2str(b) '.mat'];
    ind=shallow{fb};
    for j=1:numel(ind)
        data=extr_prof(boxfile,ind(j));
        qclx{i,1}(j,1) = data.qclevel(1);
        sourcex{i,1}(j,1)=data.source(1);
        mprx{i,1}(j,1)=max(data.pres(:));
    end
    boxnx{i,1}=repmat(b,numel(ind),1);
end
s1_shallow_qcl=vertcat(qclx{:});
s1_shallow_source=vertcat(sourcex{:});
s1_shallow_mrp=vertcat(mprx{:});
s1_shallow_boxn=vertcat(boxnx{:});
 
% A2/boxes with exact metadata duplicates and different contents (step 2, criteria4)
b2=boxesmat(find(~cellfun(@isempty,des2_4)));

[s2_qcl,s2_source,~,~,s2_indkept,s2_indexcluded,s2_boxn]...
=ext_dupinf(2,b2,4,[],{'',''},1,1);

% boxes with same content and metadata difference larger that 3 km and 3 days (step 2, criteria4)

b3=boxesmat(find(~cellfun(@isempty,des3_4)));

[s3_qcl,s3_source,~,~,s3_indkept,s3_indexcluded,s3_boxn]...
=ext_dupinf(3,b3,4,[],{'',''},1,1);

% save boxes2check_christine_all.mat
save boxes2check_christine.mat spath_short b1 b2 b3 boxesmat regionsmat regions s1_* s2_* s3_*