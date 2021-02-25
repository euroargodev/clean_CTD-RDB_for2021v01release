addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))
clear variables;close all;
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\A4';
indir=[outp '\**\'];
list=dir([indir 'ctd*.mat']);
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\world\A4\';
indir=[outp '\**\'];
list2=dir([indir 'ctd*.mat']);

list=[list;list2];

outdir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\A5\';

for k=1:numel(list)
    filein=[list(k).folder '\' list(k).name];
    box(k)=str2double(list(k).name(5:8));
    fileout=[outdir list(k).name];
    eval(['copyfile ' filein ' ' fileout])
    
    m=matfile(fileout,'Writable',true);
    tmp=m.long;
    f{k}=find(tmp<0);
    tmp=convertlon(tmp,360);
    m.long=tmp;    
end

save a5_correct_long.mat f box