function result=checkNum2(attrValue)
idx=find(attrValue=='_');


if not(isempty(str2num(attrValue(1:idx-1))))
    result(1)=(str2num(attrValue(1:idx-1)));
else
    result(1)=NaN;
end


if not(isempty(str2num(attrValue(idx+1:end))))
    result(2)=(str2num(attrValue(idx+1:end)));
else
    result(2)=NaN;
end

result=result';