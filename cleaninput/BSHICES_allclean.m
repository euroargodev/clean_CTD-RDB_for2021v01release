addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020'
addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))
clear variables
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\CTD_for_2019\wmo_boxes\uices_2015_2019\';

list=dir([inpath 'ctd*.mat']);
for i=1:numel(list)
    str=strsplit(list(i).name,'_');
    str=strsplit(str{2},'.');
    boxlist(i)=str2double(str{1});
end    

boutpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\BSH\';
outpath=[boutpath 'A0\'];
if ~exist(outpath, 'dir')
mkdir(outpath)
end

for i=1:numel(list)
    load([inpath list(i).name],'qclevel')
    for k=1:numel(qclevel)
        qclevel{k}='BSH';
    end
    box_copy(inpath,boxlist(i),outpath)
    save([outpath list(i).name],'qclevel','-append')
end

matfiledir=boutpath;

inpath=outpath;
outpath=[boutpath 'A1\'];
if ~exist(outpath, 'dir')
mkdir(outpath)
end
F1_basic_corr(boxlist,inpath,outpath,[matfiledir 'step1.mat']);

inpath=outpath;
outpath=[boutpath 'A2\'];
if ~exist(outpath, 'dir')
mkdir(outpath)
end
F2_exmetadup(boxlist,inpath,outpath,[matfiledir 'step2.mat']);

inpath=outpath;
outpath=[boutpath 'A3\'];
if ~exist(outpath, 'dir')
mkdir(outpath)
end
F3_contdup(boxlist,inpath,outpath,[matfiledir 'step3.mat']);

inpath=outpath;
outpath=[boutpath 'A4\'];
if ~exist(outpath, 'dir')
mkdir(outpath)
end
F4_nearmetadup(boxlist,inpath,outpath,[matfiledir 'step4.mat']);

inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\uices_2015_2019\';

F5_get_orindices([matfiledir 'step1.mat'],...
    [matfiledir 'step2.mat'],...
    [matfiledir 'step3.mat'],...
    [matfiledir 'step4.mat'],...
    [matfiledir 'indices_steps.mat'])