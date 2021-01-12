function showporc(k,n,pstep)
if floor(mod(k,pstep))==0
   f=round(100*k/n,1);
   disp([num2str(f) '% completed'])
end