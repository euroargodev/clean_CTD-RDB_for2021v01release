function [qcl,source,criteria1,criteria2,indkept,indexcluded,boxn]...
    =ext_dupinf(step,box,crit1,crit2,comb,pl,spl) 

if nargin<7
    spl=[];
end
if nargin<6
    pl=[];
end
if nargin<5
    comb={'',''};    
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
crit2label1={'Gap','Sal. resolution','MRP','Vertical resolution'};
crit2label2={'qclevel','source'};


% load regions and boxes
load(['\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\' ...
    'regions.mat'],'boxesmat','regions')

if isempty(box)
    ind=isfinite(boxesmat');
    box=boxesmat';box=box(ind);
end

% loading results
fname=['a' num2str(step) '_results.mat'];
load(fname,'DES','EXCL','IND','SKI')

% load original indices
vname=['ind' num2str(step-1)];
load('boxes2check',vname)

% ctd data path
inp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\base\';
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
    NP=size(ind,1); % boxfile
    boxfile=[ipath 'ctd_' num2str(b) '.mat'];
    if NP>0 && exist(boxfile)
        
        % Each pair
        count=0;
        for l=1:NP
            showporc(l,NP,10)
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
                ca=cellfun(@strcmp, data.qclevel, comb);
                cr=cellfun(@strcmp, data.qclevel, fliplr(comb));
                if  strcmp(comb{1},'') || (sum(cr)==2 || sum(ca)==2)
                    count=count+1;                    
                    qclx{i,1}(count,1) = data.qclevel(1);qclx{i,1}(count,2) = data.qclevel(2);
                    sourcex{i,1}(count,1) = data.source(1);sourcex{i,1}(count,2) = data.source(2);
                    criteria1x{i,1}(count,1) = des(l);
                    criteria2x{i,1}(count,1)=tmp;
                    indkeptx{i,1}(count,:) = ind(l,(excl(l,:)==0));
                    indexcludedx{i,1}(count,:) = ind(l,(excl(l,:)==1));
                    eval(['tmp1=' vname '{fb};'])
                    indkeptx{i,2}(count,:) = tmp1(ind(l,(excl(l,:)==0)));
                    indexcludedx{i,2}(count,:) = tmp1(ind(l,(excl(l,:)==1)));
                  
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
                        extr.varNames={'criteria 1','criteria 2','indices','box','region','or. indices'};
                        % must be in pairs
                        extr.info={num2str(c1),cl1;num2str(c2),cl2;...
                            num2str(ind(l,1)),num2str(ind(l,2));num2str(b),' ';
                            regions{fbr},' ';num2str(tmp1(ind(l,1))),num2str(tmp1(ind(l,2)))};                        
                        plot_profpair(data,excl(l,:),extr)
                        if spl==1
                           nf=['step' num2str(step) '_' num2str(b) '_pair' num2str(l,'%03.f') '.png'];
                           eval(['export_fig -r100 ' nf ])
                           close
                        end
                    end
                end
            end
        end
        
        boxnx{i,1}=repmat(b,count,1);
    else
        qclx{i,1}=[];
        sourcex{i,1}=[];
        criteria1x{i,1}=[];
        criteria2x{i,1}=[];
        indkeptx{i,1}=[];indkeptx{i,2}=[];
        indexcludedx{i,1}=[];indexcludedx{i,2}=[];
        boxnx{i,1}=[];
    end
end
if exist('sourcex','var')
    qcl=vertcat(qclx{:});
    source=vertcat(sourcex{:});
    criteria1=vertcat(criteria1x{:});
    criteria2=vertcat(criteria2x{:});
    indkept{1}=vertcat(indkeptx{:,1});
    indkept{2}=vertcat(indkeptx{:,2});
    indexcluded{1}=vertcat(indexcludedx{:,1});
    indexcluded{2}=vertcat(indexcludedx{:,2});
    boxn=vertcat(boxnx{:});
    clear *x
end
