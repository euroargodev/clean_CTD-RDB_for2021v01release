clear variables;close all;
flist=dir('*_results.mat');
% select only results from duplicate checks
flist=flist(2:4);

% load regions and boxes
load(flist(1).name,'boxes','regions')
n=numel(regions);

% data path
inp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\';
F_xls=sprintf('keepduplicate.xlsx');
for i=1:numel(flist) % step   
    tic
    load(flist(i).name,'DES','EXCL','IND','SKI')
    for j=1:n %region
        disp(regions{j})
        ipath=[inp 'A' num2str(str2double(flist(i).name(2))-1) '\' regions{j} '\'];
        b=boxes{j}';N=numel(b);
        for k=1:N % each box
            disp(['box ' num2str(k) ' from ' num2str(N)])
            ind=IND{j,k};des=DES{j,k};skip=SKI{j,k};
            % remove skipped pairs
            ind(skip==1,:)=[];des(skip==1,:)=[];clear skip
            % remove pairs were either both or "any" profile was deleted
            ind(des>2,:)=[];des(des>2==1,:)=[];
            % excluded
            E=EXCL{j,k};
            excl=ismember(ind,E);
            % remove pairs if at the end non of its members was deleted or
            % both were deleted
            ind(sum(excl,2)==0,:)=[];des(sum(excl,2)==0,:)=[];excl(sum(excl,2)==0,:)=[];
            ind(sum(excl,2)==2,:)=[];des(sum(excl,2)==2,:)=[];excl(sum(excl,2)==2,:)=[];
            ind(sum(excl,2)==0,:)=[];des(sum(excl,2)==0,:)=[];excl(sum(excl,2)==0,:)=[];
            
            NP=size(ind,1);
            if NP>0
                % boxfile
                boxfile=[ipath 'ctd_' num2str(b(k)) '.mat'];
                boxnx{k,1}=repmat(b(k),NP,1);
                % Each pair
                for l=1:NP
                    data=extr_prof(boxfile,ind(l,:));
                    %out
                    qckeptx{k,1}{l,1} = data.qclevel(excl(l,:)==0);
                    qcexcludedx{k,1}{l,1} = data.qclevel(excl(l,:)==1);
                    criteria1x{k,1}(l,1) = des(l);
                    if des(l)==1
                        [~,tmp]=prof_comppc(boxfile,ind(l,:));
                    elseif des(l)==2
                        [~,~,~,tmp]= prof_compqc(boxfile,ind(l,:));
                    end
                    criteria2x{k,1}(l,1)=tmp;
                    indkeptx{k,1}(l,:) = ind(l,(excl(l,:)==0));
                    indexcludedx{k,1}(l,:) = ind(l,(excl(l,:)==1));
                end                
            else
                qckeptx{k,1}=[];qcexcludedx{k,1}=[];
                criteria1x{k,1}=[];
                criteria2x{k,1}=[];
                indkeptx{k,1}=[];
                indexcludedx{k,1}=[];
                boxnx{k,1}=[];
            end
            % T = table(LastName,Age,Smoker,Height,Weight,BloodPressure)
            %plot_profpair(data,excl(l,:))
        end
        if exist('qckeptx','var')
            qckept{j,1}=vertcat(qckeptx{:});
            qcexcluded{j,1}=vertcat(qcexcludedx{:});
            criteria1{j,1}=vertcat(criteria1x{:});
            criteria2{j,1}=vertcat(criteria2x{:});
            indkept{j,1}=vertcat(indkeptx{:});
            indexcluded{j,1}=vertcat(indexcludedx{:});
            boxn{j,1}=vertcat(boxnx{:});
            clear *x
        end
    end
    qckept=vertcat(qckept{:});
    qcexcluded=vertcat(qcexcluded{:});
    criteria1=vertcat(criteria1{:});
    criteria2=vertcat(criteria2{:});
    indkept=vertcat(indkept{:});
    indexcluded=vertcat(indexcluded{:});
    boxn=vertcat(boxn{:});
    % table
    T=table(boxn,qckept,qcexcluded,criteria1,criteria2,indkept,indexcluded);
    writetable(T,F_xls,'Sheet',flist(i).name(1:end-4));
    toc
    clear qckept qcexcluded criteria1 criteria2 indkept  indexcluded  boxn
end