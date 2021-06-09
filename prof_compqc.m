function [w,wqcl,wsrc,d,dlabel,qcl]=prof_compqc(filein,ind)
dlabel={'qclevel','source'};

if isempty(filein)||isempty(ind)
    w=[];d=[];wqcl=[];wsrc=[];qcl=[];
else
    % compare profile content
    data=extr_prof(filein,ind);
    
    qc={'SPI','DPY','CCH','GSD','GSH','UDA','BSH','PAN','OCL','COR','ICE'};
    
    % this is to accomodate a new qclevel value I was not aware of DPY,
    % that means deployment CTD. This profiles were ignored if already in
    % the database
    for i=1:2 
        if isempty(find(strcmp(data.qclevel(i),qc)==1))==0
            qcl(i)=find(strcmp(data.qclevel(i),qc)==1);
        else
            data.qclevel(i)
        end
        src(i)=str2double(data.source(i));
    end
    
    if diff(qcl)==0
        wqcl=0;
    else
        [~,m]=max(qcl);
        wqcl=m;
    end
    
    % for ices
    % source (for ices)
    fices=find(ismember(qcl,find(contains(qc,'ICE'))));
    if isempty(fices)==0
        for ii=1:numel(fices)
            s=data.source(fices(ii));
            s=strsplit(s{1},'_');
            if numel(s)==3
                s2=s{3};
            elseif numel(s)==1
                s2=s{1};
            end
            data.source{fices(ii)}=s2;
        end
    end
    src=[str2double(data.source(1)) str2double(data.source(2))];
    
    % worst source
    if sum(isnan(src))==0
        if src(1)==src(2)
            wsrc=0;
        else
            [~,m]=min(src);
            wsrc=m;
        end
    else
        wsrc=NaN;
    end
    
    w=[wqcl>0 isfinite(wsrc)];
    if sum(w==[0 1])==2
        w=wsrc;d=2;
    elseif sum(w==[0 0])==2
        w=0;d=0;
    elseif sum(w==[1 0])==2 || sum(w==[1 NaN])==2
        w=wqcl;d=1;
    elseif sum(w==[1 1])==2
        if wsrc==0
            w=wqcl;d=1;
        else
            w=wsrc;d=2;
        end
    end
end