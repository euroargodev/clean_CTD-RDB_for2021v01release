addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\m_map'
addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\check_CTD-RDB'
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\export_fig'
%%
clear variables
regions={'AsianArctic','BaffinBay','Caribbean','EuropeanArctic',...
    'NordicSeas','NorthAtlantic','SouthAtlantic','WeddellGyre'};
	
boxes{1}=[1710:1717 1810:1817];
boxes{2}=[7605 7705:7707];
boxes{3}=[7208 7209 7106 7107];
boxes{4}=[7800:7802 1800:1809 1702:1709];
boxes{5}=[1600 1601 1700:1701 7600:7602 7700:7702];
boxes{6}=[1000 7000:7005 7101:7105 7201:7207 7301:7307 7400:7406 7501:7505 7603];
boxes{7}=[3000:100:3500 3201:100:3501 3302:100:3502 5000:5003 5100:5103 5200:5204 5300:5305 5400:5405 5500:5505];
boxes{8}=[3600:3602 5600:5605 3700:3702 5700:5705];

% creat a matrix 
boxesmat=nan(numel(boxes),max(cellfun(@numel,boxes)));
regionsmat=boxesmat;
for i=1:numel(boxes)
    boxesmat(i,1:numel(boxes{i}))=boxes{i};
    regionsmat(i,1:numel(boxes{i}))=repmat(i,1,numel(boxes{i}));
end

save regions.mat boxes regions boxesmat regionsmat

% plot regions
cmp=hsv(8);
for i=1:8
    if i==1
        pl=1;
    else
        pl =2;
    end
    clr=cmp(i,:);
    plot_wmoboxes(boxes{i},clr,pl)
end
saveas(gcf,'region_def.fig')
export_fig -r300 region_def.png