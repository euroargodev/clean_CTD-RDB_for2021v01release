addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\export_fig'
clear variables;close all
%whp_netcdf: 77DN19910726_nc_ctd.zip (Updated 2020-05-29, 793.4 kB)
indir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\CCHDO\77DN19910726_nc_ctd\';
list=dir([indir '*.nc']);
S3_77DN1991=table;
for i=1:numel(list)
    file=[indir list(i).name];
    S3_77DN1991.Longitude(i,1)=ncread(file,'longitude');
    S3_77DN1991.Latitude(i,1)=ncread(file,'latitude');
    S3_77DN1991.Dates(i,1)=ncread(file,'time');
    S3_77DN1991.Station(i,1)=str2double(ncread(file,'station')');
    S3_77DN1991.Cast(i,1)=str2double(ncread(file,'cast')');
end
%save S3_77DN1991.mat S3_77DN1991
lo=double(S3_77DN1991.Longitude);
la=double(S3_77DN1991.Latitude);
st=double(S3_77DN1991.Station);
save 77DN19910726_info.mat lo la st

cm=jet(numel(lo));

figure%('position',[5 646   912   484],'color','w')
for i=1:numel(lo)
m_plot(lo(i),la(i),'o','MarkerFaceColor',cm(i,:),'MarkerEdgeColor',cm(i,:))
hold on
end
m_grid('xtick',12,'ytick',80:2:88,'xtick',0:30:150,'linest','-');
m_coast('patch',[.7 .7 .7],'edgecolor','k');
title('Station from S2 - Netcdf files')
export_fig -r300 S3_77DN1991_stations.png
close all

%%
figure%('position',[5 646   912   484],'color','w')
for i=1:numel(lo)
m_text(lo(i),la(i),num2str(st(i)));
hold on
end
m_grid('xtick',12,'ytick',80:2:88,'xtick',0:30:150,'linest','-');
m_coast('patch',[.7 .7 .7],'edgecolor','k');
title('Station from S2 - Netcdf files')
export_fig -r300 S3_77DN1991_stations_numb.png
close all


