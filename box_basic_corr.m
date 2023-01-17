function [output,output_label,ind2, badsamples, badprofiles]=box_basic_corr(inpath,box,outpath,minmrp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs all the basic checks of the profiles using the
% functions box_cleansamples and box_cleanprofiles
% Input: in (INPATH) and out (OUTPATH) paths and box number (BOX).
%        MINMRP is an optional input indicating the minimum depth of the
%        profiles. According to the Argo manual, the default value is 900
%        db.
%        OUTPATH is optional, if not given the cleaned box file will be 
%        saved in the current folder. If the path does not exist, the
%        folder is created.
% Output: 
% OUTPUT (vector) summary output showing the number of samples and profiles removed.
% the OUTPUT_LABEL contains a description of each element. 
% IND2 is a cell vector containing the indices of the profiles deleted by 
% the box_cleanprofiles function (3 first elements) and the ones deleted
% due to and excess of profiles in the box (4th element).
% !!this is redundant with BADPROFILES!!
% BADSAMPLES is the first output of box_cleansamples (structure)
% BADPROFILES is a structure containing the indices of the deleted
% profiles. !!!this is redundant with IND2!!
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% asssign default value for the MRP check
if nargin<4
   minmrp = 900;
end

% if the outpath does not exists it is created
if ~exist(outpath, 'dir')
    mkdir(outpath)
end

if isfile([inpath 'ctd_' num2str(box) '.mat'])
    disp('.')
    disp('.')
    %0. Make copy
    box_copy(inpath,box,outpath)
    
    % 1. Clean samples
    [badsamples,output1]=box_cleansamples(outpath,box,outpath);
    
    % 2. Remove profiles
    [ind2, output2]=box_cleanprofiles(outpath,box,outpath,minmrp);
   
    
    % 3. If none or more than 10000 profiles
    filename=['ctd_' num2str(box)];
    load([outpath filename],'dates')
    n=numel(dates);
    disp(['Box has ' num2str(n) ' profiles'])
    
    if n==0 % if box is empty, remove it
       delete([outpath filename])
       disp('Empty box was deleted')
    end
    
    % if has too many profiles   
    % finds the older profiles to delete them
    if n>10000
        ind2{4,1}=find(dates<19950000000000); %removes older profiles
        box_excl(outpath,box,ind2{4},outpath)
        disp(['Older ' num2str(numel(ind2{4})) ' profiles excluded, since the box had ' ...
            'more than 10000 profiles'])
        output3=[n numel(ind2{4})];
    else
        ind2{4,1}=[];
        output3=[n 0];
    end
    % the output 3 contains the total number of profiles after cleaning
    % samples and profiles 
    
    % putting together the summary outputs of all 3 steps, the label is defined
    % below
    output=[output1 output2 output3];
else % if the box does not exist assign empty values to all outputs
    disp('.')
    disp('.')
    disp(['Box ' num2str(box) ' does not exist'])
    output=nan(1,11);
    ind2=cell(4,1);
    badsamples.outsal=[];badsamples.outtemp=[];
    badsamples.incomplete=[];
end

% assign values to the bad profiles structure
badprofiles.extraprof=ind2{4};
badprofiles.outbox=ind2{1};
badprofiles.shallow=ind2{2};
badprofiles.nmip=ind2{3};
    
output_label={'initial n','out T','out S','incompl. samples','incompl. prof','out box','shallow','NMIP','excl. prof','total n','extra rem'};