clear variables
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\udash\';
load([inpath 'udash_2021'],'valid_boxes')
boxlist=valid_boxes;clear valid_boxes

for i=1:numel(boxlist)
    load([inpath 'ctd_' num2str(i) '.mat'],'qclevel')
    for k=1:numel(qclevel)
        qclevel{k}='UDA';
    end
    save([inpath list(i).name],'qclevel','-append')
end

matfilesdir=inpath;

outp=inpath;
outpath=outp;
F1_basic_corr(boxlist,inpath,outpath,[matfilesdir 'step1.mat']);
inpath=outpath;
outpath=[outp 'A1\'];
F2_exmetadup(boxlist,inpath,outpath,[matfilesdir 'step2.mat']);
inpath=outpath;
outpath=[outp 'A2\'];
F3_contdup(boxlist,inpath,outpath,[matfilesdir 'step3.mat']);
inpath=outpath;
outpath=[outp 'A3\'];
F4_nearmetadup(boxlist,inpath,outpath,[matfilesdir 'step4.mat']);
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\udash\';
F5_get_orindices([matfilesdir 'step1.mat'],...
    [matfilesdir 'step2.mat'],...
    [matfilesdir 'step3.mat'],...
    [matfilesdir 'step4.mat'],...
    [matfilesdir 'indices_steps.mat'])