function [perc_t,perc_s,confirm]=prof_compcont(filein,ind)
% compare profile content
data=extr_prof(filein,ind);
perc_t = comp2prof(data.pres,data.temp,1);
perc_s = comp2prof(data.pres,data.sal,2);
% 
if perc_t >=95 && perc_s >=95
   confirm=1;
elseif perc_t <75 && perc_s <75
   confirm=0;
else 
    plot_profpair(data)
    tmp=input('Is this a duplicate? [1 yes] 0 no - ');
    if isempty(tmp); tmp=1;end
    if tmp>=0&&tmp<=1
        confirm=tmp;
    end  
end