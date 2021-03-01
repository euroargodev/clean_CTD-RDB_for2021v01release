function F2_exmetadup(boxlist,inpath,outpath,nameout,indup)
if nargin<5
    indup=[];
end
% create output folder if does not exist
if ~exist(outpath, 'dir')
    mkdir(outpath)
end
for j=1:numel(boxlist)
    box=boxlist(j);
    % find indices of exact metadata duplicate
    [dup,pair,ind,filein]= box_meta_dup(inpath,box);    
   
    n=size(ind,1);
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
                [w1,d1,dlabel1]=prof_comppc(filein,ind(k,:)); % profile content
                [w2,~,~,d2,dlabel2]=prof_compqc(filein,ind(k,:)); % profile qclevel/source
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
           eval(['save ' outpath filename ' indup -append'])
        end
    else
        output{1}(j,:)=[n NaN NaN NaN];
        if isfile([inpath 'ctd_' num2str(box) '.mat'])
            box_copy(inpath,box,outpath)
        end
    end
    
    %storing indices
    SKI{1,j}=skip;
    IND{1,j}=ind;
    DES{1,j}=des;
    DES2{1,j}=des2;
    CONF{1,j}=conf;
    PERCT{1,j}=perc_t;
    PERCS{1,j}=perc_s;
    EXCL{1,j}=excl;
    clear perc* conf* ind skip excl des des2
    
    disp('...')
end

output_label={'n emetadup','same content','different content',' n profiles excluded'};
if exist('dlabel1','var')
    save(nameout,'boxlist','output*','EXCL','PERC*','IND','CONF','DES*','SKI','dlabel*')
else
    save(nameout,'boxlist','output*','EXCL','PERC*','IND','CONF','DES*','SKI')
end