function [w,d]=prof_comppc(filein,ind)
% compare profile content
data=extr_prof(filein,ind);

% gaps
mgap=max(diff(data.pres,1,1),[],1);
% salinity precision
sres=[median(ndecimaldig(data.sal(:,1))) median(ndecimaldig(data.sal(:,2)))];
% maximum recorded pressure
mrp=round(max(data.pres,[],1),0);
% average number of samples per dbar (larger is better resolution)
RP=max(data.pres,[],1)-min(data.pres,[],1);
vres=round(RP./sum(isfinite(data.pres),1),1);

if diff(mgap)==0
    if diff(sres)==0
        if diff(mrp)==0
            if diff(vres)==0
                w=0;d=0;
            else
                [~,m]=min(vres);
                w=m;d=4;
            end
        else
            [~,m]=min(mrp);
            w=m;d=3;
        end
    else
        [~,m]=min(sres);
        w=m;d=2;
    end
else
    [~,m]=min(mgap);
    w=m;d=1;
end