clear variables
%boxlist
inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\UDASH\A4\';
list=dir([inpath 'ctd*.mat']);
for i=1:numel(list)
    str=strsplit(list(i).name,'_');
    str=strsplit(str{2},'.');
    boxlist(i)=str2double(str{1});
end    

ipath{1}='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\A6\';
ipath{2}='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\BSH\A4\';
ipath{3}='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\IOPAN\A4\';
ipath{4}='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\UDASH\A4\';

opath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\jointest\';

% get variables list
in=ipath{4};
filein=[in 'ctd_7700.mat'];
var_list=whos('-file',filein);
nvar=numel(var_list);
strv=[];
for i=1:nvar
    if i==nvar
        strv=[strv ' ' var_list(i).name];
    else
        strv=[strv var_list(i).name ' '];
    end
end
vars.var_list=strsplit(strv,' ');
vars.nvar=numel(var_list);
vec=[1:3 6 8];
for i=1:numel(vec)
    vars.var_vect{i}=var_list(vec(i)).name;
end
mat=[4 5 7 9];
for i=1:numel(mat)
    vars.var_mat{i}=var_list(mat(i)).name;
end
vars.strv=strv;

for i=1:numel(boxlist)
    indup{i}=join_boxes(ipath,vars,opath,boxlist(i));
end
% 
outpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\jointest\A2\';
F2_exmetadup(boxlist,opath,outpath,'testdup1.mat',indup)

list=dir([outpath '*.mat']);
for i=1:numel(list)
    m=matfile([outpath list(i).name]);
    if isempty(whos(m,'ind*'))==0
        indup{i}=m.indup;
    end
end

opath=outpath;
outpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\jointest\A3\';
F3_contdup(boxlist,opath,outpath,'testdup2.mat',indup)


list=dir([outpath '*.mat']);
for i=1:numel(list)
    m=matfile([outpath list(i).name]);
    if isempty(whos(m,'ind*'))==0
        indup{i}=m.indup;
    end
end

opath=outpath;
outpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\jointest\A4\';
F4_nearmetadup(boxlist,opath,outpath,'testdup3.mat',indup)
