addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020'
addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\m_map'
clear variables
inpath1='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\udashprep\';
load([inpath1 'udash_2021'],'valid_boxes')
boxlist=valid_boxes;clear valid_boxes

inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\UDASH\A0\';

for i=1:numel(boxlist)
    filename=['ctd_' num2str(boxlist(i)) '.mat'];
    load([inpath filename ],'qclevel')
    for k=1:numel(qclevel)
        qclevel{k}='UDA';
    end
    save([inpath filename],'qclevel','-append')
end

matfilesdir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\UDASH\';

inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\UDASH\';

outp=inpath;
outpath=[outp 'A1\'];
F1_basic_corr(boxlist,inpath,outpath,[matfilesdir 'step1.mat']);
inpath=outpath;
outpath=[outp 'A2\'];
F2_exmetadup(boxlist,inpath,outpath,[matfilesdir 'step2.mat']);
inpath=outpath;
outpath=[outp 'A3\'];
F3_contdup(boxlist,inpath,outpath,[matfilesdir 'step3.mat']);
inpath=outpath;
outpath=[outp 'A4\'];
F4_nearmetadup(boxlist,inpath,outpath,[matfilesdir 'step4.mat']);
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\udash\';
F5_get_orindices([matfilesdir 'step1.mat'],...
    [matfilesdir 'step2.mat'],...
    [matfilesdir 'step3.mat'],...
    [matfilesdir 'step4.mat'],...
    [matfilesdir 'indices_steps.mat'])