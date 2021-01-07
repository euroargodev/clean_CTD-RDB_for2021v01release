function [boxfile,ipath]=get_boxfile(step,box)
load('regions.mat','boxesmat','regions')
inp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\';

inp=[inp 'A' num2str(step-1) '\'];
fb=find(boxesmat==box);[fbr,~]=ind2sub(size(boxesmat),fb);
ipath=[inp  regions{fbr} '\'];
boxfile=[ipath 'ctd_' num2str(b) '.mat'];
