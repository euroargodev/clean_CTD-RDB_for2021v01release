%addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab'
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\m_map'

%%
clear variables
load regions.mat
%% Content duplicates

outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\A3\';
inp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\A2\';
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
    eval(['diary ' outp 'a3_' strrep(regions{i},' ','_') '.txt'])
    disp('---------------------------------------------------')
    disp(regions{i})
    disp('...')
    
    %get box list for the region
    boxlist=boxes{i};
    % for each box
    for j=1:numel(boxlist)
        box=boxlist(j);
        % find indices of content duplicate candidates (based on sums algorithm applied
        % to interpolated/truncated profiles (900:10:2000)
        [ind,filein]=box_cont_dup(inpath,box);
        n=size(ind,1);
        % preallocating vars
        excl=[];
        perc_t=zeros(n,1);perc_s=zeros(n,1);conf=zeros(n,1);
        skip=zeros(n,1);des=zeros(n,1);near=zeros(n,1);
        % for each pair
        for k=1:n
            %skips pair if one member has been excluded already
            if sum(ismember(ind(k,:),excl))==0
                % checks if the profile is content duplicate
                [perc_t(k,1),perc_s(k,1),conf(k,1)]=prof_compcontdeep(filein,ind(k,:),0,95);
                if conf(k)==1 % if it is
                    % check if the profiles are near to each other (3 km, 3
                    % days)
                    near(k)=prof_compnear(filein,ind(k,:),3,3);
                    if near(k)==1 % if they are
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
                    else % if they are far away delete both profiles (metadata uncertainty)
                        excl=[excl ind(k,:)];
                        des(k)=4; % both
                    end
                else % not duplicate
                    near(k)=NaN;
                    des(k)=NaN; 
                end
                skip(k,1)=0;
            else %skips pair if one member has been excluded already
                conf(k,1)=NaN;
                skip(k,1)=1;
                des(k)=NaN; 
                near(k)=NaN;
            end
        end
        
        %end
        disp([num2str(n) ' probable cont duplicates'])
        if isempty(conf)==0 || sum(conf)>0
            disp(['from which ' num2str(numel(find(conf==1))) ' are actually content duplicates'])
            disp('.')
            disp([num2str(numel(find(near==1 & conf==1))) ' were near to each other'])
            disp([num2str(numel(find(near==0 & conf==1))) ' were far from each other'])
            disp([num2str(numel(excl)) ' profiles will be excluded'])
            output{i}(j,:)=[n numel(find(conf==1)) numel(find(near==1 & conf==1)) numel(find(near==0 & conf==1)) numel(excl)];
            box_excl(inpath,box,excl,outpath)
        else
            output{i}(j,:)=[n NaN NaN NaN NaN];
            if isfile([inpath 'ctd_' num2str(box) '.mat'])
                box_copy(inpath,box,outpath)
            end
        end
        
        % storing indices
        SKI{i,j}=skip;
        IND{i,j}=ind;
        DES{i,j}=des;
        NEAR{i,j}=near;
        CONF{i,j}=conf;
        PERCT{i,j}=perc_t;
        PERCS{i,j}=perc_s;
        EXCL{i,j}=excl;
        clear perc* conf* near skip excl des ind       
        
        disp('...')
        
        disp('...')
    end
    disp('---------------------------------------------------')
    diary off
end
output_label={'n probdup','n contdup','nearby','far','n profiles excluded'};
save a3_results.mat boxes output* regions EXCL PER* IND CONF NEAR DES SKI;