function F2_exmetadup(boxlist,inpath,outpath,nameout,indupcell)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function 
% Input: 
% BOXLIST
% INPATH
% OUTPATH
% NAMEOUT
% INDUPCELL % unclear, I think this was for reusing some output when a step
% was not running completely.
% probably better to remove in the future

% F2_exmetadup(boxlist,inpath,outpath,'test2.mat');
% Output: 
% 
% Obs. 
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<5
    indup=[];
end
% create output folder if does not exist
if ~exist(outpath, 'dir')
    mkdir(outpath)
end

% preallocate outputs
tmp=cell(1,numel(boxlist));
SKI= tmp;% skipped pairs
IND = tmp;% duplicated pairs as the IND output from the BOX_META_DUP function
DES= tmp;% reason why the profiles where delated/retained. It relates to OUTPUT_LABEL
DES2= tmp;% reason why one profile was considered better/worse than the other. 
          % This comes from the output of the functions prof_comppc or prof_compqc
CONF= tmp;% vector with the output of prof_compcont (1 means that the pair is a content duplicate)
PERCT= tmp;% output of prof_compcont
PERCS= tmp;% output of prof_compcont
EXCL= tmp; % contains iformation about excluded profiles related to the duplicate pairs!
               
for j=1:numel(boxlist)% For each box in the list
    box=boxlist(j);
    % find indices of exact metadata duplicate
    [~,~,ind,filein]= box_meta_dup(inpath,box);    
	
    if nargin>4
       indup=indupcell{j};
    end
    
    n=size(ind,1);
    % HERE THE SKIPING PART
    % checking if there are pairs to skip (same origin)
    if isempty(indup)==0
        oind=indup(ind);
        sk=[];
        for k=1:n
            if oind(k,1)==oind(k,2)
                sk=[sk k];
            end
        end
        if isempty(sk)==0
            ind(sk,:)=[];
        end
        n=size(ind,1);
    end
    
    disp([num2str(n) ' exact metadata duplicates'])
    % preallocating vars
    excl=[];
    perc_t=zeros(n,1);perc_s=zeros(n,1);conf=zeros(n,1);
    skip=zeros(n,1);des=zeros(n,1);des2=zeros(n,1);
 
    % for each pair
    for k=1:n
        showporc(k,n,10)
        %skips pair if one member has been excluded already
        if sum(ismember(ind(k,:),excl))==0
            % checks if the profile is content duplicate
            [perc_t(k,1),perc_s(k,1),conf(k,1)]=prof_compcont(filein,ind(k,:));
            if conf(k)==1 % if it is
                % find the worst profile
                [w1,d1,dlabel1]=prof_comppc(filein,ind(k,:)); %#ok<ASGLU> % profile content
                [w2,~,~,d2,dlabel2]=prof_compqc(filein,ind(k,:)); %#ok<ASGLU> % profile qclevel/source
                % find worst profile giving preference to the content
                if w1==0
                    w=w2;
                    des(k)=2; % quality level
                    des2(k)=d2;
                else
                    w=w1;
                    des(k)=1;% profile content
                    des2(k)=d1;
                end
                
                if w==0 % if profiles are identical, delete the second
                    excl=[excl ind(k,2)];
                    des(k)=3; % second
                    des2(k)=NaN;
                else % if not, delete the worst profile
                    excl=[excl ind(k,w)];
                end
                skip(k,1)=0;
            elseif conf(k)==0 % if profile is not content duplicate
                excl=[excl ind(k,:)]; % delete both profiles
                des(k)=4; % both
                skip(k,1)=1;
                des2(k)=NaN;
            end
        else %skips pair if one member has been excluded already
            conf(k)=NaN;
            des(k)=NaN;
            skip(k,1)=1;
            des2(k)=NaN;
        end
    end
    
    if isempty(conf)==0 || sum(conf)>0
        disp(['from which ' num2str(numel(find(conf==1))) ' are also content duplicates'])
        disp(['and ' num2str(numel(find(conf==0))) ' had different contents'])
        disp([num2str(numel(excl)) ' profiles will be excluded'])
        output{1}(j,:)=[n numel(find(conf==1)) numel(find(conf==0)) numel(excl)];
        box_excl(inpath,box,excl,outpath)
        if isempty(indup)==0
           indup(excl)=[]; 
           eval(['save ' outpath 'ctd_' num2str(box) ' indup -append'])
        end
    else
        output{1}(j,:)=[n NaN NaN NaN];
        if isfile([inpath 'ctd_' num2str(box) '.mat'])
            box_copy(inpath,box,outpath)
        end
    end
    
    %storing indices
    SKI{1,j}=skip; % skipped pairs
    IND{1,j}=ind;  % duplicated pairs as the IND output from the BOX_META_DUP function
    DES{1,j}=des;  % reason why the profiles where delated/retained. It relates to OUTPUT_LABEL
    DES2{1,j}=des2;% reason why one profile was considered better/worse than the other. 
    % This comes from the output of the functions prof_comppc or prof_compqc
    CONF{1,j}=conf;% vector with the output of prof_compcont (1 means that the pair is a content duplicate)
    PERCT{1,j}=perc_t;% output of prof_compcont
    PERCS{1,j}=perc_s;% output of prof_compcont
    EXCL{1,j}=excl;% is a 2 x nduplicate vector where 1 indicates an excluded profile
                   % and 0 a retained profile
    clear perc* conf* ind skip excl des des2
    
    disp('...')
end

output_label={'n emetadup','same content','different content',' n profiles excluded'}; %#ok<NASGU>
if exist('dlabel1','var')
    save(nameout,'boxlist','output*','EXCL','PERC*','IND','CONF','DES*','SKI','dlabel*')
else
    save(nameout,'boxlist','output*','EXCL','PERC*','IND','CONF','DES*','SKI')
end