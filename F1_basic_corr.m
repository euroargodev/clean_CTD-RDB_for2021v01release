function F1_basic_corr(boxlist,inpath,outpath,nameoutput)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function creates a new version of each box file in BOXLIST. The original file
% is located in INPATH and the new file is in OUTPATH. NAMEOUTPUT is a 
% matfile containing all the information about the modifications done by
% the function box_basic_corr in each box. These includes all basic checks
% and removal of samples and profiles accordingly.
% Input: 
% in (INPATH) and out (OUTPATH) paths, a list of box numbers (BOXLIST), and
% the name of the output matfile (NAMEOUTPUT) with the summary and details 
% of the changes done to the boxes.
%
% Output: There are no variable outputs but new matfiles:
% - new versions of the box files in BOXLIST stored in OUTPATH
% - and the output matfile NAMEOUTPUT stored in the local directory (or in
% another one if a full path is given in NAMEOUTPUT) with the  summary
% and details of the procedures.
%
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de, ingrid.angelb@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This part of the code does the actual cleaning
% For each box
for j=1:numel(boxlist)
    box=boxlist(j);
    % perform all the basic checks and remove samples and profiles accordingly
    [output{1}(j,:),output_label,EXCL{1,j},badsamples{1,j},badprofiles{1,j}]...
        =box_basic_corr(inpath,box,outpath); %#ok<*ASGLU,*NASGU,*AGROW>
    % makes a unique vector with all the profiles deleted in each box
    if sum(cellfun(@isempty,EXCL{1,j}))==4
        EXCL_all{1,j}=[];
    else
        EXCL_all{1,j}=cell2mat(EXCL{1,j}');
    end
end
%

%% This part of the code uses the output of the part above to orginize the information
% to be accessed by F5_get_orindices.m

% for each box makes extracts info about bad samples
for j=1:numel(boxlist) 
    if isempty(badsamples{1,j})==0
        ofr_S1{1,j}=badsamples{1,j}.outsal;
        ofr_T1{1,j}=badsamples{1,j}.outtemp;
        inc_samples1{1,j}=badsamples{1,j}.incomplete;
    else
        ofr_S1{1,j}=[];
        ofr_T1{1,j}=[];
        inc_samples1{1,j}=[];
    end
end
% for each box makes extracts info about bad profiles
for j=1:numel(boxlist)
    N=output{1}(j,1);
    if isfinite(N)
        ind=1:N;
        ind0{1,j}=ind;
        excl=EXCL_all{1,j};
        if isempty(excl)
            ind1{1,j}=ind;
            excl1{1,j}=[];
            outofbox1{1,j}=[];
            shallow1{1,j}=[];
            nonmonotpres1{1,j}=[];
            extraprof1{1,j}=[];
        else
            tmp=ind;tmp(excl)=[];
            ind1{1,j}=tmp;
            excl1{1,j}=excl;
            outofbox1{1,j}=EXCL{1,j}{1};
            shallow1{1,j}=EXCL{1,j}{2};
            nonmonotpres1{1,j}=EXCL{1,j}{3};
            extraprof1{1,j}=EXCL{1,j}{4};
        end
    else
        ind1{1,j}=[];
        excl1{1,j}=[];
        outofbox1{1,j}=[];
        shallow1{1,j}=[];
        nonmonotpres1{1,j}=[];
        extraprof1{1,j}=[];
    end
end
% saves in a matfile
save(nameoutput,'output*','boxlist','EXCL*','bad*');