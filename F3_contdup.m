function F3_contdup(boxlist,inpath,outpath,nameout,ipres,nearcr,indupcell)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function checks for content duplicates and removes them.
% Input: 
% in (INPATH) and out (OUTPATH) paths, a list of box numbers (BOXLIST), and
% the name of the output matfile (NAMEOUTPUT) with the summary and details 
% of the changes done to the boxes. If OUTPATH does not exist it is
% created.
% IPRES it is an input for the BOX_CONT_DUP function (which is passed to 
% INTERP_PROFILE_IPRES function) that find indices of 
% content duplicate candidates based on sums algorithm applied to profiles 
% interpolated to the ipres levels (and truncated values of the salinity
% and temperature). If the argument is not given the function uses the
% default vector ipres=800:10:2000.
% NEARCR is a two element vector used as input for the PROF_COMPNEAR function.
% the first element is the time difference (TIME_T) in days and the second 
% is the distance (DIST_T) in kilometers. If the argument is not given the 
% default values are 3 days and 3 km.
% INDUPCELL is an optional input and it is the output of joinboxes. 
% This is a cell array (an element for each box)
% and each element is a vector with indices. The files coming from the same
% origin have the same index. This is used to skip the (internal) duplicate 
% checks if they where already performed in the exisiting reference database files
% and in the files with the new profiles. Then the duplicate checks are only performed
% by comaring the "old" and "new profiles". This is for speeding up the
% process.
%
% Output: There are no variable outputs but new matfiles:
% - new versions of the box files in BOXLIST stored in OUTPATH
% - and the output matfile NAMEOUTPUT stored in the local directory (or in
% another one if a full path is given in NAMEOUTPUT) with the summary
% and details of the procedures. It contains following indices in cell vectors 
%(each cell element correspond to a box in the boxlist)
% tmp=cell(1,numel(boxlist));
% SKI skipped pairs
% IND duplicated pairs as the IND output from the BOX_META_DUP function
% DES reason why the profiles where delated/retained. It relates to OUTPUT_LABEL
% DES2 reason why one profile was considered better/worse than the other.
% % This comes from the output of the functions prof_comppc or prof_compqc
% CONF % vector with the output of prof_compcont (1 means that the pair is a content duplicate)
% PERCT % output of prof_compcont for temperature
% PERCS % output of prof_compcont for salinity
% EXCL  % contains iformation about excluded profiles related to the duplicate pairs!
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In case no INDUP is provided (all profiles will be checked for duplicates
% against each other) no value is assigned.
if nargin<7
    indup=[];
elseif nargin<6
    nearcr=[3 3];% time_t, dist_t
    indup=[];
elseif nargin<5
    ipres=800:10:2000;
    nearcr=[3 3];% time_t, dist_t
    indup=[];
end

% create output folder if does not exist
if ~exist(outpath, 'dir')
    mkdir(outpath)
end

% preallocate outputs
tmp=cell(1,numel(boxlist));
SKI= tmp;% skipped pairs
IND = tmp;% duplicated pairs as the IND output from the BOX_CONT_DUP function
DES= tmp;% reason why the profiles where delated/retained. It relates to OUTPUT_LABEL
DES2= tmp;% reason why one profile was considered better/worse than the other. 
% This comes from the output of the functions prof_comppc or prof_compqc
CONF= tmp;% vector with the output of prof_compcont (1 means that the pair is a content duplicate)
PERCT= tmp;% output of prof_compcont
PERCS= tmp;% output of prof_compcont
EXCL= tmp; % contains iformation about excluded profiles related to the duplicate pairs!
% this is about the distance between profile pairs
NEAR= tmp;% output of PROF_COMPNEAR.m It is one if  profiles are near to each other

