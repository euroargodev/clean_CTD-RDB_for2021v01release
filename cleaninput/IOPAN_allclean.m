addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020'
addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))

clear variables
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\data_IOPAN\A0\';

list=dir([inpath 'ctd*.mat']);
for i=1:numel(list)
    str=strsplit(list(i).name,'_');
    str=strsplit(str{2},'.');
    boxlist(i)=str2double(str{1});
end    

outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\IOPAN\';
matfilesdir=outp;

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
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\uices_2015_2019\';


F5_get_orindices([matfilesdir 'step1.mat'],...
    [matfilesdir 'step2.mat'],...
    [matfilesdir 'step3.mat'],...
    [matfilesdir 'step4.mat'],...
    [matfilesdir 'indices_steps.mat'])