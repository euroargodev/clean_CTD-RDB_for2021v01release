function indup=join_boxes(ipath,opath,box)

n=numel(ipath);

% get variables list
in=ipath{1};
filein=[in 'ctd_' num2str(box)];
var_list=whos('-file',filein);
nvar=numel(var_list);
strv=[];
for i=1:nvar
    strv=[strv var_list(i).name ' '];
end

fileout=[opath 'ctd_' num2str(box)];

% loop for variables
for i=1:nvar
    eval(['load ' filein ' ' var_list(i).name])
    if var_list(i).size(1) ==1 % vector vars
        eval(['tmp=' var_list(i).name ';' ])
        for k = 2:n
            in2=ipath{k};
            fileup=[in2 'ctd_' num2str(box)];
            eval(['load ' fileup ' ' var_list(i).name])
            if k==n
                eval([var_list(i).name '= [tmp ' var_list(i).name '];' ])
            else
                eval(['tmp=[tmp ' var_list(i).name '];' ])
            end
        end
    else % matrix variables.
        % the number of rows of the new data must be the same as the matrix
        % already in the file (or viceversa)
        
        for k = 1:n
            fileup=[ipath{k} 'ctd_' num2str(box)];
            eval(['load ' fileup ' ' var_list(i).name])
            eval(['tmpm{k}=' var_list(i).name ';'])
            s(k,:)=size(tmpm{k});            
        end
        tmpm=cell2fillnan(tmpm);
        eval([var_list(i).name '= tmpm;' ])  
        clear tmpm
    end
end

for k=1:n
    indup{k}=k*ones(1,s(k,2));
end
indup=cell2mat(indup);
strv=[strv 'indup'];

long=convertlon(long,360);

fileout=[opath 'ctd_' num2str(box)];
eval(['save ' fileout ' ' strv ' -v7.3'])