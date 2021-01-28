clear variables;close all;
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\base\';
flist=dir([outp '*_results.mat']);

label=[];
% get all labels
for i=1:numel(flist)
    load([outp flist(i).name],'output_label')
    for k=1:numel(output_label)
        output_label{k}=[num2str(i) '_' output_label{k}];
    end
    label=[label output_label];
end
label={'boxes', label{:}}; %#ok<CCAT>

% load regions and boxes
load([outp flist(i).name],'boxes','regions')

n=numel(regions);

%% organize data
for j=1:n
    data=boxes{j}';
    for i=1:numel(flist)
        load([outp flist(i).name],'output')
        data=[data output{j}];
    end
    data(isnan(data))=0;
    % re/organize recalculate midvals
    % step 1/a
    data(:,11)=data(:,12);
    data(:,12)=data(:,2)-data(:,11)-data(:,10);
    
    % other midvalues (steps 2b-4d)
    data2=data(:,12)-data(:,16);
    data3=data2-data(:,21);
   % data4=data3-data(:,25);
    % putting them together
    data=[data(:,1:16) data2 data(:,17:21) data3]; % data(:,22:25) data4];
    out{j,1}=data;
    clear data
end

%% fixing labels
label{11}=label{12};label{12}='1_end_n';

label=[label(:,1:16) '2_end_n' label(:,17:21) '3_end_n'];% label(:,22:25) '4_end_n'];
% fixing labels
label=strrep(label,'1','s1');
label=strrep(label,'2','s2');
label=strrep(label,'3','s3');
%label=strrep(label,'4','d');

%% Write to xls file

% all results
F_xlsx=[outp 'results.xlsx'];
a=cell2mat(out);
% all
T = array2table(a,'VariableNames',label);
writetable(T,F_xlsx,'Sheet','all');
for j=1:n
    T = array2table(out{j},'VariableNames',label);
    writetable(T,F_xlsx,'Sheet',regions{j});
end

% Compact results
F_xlsx=[outp 'results_compact.xlsx'];
ind=[1	2	10	11	13	16	19	22];%	24	27	28];
T = array2table(a(:,ind),'VariableNames',label(ind));
writetable(T,F_xlsx,'Sheet','all');
for j=1:n
    T = array2table(out{j}(:,ind),'VariableNames',label(ind));
    writetable(T,F_xlsx,'Sheet',regions{j});
end

% Boxes to check (possible errors)
F_xlsx=[outp 'boxes_to_check.xlsx'];
ind=[1	8  15  21];
% all regions
T = array2table([a(:,ind) sum(a(:,[8 15 21]),2)],'VariableNames',{'box','profiles too shallow','meta dup pairs - different contents','content dup pairs - far away','total wrong prof'});
Ts = sortrows(T,'total wrong prof','descend');
writetable(Ts,F_xlsx,'Sheet','all');

%% Duplicate decision analysis
clearvars -except flist boxes n
outp='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\2020\base\';

% select only results from duplicate checks
flist=dir([outp '*_results.mat']);
flist=flist(2:3);%4);
%
F_xlsx=[outp 'results_duplicatedes.xlsx'];
for i=1:numel(flist)
    load([outp flist(i).name],'DES')
    data=[];  
    for j=1:n %each region
        b=boxes{j}';N=numel(b);
              
        des=DES(j,:);
        c=0;
        for k=1:N % each box
            tmp=des{k};
            % if there are duplicates
            if isempty(tmp)==0
                c=c+1;
                nd=numel(tmp);
                box=repmat(b(k),nd,1);
                data=[data; box tmp];
            end
        end
    end
    excl=find(isnan(data(:,2)));
    data(excl,:)=[];
    T = array2table(data,'VariableNames',{'box','dupl. excl. decision'});
    writetable(T,F_xlsx,'Sheet',flist(i).name(1:end-4));
end

