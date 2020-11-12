function ndd = ndecimaldig(vec)
f=isfinite(vec);
vec=vec(f);
for i=1:numel(vec)
    tmp=num2str(vec(i));
    tmp=strsplit(tmp,'.');
    if numel(tmp)==1 
        ndd(i,1)=0;
    else
        tmp=tmp{2};
        ndd(i,1)=numel(tmp);
    end
end