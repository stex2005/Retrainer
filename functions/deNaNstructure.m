function dataout=deNaN(data)
N=length(data);
%first not NaN
i=find(not(find(cell2mat(cellfun(@(data)any(isnan(data)),a,'UniformOutput',false)))),1);
i=i+1;
while i<N
    if (isnan(data(i)))
        data(i)=data(i-1);
        %extend previous value
    end
    i=i+1;
end
dataout=data;