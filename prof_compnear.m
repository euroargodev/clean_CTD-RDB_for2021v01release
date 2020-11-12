function near=prof_compnear(filein,ind,time_t,dist_t)
% compare profile content
data=extr_prof(filein,ind);

daten=dates2daten(data.dates);
tdiff=abs(diff(daten));
dist=m_lldist(data.long,data.lat);

if dist<=dist_t && tdiff<=time_t
    near=1;
else
    near=0;
end
        
