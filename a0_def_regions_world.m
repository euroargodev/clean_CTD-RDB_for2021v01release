addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\m_map'
addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\check_CTD-RDB'
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\export_fig'
%% ATLANTIC SECTOR
clear variables
	
boxes{1}=[1710:1717 1810:1817];
boxes{2}=[7605 7705:7707];
boxes{3}=[7208 7209 7106 7107];
boxes{4}=[7800:7802 1800:1809 1702:1709];
boxes{5}=[1600 1601 1700:1701 7600:7602 7700:7702];
boxes{6}=[1000 7000:7005 7101:7105 7201:7207 7301:7307 7400:7406 7501:7505 7603];
boxes{7}=[3000:100:3500 3201:100:3501 3302:100:3502 5000:5003 5100:5103 5200:5204 5300:5305 5400:5405 5500:5505];
boxes{8}=[3600:3602 5600:5605 3700:3702 5700:5705];

boxes=cell2mat(boxes);

indir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2019V01\';
list=dir([indir 'ctd*.mat']);
for i=1:numel(list)
    blist(i,1)=str2num(list(i).name(5:8));
end
tmp=setdiff(blist,boxes);clear boxes

%% MEDSEA
md=[1300, 1301, 1302, 1303, 1400, 1401, 1402, 1403, 1404, 7300, 7400];
tmp=setdiff(tmp,md);clear boxes
rest=tmp;

%%
regions={'SEPacific','SWPacific','NEPacific','NWPacific',...
    'Indian','EastAntarticCoast','RossGyre','AmericanArctic'};

boxes{1}=[5008:5013 5107:5113 5207:5213 5307:5313 5407:5413 5506:5513];
boxes{2}=[3014:3017 3114:3117 3215:3217 3315:3317 3415:3417 3515:3517 ...
          5014:5017 5114:5117 5214:5217 5314:5317 5414:5417 5514:5517];
boxes{3}=[7007:7017 7109:7117 7211:7217 7312:7317 7412:7417 7513:7517];
boxes{4}=[1012:1017  1112:1117 1212:1217 1313:1317 1414:1417 1516:1517];
boxes{5}=[1004:1009 1105:1109 1205:1206 3004:3010 3104:3112 3203:3211 3303:3314 3403:3414 3503:3514];
boxes{6}=3603:3614;
boxes{7}=[3615:3617 3715:3717 3816:3817 5606:5617 5707:5717 5814:5817];
boxes{8}=[7616:7617 7712:7717 7803:7817];

%%
boxesmat=nan(numel(boxes),max(cellfun(@numel,boxes)));
regionsmat=boxesmat;
for i=1:numel(boxes)
    boxesmat(i,1:numel(boxes{i}))=boxes{i};
    regionsmat(i,1:numel(boxes{i}))=repmat(i,1,numel(boxes{i}));
end
boxes{9}=setdiff(rest,boxesmat);

save regions_world.mat boxes regions boxesmat regionsmat rest

% %% plot regions
% cmp=hsv(9);
% for i=1:8
%     if i==1
%         pl=1;
%     else
%         pl =2;
%     end
%     clr=cmp(i,:);
%     plot_wmoboxes(boxes{i},clr,pl)
% end
% saveas(gcf,'region_def_world.fig')
% export_fig -r300 region_def_world.png