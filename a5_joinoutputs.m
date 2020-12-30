clear variables;close all;
flist=dir('*_results.mat');

label=[];
% get all labels
for i=1:numel(flist)
    load(flist(i).name,'output_label')
    for k=1:numel(output_label)
        output_label{k}=[num2str(i) '_' output_label{k}];
    end
    label=[label output_label];
end
label={'boxes', label{:}}; %#ok<CCAT>

% load regions and boxes
load(flist(i).name,'boxes','regions')

n=numel(regions);

%% organize data
for j=1:n
    data=boxes{j}';
    for i=1:numel(flist)
        load(flist(i).name,'output')
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
    data4=data3-data(:,25);
    % putting them together
    data=[data(:,1:16) data2 data(:,17:21) data3 data(:,22:25) data4];
    out{j,1}=data;
    clear data    
end

%% fixing labels
label{11}=label{12};label{12}='1_end_n';

label=[label(:,1:16) '2_end_n' label(:,17:21) '3_end_n' label(:,22:25) '4_end_n'];
% fixing labels
label=strrep(label,'1','a');
label=strrep(label,'2','b');
label=strrep(label,'3','c');
label=strrep(label,'4','d');

%% Write to xls file

F_xlsx=sprintf('results.xlsx');
for j=1:n
    T = array2table(out{j},'VariableNames',label);
    writetable(T,F_xlsx,'Sheet',[regions{j}]);
end