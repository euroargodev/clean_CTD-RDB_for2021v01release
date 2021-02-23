clear variables
load removed_indices
% make a copy using the remaining indices
out='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\check2020V01\';
%mkdir([out 'indexcheck'])
load regions.mat

inpath='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2020V01\';
outpath=[out 'indexcheck\'];
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        box=boxlist(j);
        if isfile([inpath 'ctd_' num2str(box) '.mat'])
            i0=ind0{i,j};
            i4=ind4{i,j};
            excl=setdiff(i0,i4);
            box_excl(inpath,box,excl,outpath)
        end
    end
end
%
outpath1=[out 'indexcheck\'];
outpath2=[out 'A4\'];
check=nan(8,44);
for i=1:numel(boxes)
    % get box list for the region
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        box=boxlist(j);
        f1=[outpath1 'ctd_' num2str(box) '.mat'];
        f2=[outpath2 regions{i} '\' 'ctd_' num2str(box) '.mat'];
        if isfile(f1)
           file1=matfile(f1);
           file2=matfile(f2);
           %
           s1=file1.source;
           s2=file2.source;
           if numel(s1)>0
               for k=1:numel(s1)
                   cmp(k)=strcmp(s1{k},s2{k});
               end
               check(i,j)=sum(cmp)==numel(s1);
               clear cmp
           end
        end
    end
end
