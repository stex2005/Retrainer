function dataout=deNaN(data)
N=length(data);
%first not NaN
i=find(data.valid == 0);
i=i+1;
while i<N
    if (isnan(data(i)))
        data(i)=data(i-1);
        %extend previous value
    end
    i=i+1;
end
dataout=data;