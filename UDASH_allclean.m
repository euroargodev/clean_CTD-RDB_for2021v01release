clear variables
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\udash\';
load([inpath 'udash_2021'],'valid_boxes')
boxlist=valid_boxes;clear valid_boxes

outp=inpath;
outpath=outp;
F1_basic_corr(boxlist,inpath,outpath,'step1.mat');
inpath=outpath;
outpath=[outp 'A1\'];
F2_exmetadup(boxlist,inpath,outpath,'step2.mat');
inpath=outpath;
outpath=[outp 'A2\'];
F3_contdup(boxlist,inpath,outpath,'step3.mat');
inpath=outpath;
outpath=[outp 'A3\'];
F4_nearmetadup(boxlist,inpath,outpath,'step4.mat');
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\udash\';
F5_get_orindices([inpath 'step1.mat'],...
    [inpath 'step2.mat'],...
    [inpath 'step3.mat'],...
    [inpath 'step4.mat'],...
    [inpath 'indices_steps.mat'])