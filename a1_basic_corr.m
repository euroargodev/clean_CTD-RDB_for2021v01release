addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab'

%%
clear variables
load regions.mat
%% Basic corrections
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2020V01\';
out='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\';
outp=[out 'A1\'];

%for each region
for i=1:numel(boxes)
    % get/ create paths 
    outpath=[outp regions{i} '\'];
    if ~exist(outpath, 'dir')
        mkdir(outpath)
    end
    
    % start log
    eval(['diary ' outp 'a1_' strrep(regions{i},' ','_') '.txt'])
    disp('---------------------------------------------------')
    disp(regions{i})
    disp('...')
    
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)        
        box=boxlist(j);       
        [output{i}(j,:),output_label,EXCL{i,j},badsamples{i,j},badprofiles{i,j}]=box_basic_corr(inpath,box,outpath);
        if sum(cellfun(@isempty,EXCL{i,j}))==4
            EXCL_all{i,j}=[];            
        else
            EXCL_all{i,j}=cell2mat(EXCL{i,j}');
        end
    end 
    disp('---------------------------------------------------')
    diary off
end
save([out 'a1_results.mat'],'boxes','output*','regions','EXCL*','bad*');