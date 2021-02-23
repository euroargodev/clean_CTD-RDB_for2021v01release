function [output,output_label,ind2, badsamples, badprofiles]=box_basic_corr(rdb_path,box,outpath)
%rdb_path='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2019V01\';
%box=7603;
%outpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\';
if ~exist(outpath, 'dir')
    mkdir(outpath)
end

if isfile([rdb_path 'ctd_' num2str(box) '.mat'])
    disp('.')
    disp('.')
    %0. Make copy
    box_copy(rdb_path,box,outpath)
    
    % 1. Clean samples
    [badsamples,output1]=box_cleansamples(outpath,box,outpath);
    
    % 2. Remove profiles
    [ind2, output2]=box_cleanprofiles(outpath,box,outpath);
   
    
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
    
    if n>10000
        ind2{4,1}=find(dates<19950000000000);
        box_excl(outpath,box,ind2{4},outpath)
        disp(['Older ' num2str(numel(ind2{4})) ' profiles excluded, since the box had ' ...
            'more than 10000 profiles'])
        output3=[n numel(ind2{4})];
    else
        ind2{4,1}=[];
        output3=[n 0];
    end
    
    output=[output1 output2 output3];
else
    disp('.')
    disp('.')
    disp(['Box ' num2str(box) ' does not exist'])
    output=nan(1,11);
    ind2=cell(4,1);
    badsamples.outsal=[];badsamples.outtemp=[];
    badsamples.incomplete=[];
end
badprofiles.extraprof=ind2{4};
badprofiles.outbox=ind2{1};
badprofiles.shallow=ind2{2};
badprofiles.nmip=ind2{3};
    
output_label={'initial n','out T','out S','incompl. samples','incompl. prof','out box','shallow','NMIP','excl. prof','total n','extra rem'};