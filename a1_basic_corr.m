addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab'

%%
clear variables
load regions.mat
%% Basic corrections

rdb_path='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2019V01\';
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\A1\';

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
        [output{i}(j,:),output_label]=box_basic_corr(rdb_path,box,outpath);        
    end 
    disp('---------------------------------------------------')
    diary off
end
save a1_results.mat boxes output regions output*;