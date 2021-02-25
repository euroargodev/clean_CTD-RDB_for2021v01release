inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2020V01\';
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\';
boxlist=1813;
outpath=[outp 'A1\'];
F1_basic_corr(boxlist,inpath,outpath,'test1.mat');
inpath=outpath;
outpath=[outp 'A2\'];
F2_exmetadup(boxlist,inpath,outpath,'test2.mat');
inpath=outpath;
outpath=[outp 'A3\'];
F3_contdup(boxlist,inpath,outpath,'test3.mat');
inpath=outpath;
outpath=[outp 'A4\'];
F4_nearmetadup(boxlist,inpath,outpath,'test4.mat');
F5_get_orindices('test1.mat','test2.mat','test3.mat','test4.mat','ind.mat')