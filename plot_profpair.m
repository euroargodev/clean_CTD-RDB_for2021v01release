function plot_profpair(data,acc,extr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots two temperature/salinity profiles next to each other
% for visual comparison.
% Input: 
% DATA profile data as extracted with extr_prof.m
% ACC (optional) is a 2 element vector where 1 indicates an excluded profile
% and 0 a retained profile
% EXTR (also optional) is a structure that contains extra information to be
% plotted together with the profile info for example the criteria used for 
% deciding which profile was excluded. It must be in pairs. 
% For example
% extr.varNames={'criteria 1','criteria 2','indices','box','region'};
% extr.info={num2str(c1),cl1;num2str(c2),cl2;...
%            num2str(ind(l,1)),num2str(ind(l,2));num2str(b),' ';
%            regions{fbr},' '};
% Output: 
% A plot showing two profiles (temperature and salinity) for visual comparison.
% it also includes information about the profiles (text)
% 
% Obs. In the line figure('color','w','position',[left bottom width
% height]) the default units are pixels (unless you have specified
% otherwise in your Matlab) and the default ones are the ones I found best
% for my monitor set up in BSH. Change it to make it fit your screen.
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assign default values in case only the profile data is given
if nargin<3 % if no extra info is provided
   extr=[];
end
if nargin<2 % if no info about what the profile fate is available
    acc=[0 0]; % will not display eny info  
end

% Creates figure
figure('color','w','position',[344  118  862  420]) % this looks fine in my
% BSH monitor, you probably will need to adjust it for your display
set(gcf,'color','w')

% plots temperature
subplot(1,3,2)
plot(data.temp,data.pres,'--.');grid on;axis tight;
% configures axes
set(gca,'ydir','reverse')
xlabel('Temperature [degC]')
ylabel('Pressure [dbar]')
grid on

% plots salinity
subplot(1,3,3)
plot(data.sal,data.pres,'--.');grid on;axis tight
% configures axes
xlabel('Salinity [psu]')
ylabel('Pressure [dbar]')
set(gca,'ydir','reverse')
grid on

% fixes the date format for better display
daten=dates2daten(data.dates);daten=datestr(daten,31);

% preparing input for displaying the profile information for each profile
col={'BLUE','RED'}; 
varNames={'Color','Long','Lat','Date','Time','Source','Qclevel'};

% preallocating array
if sum(acc)>0
    nv=numel(varNames)+1;
else
    nv=numel(varNames);
end
info=cell(nv,2);

% Fills in the info cell
for i=1:2 % for each profile
    info{1,i}=col{i}; % color
    info{2,i}=num2str(data.long(i),'%1.2f'); % position
    info{3,i}=num2str(data.lat(i),'%1.2f');
    % date
    d=strsplit(daten(i,:)); % date
    info{4,i}=d{1};
    info{5,i}=d{2};
    % origin
    info{6,i}=strrep(data.source{i},'_',' '); % source
    info{7,i}=data.qclevel{i};% qclevel
    % profile fate
    if sum(acc)>0
        varNames{8}='Excluded';
        if acc(i)==1
            info{8,i}='yes';
        else
            info{8,i}='no';
        end
    end
end

% adds extra info in the info cell if available
if isempty(extr)==0
    varNames=[varNames extr.varNames];
    info=[info; extr.info];
end

% write the info in the plot
TString=getTstring(info,varNames);
% writes the profile details in the plot
annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
    'Units','Normalized','Position',[0 0 1 1]);

% 
function TString=getTstring(info,varNames)
%header2=[; header{1}';header{2}'];
T = cell2table(info,'RowNames',varNames,'VariableNames',{'Prof 1','Prof 2'});
TString = evalc('disp(T)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>', ' \rm');
TString = erase(TString,'_');
%
match=["'"];TString = erase(TString,match);
