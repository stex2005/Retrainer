function dataout=deNaN2(data)
N=length(data);
%first not NaN
i=1;j=1;
while i<N
    if not(isnan(data(i)))    
        dataout(j)=data(i);
        j=j+1;
        %remove NAN values 
    end
    i=i+1;
end
