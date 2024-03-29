%addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab'
%%
clear variables
load regions.mat
%% Exact metadata duplicates
out='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\';
outp=[out 'A2\'];
inp=[out 'A1\'];

% create output folder if does not exist
if ~exist(outp, 'dir')
    mkdir(outp)
end
%for each region
for i=1:numel(boxes)
    
    % get/ create paths
    inpath=[inp regions{i} '\'];
    outpath=[outp regions{i} '\'];
    if ~exist(outpath, 'dir')
        mkdir(outpath)
    end
    
    % start log
    eval(['diary ' outp 'a2_' strrep(regions{i},' ','_') '.txt'])
    disp('---------------------------------------------------')
    disp(regions{i})
    disp('...')
    
    % get box list for the region
    boxlist=boxes{i};
    % for each box
    for j=1:numel(boxlist)
        box=boxlist(j);
        % find indices of exact metadata duplicate
        [dup,pair,ind,filein]= box_meta_dup(inpath,box);
        n=size(ind,1);
        excl=[];
        % preallocating vars
        perc_t=zeros(n,1);perc_s=zeros(n,1);conf=zeros(n,1);
        skip=zeros(n,1);des=zeros(n,1);des2=zeros(n,1);
        disp([num2str(n) ' exact metadata duplicates'])
		diary off
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
        diary on
        % delete the profiles in the list and summarize the outputs if
        % there are some profiles to delete. If not just copy the contents
        % to the outpath
        
        if isempty(conf)==0 || sum(conf)>0
            disp(['from which ' num2str(numel(find(conf==1))) ' are also content duplicates'])
            disp(['and ' num2str(numel(find(conf==0))) ' had different contents'])
            disp([num2str(numel(excl)) ' profiles will be excluded'])
            output{i}(j,:)=[n numel(find(conf==1)) numel(find(conf==0)) numel(excl)];
            box_excl(inpath,box,excl,outpath)
        else
            output{i}(j,:)=[n NaN NaN NaN];
            if isfile([inpath 'ctd_' num2str(box) '.mat'])
               box_copy(inpath,box,outpath)
            end
        end
        
        %storing indices
        SKI{i,j}=skip;
        IND{i,j}=ind;
        DES{i,j}=des;
        DES2{i,j}=des2;
        CONF{i,j}=conf;
        PERCT{i,j}=perc_t;
        PERCS{i,j}=perc_s;
        EXCL{i,j}=excl;
        clear perc* conf* ind skip excl des des2
                
        disp('...')
    end
    disp('---------------------------------------------------')
    diary off
end
output_label={'n emetadup','same content','different content',' n profiles excluded'};
save([out 'a2_results.mat'],'boxes','output*','regions','EXCL','PERC*','IND','CONF','DES*','SKI','dlabel*')