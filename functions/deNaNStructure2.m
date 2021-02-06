function dataout=deNaN(data)
N=length(data);
%first not NaN
% i=find(not(isnan(data)),1);
i=1;
while i<N
    if (data{i}.valid == 0)
        data{i} = [];
        disp('NaN');
        %extend previous value
    end
    i=i+1;
end
dataout=data;