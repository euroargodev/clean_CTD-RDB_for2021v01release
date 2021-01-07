function [w,d,dlabel]=prof_comppc(filein,ind)
% compare profile content
data=extr_prof(filein,ind);
dlabel={'sres','mrp','gap','vres'};

% salinity precision
sres=[median(ndecimaldig(data.sal(:,1))) median(ndecimaldig(data.sal(:,2)))];
% average number of samples per dbar (larger is better resolution)
RP=max(data.pres,[],1)-min(data.pres,[],1);
vres=round(RP./sum(isfinite(data.pres),1),1);
% gaps
mgap=max(diff(data.pres,1,1),[],1);
% vs. sample distance
sd=1/vres;
if mgap(1)<5*sd(1)
    mgap(1)=NaN;
end
if mgap(2)<5*sd(2)
    mgap(2)=NaN;
end
% maximum recorded pressure
mrp=round(max(data.pres,[],1),0);

if diff(sres)==0
    if abs(diff(mrp))<50
        if sum(isfinite(mgap))==0
            if diff(vres)==0
                w=0;d=0;
            else
                [~,m]=min(vres);
                w=m;d=4;
            end
        else
            [~,m]=min(mgap);
            w=m;d=2;
        end
    else
        [~,m]=min(mrp);
        w=m;d=3;
    end
else
    [~,m]=min(sres);
    w=m;d=1;
end