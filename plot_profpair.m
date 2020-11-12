function plot_profpair(data)
figure('color','w','position',[344  118  862  420])
set(gcf,'color','w')
subplot(1,3,2)
plot(data.temp,data.pres,'--.');grid on;axis tight;
set(gca,'ydir','reverse')
xlabel('Temperature [degC]')
ylabel('Pressure [dbar]')
grid on
subplot(1,3,3)
plot(data.sal,data.pres,'--.');grid on;axis tight
xlabel('Salinity [psu]')
ylabel('Pressure [dbar]')
set(gca,'ydir','reverse')
grid on

daten=dates2daten(data.dates);daten=datestr(daten,31);
% preparing input for plot
col={'BLUE','RED'};
for i=1:2
    d=strsplit(daten(i,:));
    info{1,i}=col{i};
    info{2,i}=num2str(data.long(i),'%1.2f');
    info{3,i}=num2str(data.lat(i),'%1.2f');
    info{4,i}=d{1};
    info{5,i}=d{2};
    info{6,i}=strrep(data.source{i},'_',' ');
    info{7,i}=data.qclevel{i};
end
TString=getTstring(info);
annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
    'Units','Normalized','Position',[0 0 1 1]);

function TString=getTstring(info)

varNames={'Color','Long','Lat','Date','Time','Source','Qclevel'};
%pause
%header2=[; header{1}';header{2}'];
T = cell2table(info,'RowNames',varNames,'VariableNames',{'Prof 1','Prof 2'});
TString = evalc('disp(T)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>', ' \rm');
TString = erase(TString,'_');
% 
match=["'"];TString = erase(TString,match);