for j=1:numel(boxlist)% For each box in the list
    box=boxlist(j);
    % find indices of content duplicate candidates (based on sums algorithm applied
    % to profiles interpolated to the ipres levels. The values of the salinity
    % and temperature profiles are also truncated to 1 an 2 decimal digits
    % respectively.
    [ind,filein]=box_cont_dup(inpath,box,ipres);
    n=size(ind,1); % number of duplicates
    
     % if an INDUP was provided, then get the element for this box
    if nargin>6
        indup=indupcell{j};
    end
  
    % checking if there are duplicate pairs to skip (same origin)
    if isempty(indup)==0
        % get the index of the duplicates
        oind=indup(ind);
        % preallocates the skip vector
        sk=[];
        % for each duplicate pair
        for k=1:n
            % checks if they have the same index
            if oind(k,1)==oind(k,2)
               % if they do add the pair index to the skip list
                sk=[sk k]; %#ok<AGROW>
            end
        end
        % if there are some pairs to skip, they are removed from the list
        % of duplicate pairs
        if isempty(sk)==0
            ind(sk,:)=[];
        end
        % recalculate the number of duplicate pairs after removing the ones
        % to be skipped
        n=size(ind,1);
    end
    
    disp([num2str(n) ' probable cont duplicates'])
    % preallocating vars
    excl=[];
    perc_t=zeros(n,1);perc_s=zeros(n,1);conf=zeros(n,1);
    skip=zeros(n,1);des=zeros(n,1);des2=zeros(n,1);near=zeros(n,1);
    
    % for each pair
    for k=1:n
        showporc(k,n,10)
        %skips pair if one member has been excluded already
        if sum(ismember(ind(k,:),excl))==0
            % checks if the profile is content duplicate
            [perc_t(k,1),perc_s(k,1),conf(k,1)]=prof_compcontsimp(filein,ind(k,:),[0 2000],95);
            if conf(k)==1 % if it is
                % check if the profiles are near to each other (default if 3 km, 3
                % days)
                near(k)=prof_compnear(filein,ind(k,:),nearcr(1),nearcr(1));%time_t, dist_t
                if near(k)==1 % if they are
                    % find the worst profile
                    [w1,d1,dlabel1]=prof_comppc(filein,ind(k,:)); %#ok<ASGLU>  % profile content 
                    [w2,~,~,d2,dlabel2]=prof_compqc(filein,ind(k,:)); %#ok<ASGLU>  % profile qclevel/source 
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
                        excl=[excl ind(k,2)]; %#ok<AGROW>
                        des(k)=3; % second
                        des2(k)=NaN;
                    else % if not, delete the worst profile
                        excl=[excl ind(k,w)]; %#ok<AGROW>
                    end
                else % if they are far away delete both profiles (metadata uncertainty)
                    excl=[excl ind(k,:)]; %#ok<AGROW>
                    des(k)=4; % both
                    des2(k)=NaN;
                end
            else % not duplicate
                near(k)=NaN;
                des(k)=NaN;
                des2(k)=NaN;
                skip(k,1)=1;
            end
            
        else %skips pair if one member has been excluded already
            conf(k,1)=NaN;
            skip(k,1)=1;
            des(k)=NaN;
            near(k)=NaN;
            des2(k)=NaN;
        end
    end
    % if there are some profiles to be removed in the box:
    if isempty(conf)==0 || sum(conf)>0
        % - display a summary of the changes
        disp(['from which ' num2str(numel(find(conf==1))) ' are actually content duplicates'])
        disp('.')
        disp([num2str(numel(find(near==1 & conf==1))) ' were near to each other'])
        disp([num2str(numel(find(near==0 & conf==1))) ' were far from each other'])
        disp([num2str(numel(excl)) ' profiles will be excluded'])
        % store the summary stats in the output cell
        output(j,:)=[n numel(find(conf==1)) numel(find(near==1 & conf==1)) numel(find(near==0 & conf==1)) numel(excl)]; %#ok<AGROW>
        % exclude the profiles and save the new matfile in the desired
        % outpath
        box_excl(inpath,box,excl,outpath)
        % if there is an indup vector, also save it in the new matfile (for
        % further use in the next steps)
        if isempty(indup)==0
            indup(excl)=[]; %#ok<AGROW>
            eval(['save ' outpath 'ctd_' num2str(box) ' indup -append'])
        end
    else % if there is nothing to remove, save the ouput value and make a 
       % copy of the box
        output(j,:)=[n NaN NaN NaN NaN];%#ok<AGROW>
        if isfile([inpath 'ctd_' num2str(box) '.mat'])
            box_copy(inpath,box,outpath)
        end
    end
    
     %storing indices in cells (each cell element correspond to a box in the
    %boxlist). These are the details of the procedure.
    SKI{1,j}=skip; % skipped pairs
    IND{1,j}=ind;  % duplicated pairs as the IND output from the BOX_META_DUP function
    DES{1,j}=des;  % reason why the profiles where delated/retained. It relates to OUTPUT_LABEL
    DES2{1,j}=des2;% reason why one profile was considered better/worse than the other. 
    NEAR{1,j}=near; %output of PROF_COMPNEAR.m It is one if  profiles are near to each other
    % This comes from the output of the functions prof_comppc or prof_compqc
    CONF{1,j}=conf;% vector with the output of prof_compcont (1 means that the pair is a content duplicate)
    PERCT{1,j}=perc_t;% output of prof_compcont
    PERCS{1,j}=perc_s;% output of prof_compcont
    EXCL{1,j}=excl;% is a 2 x nduplicate vector where 1 indicates an excluded profile
                   % and 0 a retained profile
    clear perc* conf* near skip excl des ind des2 near
    disp('...')
end
%Save the NAMEOUT file with the summary of the procedure
output_label={'n probdup','n contdup','nearby','far','n profiles excluded'};%#ok<NASGU>
if exist('dlabel1','var')
    save(nameout,'boxlist','output*','EXCL','PERC*','IND','CONF','DES*','SKI','dlabel*','NEAR','ipres','nearcr')
else
    save(nameout,'boxlist','output*','EXCL','PERC*','IND','CONF','DES*','SKI','NEAR','ipres','nearcr')
end