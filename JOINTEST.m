box=1600;
ipath{1}='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\A6\';
ipath{2}='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\udash\A4\';
ipath{3}='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\io_pan\';
\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\CTD_for_2019\wmo_boxes\uices_2015_2019
opath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\jointest\';
indup=join_boxes(ipath,opath,box);

outpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\CTD-RDB_2020\';
boxlist(1)=box;
F2_exmetadup(boxlist,opath,outpath,'testdup1.mat',indup)

