%% Duplicate analysis
clear variables;close all;
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\world\';
flist=dir([outp '*_results.mat']);


% load regions and boxes
load('regions_world.mat','boxes','regions','rest')
boxes_div=boxes;
boxes=rest;
n=numel(regions);

for j=1:n %each region
    b=boxes_div{j}';N=numel(b);
    for k=1:numel(b)
        g=find(boxes==b(k));
        if isempty(g)
            f(k)=NaN;
        else
            f(k)=g;
        end
    end
    indexcl{j}=find(isnan(f)==1);
    F{j}=f;
    clear f
end
% 
% for i=1%
%     badprofileso=load([outp flist(i).name],'badprofiles');badprofileso=badprofileso.badprofiles;
%     badsampleso=load([outp flist(i).name],'badsamples');badsampleso=badsampleso.badsamples;
%     EXCLO=load([outp flist(i).name],'EXCL');EXCLO=EXCLO.EXCL;
%     EXCLO_all=load([outp flist(i).name],'EXCL_all');EXCLO_all=EXCLO_all.EXCL_all;
%     load([outp flist(i).name],'output')
%     output=output{1};
%     for j=1:n %region
%         b=boxes_div{j}';
%         if isempty(indexcl{j})            
%             badprofiles{j}=badprofileso(F{j});
%             badsamples{j}=badsampleso(F{j});
%             EXCL{j}=EXCLO(F{j});
%             EXCL_all{j}=EXCLO_all(F{j});
%         else
%             if i==1
%             f=F{j};
%             ex=indexcl{j};
%             f(ex)=[];
%             b(ex)=[];
%             boxes_div{j}=b';
%             F{j}=f;
%             end
%             badprofiles{j}=badprofileso(F{j});
%             badsamples{j}=badsampleso(F{j});
%             EXCL{j}=EXCLO(F{j});
%             EXCL_all{j}=EXCLO_all(F{j});
%         end
%         OUTPUT{j}=output(F{j},:);
%     end    
%     save([flist(i).name(1:end-5) '_world.mat'],'badsamples','badprofiles','EXCL','EXCL_all','OUTPUT')   
% end

