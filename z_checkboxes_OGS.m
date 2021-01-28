inp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2019V01\';
list=dir([inp '*.mat']);
b=zeros(numel(list),1);
ogs=zeros(numel(list),1);
for i=1:numel(list)
    b(i)=str2num(list(i).name(5:8));
    load([inp list(i).name],'qclevel');
    f=find(contains(qclevel,'OGS'));
    ogs(i)=~isempty(f);
end