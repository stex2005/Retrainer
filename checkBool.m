function result=checkBool(attrValue)
if strcmp(attrValue,'True')
    result=1;
else
    if strcmp(attrValue,'False')
        result=0;
    else
        result=NaN;
    end
end