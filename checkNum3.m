function result=checkNum3(attrValue)
idx=find(attrValue=='_');


if not(isempty(str2num(attrValue(1:idx(1)-1))))
    result(1)=(str2num(attrValue(1:idx(1)-1)));
else
    result(1)=NaN;
end


if not(isempty(str2num(attrValue(idx(1)+1:idx(2)-1))))
    result(2)=(str2num(attrValue(idx(1)+1:idx(2)-1)));
else
    result(2)=NaN;
end

if not(isempty(str2num(attrValue(idx(2)+1:end))))
    result(3)=(str2num(attrValue(idx(2)+1:end)));
else
    result(3)=NaN;
end

result=result';