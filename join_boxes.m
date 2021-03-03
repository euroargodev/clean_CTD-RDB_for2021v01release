function indup=join_boxes(ipath,vars,opath,box)

var_list=vars.var_list;
nvar=vars.nvar;
var_vect=vars.var_vect;
var_mat=vars.var_mat;
strv=vars.strv;

n=numel(ipath);
fileout=[opath 'ctd_' num2str(box)];

% loop for variables
for i=1:nvar    
    if isempty(find(contains(var_vect,var_list{i})))==0 % vector vars
        % loop for paths
        for k = 1:n
            in2=ipath{k};
            fileup=[in2 'ctd_' num2str(box) '.mat'];
            if exist(fileup,'file')==2
                eval(['load ' fileup ' ' var_list{i}])
                if exist('tmp','var')
                    eval(['tmp=[tmp ' var_list{i} '];' ])
                else
                    eval(['tmp= ' var_list{i} ';' ])
                end
            end
        end
        eval([var_list{i} '= tmp;' ])
        clear tmp
        
    else % matrix variables.
        % the number of rows of the new data must be the same as the matrix
        % already in the file (or viceversa)
        
        for k = 1:n
            in2=ipath{k};
            fileup=[in2 'ctd_' num2str(box) '.mat'];           
            if exist(fileup,'file')==2
                eval(['load ' fileup ' ' var_list{i}])
                if exist('tmp','var')
                    eval(['tmpm{k}=' var_list{i} ';'])
                else
                    eval(['tmpm{k}= ' var_list{i} ';' ])
                end
                s(k,:)=size(tmpm{k});
            end
        end
        tmpm=cell2fillnan(tmpm);
        eval([var_list{i} '= tmpm;' ])
        clear tmpm
    end
end

for k=1:n
    indup{k}=k*ones(1,s(k,2));
end
indup=cell2mat(indup);
strv=[strv ' indup'];

long=convertlon(long,360);

fileout=[opath 'ctd_' num2str(box)];
eval(['save ' fileout ' ' strv ' -v7.3'])