function [qckept,qcexcluded,criteria1,criteria2,indkept,indexcluded,boxn]...
    =plot_dupanalysis(step,box,crit1,crit2,comb,pl,sv)


if nargin<7
    sv=[];
end
if nargin<6
    pl=[];
end
if nargin<5
    comb=[];
end
if nargin <4
    crit2=[];
end
if nargin <3
    crit1=[];
end
if nargin <2
    box=[];
end

crit1label={'Profile content','Profile qclevel','2nd (identical)','both'};
[~,~,crit2label1]=prof_comppc([],[]);
[~,~,~,~,crit2label2,~]=prof_compqc([],[]);

% load regions and boxes
load('regions.mat','boxesmat','regions')
n=numel(regions);
if isempty(box)
    ind=isfinite(boxesmat');
    box=boxesmat';box=box(ind);
end

% data path
inp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\';

% loading results
fname=[inp 'a' num2str(step) '_results.mat'];
load(fname,'DES','EXCL','IND','SKI')

inp=[inp 'A' num2str(step-1) '\'];

% loop box
N=numel(box);
for i=1:N
    disp(['box ' num2str(i) ' from ' num2str(N)])
    b=box(i);
    % path ctd
    fb=find(boxesmat==b);[fbr,~]=ind2sub(size(boxesmat),fb);
    ipath=[inp  regions{fbr} '\']; %#ok<NASGU>
    % results
    ind=IND{fb};des=DES{fb};skip=SKI{fb};
    % remove irrelevant results
    % skipped pairs
    ind(skip==1,:)=[];des(skip==1,:)=[];clear skip
    % excluded
    E=EXCL{fb};
    excl=ismember(ind,E);
    % where none was deleted
    ind(sum(excl,2)==0,:)=[];des(sum(excl,2)==0,:)=[];excl(sum(excl,2)==0,:)=[];
    % where none was deleted 
    ind(isnan(des),:)=[];excl(isnan(des),:)=[];des(isnan(des),:)=[];
    %ind(sum(excl,2)==2,:)=[];des(sum(excl,2)==2,:)=[];excl(sum(excl,2)==2,:)=[];

    % criteria 1
    if isempty(crit1)==0
        e=find(ismember(des,crit1)==0);
        ind(e,:)=[];des(e,:)=[];excl(e,:)=[];
    end
    % loop pairs
    NP=size(ind,1);
    if NP>0
        % boxfile
        boxfile=[ipath 'ctd_' num2str(b) '.mat'];
        % Each pair
        count=0;
        for l=1:NP
            if des(l)==1
                [~,tmp]=prof_comppc(boxfile,ind(l,:));
            elseif des(l)==2
                [~,~,~,tmp]= prof_compqc(boxfile,ind(l,:));
            else
                tmp=NaN;
            end
            if isempty(crit2)==0 && ismember(tmp,crit2)==0
            else
                data=extr_prof(boxfile,ind(l,:));
                if isempty(comb)
                    ca=[1 1];cr=[1 1];
                else
                    ca=cellfun(@strcmp, data.qclevel, comb);
                    cr=cellfun(@strcmp, data.qclevel, fliplr(comb));
                end
                if  isempty(comb) || (sum(cr)==2 || sum(ca)==2)
                    count=count+1;                    
                    qckeptx{i,1}{count,1} = data.qclevel(excl(l,:)==0);
                    qcexcludedx{i,1}{count,1} = data.qclevel(excl(l,:)==1);
                    criteria1x{i,1}(count,1) = des(l);
%                     if l==2
%                         pause
%                     end
                    if numel(ind(l,(excl(l,:)==0)))==0
                        indkeptx{i,1}(count,:) = NaN;
                    elseif numel(ind(l,(excl(l,:)==0)))==1
                        indkeptx{i,1}(count,:) = ind(l,(excl(l,:)==0));
                    elseif numel(ind(l,(excl(l,:)==0)))==2
                        indkeptx{i,1}(count,:) = -2;
                    end
                    if numel(ind(l,(excl(l,:)==1)))==0
                         indexcludedx{i,1}(count,:) = NaN;
                    elseif numel(ind(l,(excl(l,:)==1)))==1
                        indexcludedx{i,1}(count,:) = ind(l,(excl(l,:)==1));
                    elseif  numel(ind(l,(excl(l,:)==1)))==2
                        indexcludedx{i,1}(count,:) = -2;
                    end
                    criteria2x{i,1}(count,1)=tmp;
                    
                    if pl==1
                        c1=criteria1x{i,1}(count,1);c2=criteria2x{i,1}(count,1);
                        if ~isnan(c1)
                            cl1=crit1label{c1};
                            if c1==1
                                cl2=crit2label1{c2};
                            elseif c1==2
                                cl2=crit2label2{c2};
                            else
                                cl2='NaN';
                            end
                        else
                            cl1='NaN';cl2='NaN';
                        end
                        extr.varNames={'criteria 1','criteria 2','indices','box','region'};
                        % must be in pairs
                        extr.info={num2str(c1),cl1;num2str(c2),cl2;...
                            num2str(ind(l,1)),num2str(ind(l,2));num2str(b),' ';
                            regions{fbr},' '};                        
                        plot_profpair(data,excl(l,:),extr)
                        if sv==1
                            eval(['export_fig -r200 step' num2str(step) '_' num2str(b) '_pair' num2str(l,'%03.f') '.png'])
                            close
                        end
                        
                    end
                end
            end
        end
        
        boxnx{i,1}=repmat(b,count,1);
    else
        qckeptx{i,1}=[];qcexcludedx{i,1}=[];
        criteria1x{i,1}=[];
        criteria2x{i,1}=[];
        indkeptx{i,1}=[];
        indexcludedx{i,1}=[];
        boxnx{i,1}=[];
    end
end
if exist('qckeptx','var')
    qckept=vertcat(qckeptx{:});
    qcexcluded=vertcat(qcexcludedx{:});
    criteria1=vertcat(criteria1x{:});
    criteria2=vertcat(criteria2x{:});
    indkept=vertcat(indkeptx{:});
    indexcluded=vertcat(indexcludedx{:});
    boxn=vertcat(boxnx{:});
    clear *x
end