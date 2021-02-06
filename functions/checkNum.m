function result=checkNum(attrValue)

if not(isempty(str2num(attrValue)))
    result=(str2num(attrValue));
else
    result=NaN;
end

result=result';