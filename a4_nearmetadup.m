%addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab'
%%
clear variables
load regions.mat
%% Near metadata duplicates

outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\A4\';
inp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\A3\';
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
    eval(['diary ' outp 'a4_' strrep(regions{i},' ','_') '.txt'])
    disp('---------------------------------------------------')
    disp(regions{i})
    disp('...')
    
    % get box list for the region
    boxlist=boxes{i};
    
    % for each box
    for j=1:numel(boxlist)
        box=boxlist(j);
        % find indices of near metadata duplicates (1 decimal place for lat
        % long and 1 day diff for time)
        [ind,filein]=box_meta_neardup(inpath,box);
        n=size(ind,1);
        disp([num2str(n) ' near metadata duplicates'])        
        % preallocating vars
        excl=[];
        perc_t=zeros(n,1);perc_s=zeros(n,1);conf=zeros(n,1);
        skip=zeros(n,1);des=zeros(n,1);
        % for each pair
        for k=1:n
            %skips pair if one member has been excluded already
            if sum(ismember(ind(k,:),excl))==0
                 % checks if the profile is deep content duplicate (at least 95% of match below 500 m) 
                [perc_t(k,1),perc_s(k,1),conf(k,1)]=prof_compcontdeep(filein,ind(k,:),500,95);
                if conf(k)==1 %if it is
                    % find the worst profile
                    w1=prof_comppc(filein,ind(k,:)); % profile content
                    w2=prof_compqc(filein,ind(k,:)); % profile qclevel/source
                    % find worst profile giving preference to the content
                    if w1==0
                        w=w2;
                        des(k)=2; % quality level
                    else
                        w=w1;
                        des(k)=1;% profile content
                    end
                    
                    if w==0 % if profiles are identical, delete the second
                        excl=[excl ind(k,2)];
                         des(k)=3; % second
                    else % if not, delete the worst profile
                        excl=[excl ind(k,w)];
                    end
                else % not duplicate
                    des(k)=NaN; 
                end
                skip(k)=0;
            else %skips pair if one member has been excluded already
                conf(k)=NaN;
                des(k)=NaN;
                skip(k)=1;
            end
        end
        
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
        
        % storing indices
        SKI{i,j}=skip;
        IND{i,j}=ind;
        DES{i,j}=des;
        CONF{i,j}=conf;
        PERCT{i,j}=perc_t;
        PERCS{i,j}=perc_s;
        EXCL{i,j}=excl;
        clear perc* conf* ind des excl
        disp('...')
    end
    disp('---------------------------------------------------')
    diary off
end
output_label={'n nmetadup','same content','different content',' n profiles excluded'};
save a4_results.mat boxes output* regions EXCL PER* IND SKI CONF DES;