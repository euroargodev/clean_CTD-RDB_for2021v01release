addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab'

%%
clear variables
load regions.mat
%% Basic corrections

out='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\base\';
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
        inpath=spath{find(boxesmat==box)};
        [output{i}(j,:),output_label,EXCL{i,j}]=box_basic_corr(inpath,box,outpath);        
        EXCL_all{i,j}=cell2mat(EXCL{i,j}');
    end 
    disp('---------------------------------------------------')
    diary off
end
save([out 'a1_results.mat'],'boxes','output*','regions','EXCL*');