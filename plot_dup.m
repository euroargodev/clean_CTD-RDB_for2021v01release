function plot_dup(step,box)

bname=['ctd_' num2str(box) '.mat'];

load regions.mat boxes 
for i=1:numel(boxes)
    J=find(boxes{i}==box, 1);
    if isempty(J)==0
       I=i; 
        break
    end
end

path='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\';
load regions.mat regions
if step==2 % exact metadata
    fname='a2_results.mat';
    ipath=[path 'A1\' regions{I} '\'];
elseif step==3 %near metadata
    fname='a3_results.mat';
    ipath=[path 'A2\' regions{I} '\'];
elseif step==4 %cont
    fname='a4_results.mat';
    ipath=[path 'A3\' regions{I} '\'];
end

boxfile=[ipath bname];

% load output
eval(['load ' fname ' IND EXCL'])
IND=IND{I,J};EXCL=EXCL{I,J};

N=size(IND,1);

for i=1:N
    ind=IND(i,:);
    excl=ismember(ind,EXCL);
    if sum(excl)>0
       data=extr_prof(boxfile,ind);  
       plot_profpair(data,excl)
    end
end