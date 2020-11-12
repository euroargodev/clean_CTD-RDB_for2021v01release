clear variables
files=dir('*results.mat');
load regions

labels={'A1 initial N','outrange T samples','outrange S samples','Incompl. samples','Profs w. incompl. samples','Profs. out of box','Profs. too shallow','Profs. NMIP','A1 excluded',...
    'A2 N exact. metadup','A2 same content','A2 different content','A2 N Prof. excluded',...
    'A3 N near. metadup',' A3 same content','A3 different content','A3 N Prof. excluded',...
    'A4 N prob. contdup','A4 N contdup','A4 nearby','A4 far','A4 N Prof. excluded','Final N'};

for i=1:numel(regions)
    boxlist=boxes{i};
    for j=1:numel(boxlist)
        boxnames{j}=num2str(boxlist(j));
    end        
    %label={};
    for k=1:numel(files)
        load(files(k).name,'output*')        
        %label=[label output_label];
        if k==1
            data{k}=output{i}(:,1:end-2);
        else
            data{k}=output{i};
        end
    end
    data=cell2mat(data);
    data(isnan(data))=0;
    data(:,23)=data(:,1)-data(:,9)-data(:,13)-data(:,17)-data(:,22);
    test=array2table(data','RowNames',labels,'VariableNames',boxnames);
    writetable(test,'output.xlsx','WriteRowNames',true,'Sheet',regions{i}) 
    clear data boxnames
end