% select only results from duplicate checks
flist=flist(2:4);
for i=1:numel(flist) % step
    DESO=load([outp flist(i).name],'DES');DESO=DESO.DES;
    EXCLO=load([outp flist(i).name],'EXCL');EXCLO=EXCLO.EXCL;
    INDO=load([outp flist(i).name],'IND');INDO=INDO.IND;
    SKIO=load([outp flist(i).name],'SKI');SKIO=SKIO.SKI;
    
    for j=1:n %region
        %disp(regions{j})
        ipath=[outp 'A' num2str(str2double(flist(i).name(2))-1) '\'];
        b=boxes_div{j}';
        if isempty(indexcl{j})            
            DES{j}=DESO(F{j});
            EXCL{j}=EXCLO(F{j});
            IND{j}=INDO(F{j});
            SKI{j}=SKIO(F{j});
        else
            if i==1
            f=F{j};
            ex=indexcl{j};
            f(ex)=[];
            b(ex)=[];
            boxes_div{j}=b';
            F{j}=f;
            end
            DES{j}=DESO(F{j});
            EXCL{j}=EXCLO(F{j});
            IND{j}=INDO(F{j});
            SKI{j}=SKIO(F{j});
        end
    end
    save([flist(i).name(1:end-5) '_world.mat'],'DES','EXCL','IND','SKI')
end
%%
flist=dir('*_result_world.mat');
% select only results from duplicate checks
flist=flist(2:4);
% data path
F_xls=[outp 'keepduplicate.xlsx'];
for i=1:numel(flist) % step
    tic
    load([flist(i).name],'DES','EXCL','IND','SKI')
    for j=1:n %region
        disp(regions{j})
        ipath=[outp 'A' num2str(str2double(flist(i).name(2))-1) '\world\'];
        b=boxes_div{j}';
        % skip rebuilt boxes
        N=numel(b);
        for k=1:N % each box
            
            disp(['box ' num2str(k) ' from ' num2str(N)])
            ind=IND{j}{k};des=DES{j}{k};skip=SKI{j}{k};
            % remove skipped pairs
            ind(skip==1,:)=[];des(skip==1,:)=[];clear skip
            % remove pairs were either both or "any" profile was deleted
            ind(des>2,:)=[];des(des>2==1,:)=[];
            % excluded
            E=EXCL{j}{k};
            excl=ismember(ind,E);
            % remove pairs if at the end non of its members was deleted or
            % both were deleted
            ind(sum(excl,2)==0,:)=[];des(sum(excl,2)==0,:)=[];excl(sum(excl,2)==0,:)=[];
            ind(sum(excl,2)==2,:)=[];des(sum(excl,2)==2,:)=[];excl(sum(excl,2)==2,:)=[];
            
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
%
%         % skip rebuilt boxes
%         N=numel(b);
%         for k=1:N % each box
%             disp(['box ' num2str(k) ' from ' num2str(N)])
%             ind=IND{j,k};des=DES{j,k};skip=SKI{j,k};
%                 % remove skipped pairs
%                 ind(skip==1,:)=[];des(skip==1,:)=[];clear skip
%                 % remove pairs were either both or "any" profile was deleted
%                 ind(des>2,:)=[];des(des>2==1,:)=[];
%                 % excluded
%                 E=EXCL{j,k};
%                 excl=ismember(ind,E);
%                 % remove pairs if at the end non of its members was deleted or
%                 % both were deleted
%                 ind(sum(excl,2)==0,:)=[];des(sum(excl,2)==0,:)=[];excl(sum(excl,2)==0,:)=[];
%                 ind(sum(excl,2)==2,:)=[];des(sum(excl,2)==2,:)=[];excl(sum(excl,2)==2,:)=[];
%
%                 NP=size(ind,1);
%                 if NP>0
%                     % boxfile
%                     boxfile=[ipath 'ctd_' num2str(b(k)) '.mat'];
%                     boxnx{k,1}=repmat(b(k),NP,1);
%                     % Each pair
%                     for l=1:NP
%                         data=extr_prof(boxfile,ind(l,:));
%                         %out
%                         qckeptx{k,1}{l,1} = data.qclevel(excl(l,:)==0);
%                         qcexcludedx{k,1}{l,1} = data.qclevel(excl(l,:)==1);
%                         criteria1x{k,1}(l,1) = des(l);
%                         if des(l)==1
%                             [~,tmp]=prof_comppc(boxfile,ind(l,:));
%                         elseif des(l)==2
%                             [~,~,~,tmp]= prof_compqc(boxfile,ind(l,:));
%                         end
%                         criteria2x{k,1}(l,1)=tmp;
%                         indkeptx{k,1}(l,:) = ind(l,(excl(l,:)==0));
%                         indexcludedx{k,1}(l,:) = ind(l,(excl(l,:)==1));
%                     end
%                 else
%                     qckeptx{k,1}=[];qcexcludedx{k,1}=[];
%                     criteria1x{k,1}=[];
%                     criteria2x{k,1}=[];
%                     indkeptx{k,1}=[];
%                     indexcludedx{k,1}=[];
%                     boxnx{k,1}=[];
%                 end
%                 %plot_profpair(data,excl(l,:))
%             end
%         end
%         if exist('qckeptx','var')
%             qckept{j,1}=vertcat(qckeptx{:});
%             qcexcluded{j,1}=vertcat(qcexcludedx{:});
%             criteria1{j,1}=vertcat(criteria1x{:});
%             criteria2{j,1}=vertcat(criteria2x{:});
%             indkept{j,1}=vertcat(indkeptx{:});
%             indexcluded{j,1}=vertcat(indexcludedx{:});
%             boxn{j,1}=vertcat(boxnx{:});
%             clear *x
%         end
%     end
%     qckept=vertcat(qckept{:});
%     qcexcluded=vertcat(qcexcluded{:});
%     criteria1=vertcat(criteria1{:});
%     criteria2=vertcat(criteria2{:});
%     indkept=vertcat(indkept{:});
%     indexcluded=vertcat(indexcluded{:});
%     boxn=vertcat(boxn{:});
%     % table
%     T=table(boxn,qckept,qcexcluded,criteria1,criteria2,indkept,indexcluded);
%     writetable(T,F_xls,'Sheet',flist(i).name(1:end-4));
%     toc
%     clear qckept qcexcluded criteria1 criteria2 indkept  indexcluded  boxn
% end
