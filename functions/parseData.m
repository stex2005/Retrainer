function [dataOut,stringOut] = parseData(dataIn,i, string,delimiter,tline)

idx=find(string==delimiter);
dataOut=dataIn;
if length(idx)<2
    dataOut=dataIn;
    dataOut(i).frameError=1;
    attrName='Error';
    attrValue='-999';
    %tline
    %string
    stringOut='';%data makes no sense here.
    fprintf('Error in  frame %d:%s',i,tline);
    
end

if length(idx)>2
        attrName=string(idx(1)+1:idx(2)-1);
        attrValue=string(idx(2)+1:idx(3)-1);
        stringOut=string(idx(3):end);%unprocessed part
end

if length(idx)==2
        attrName=string(idx(1)+1:idx(2)-1);
        attrValue=string(idx(2)+1:end);
        stringOut='';%no more to read
end


%attrValue=str2num(attrValue);

switch(attrName)
    case 'elbowBrake'
        dataOut{i}.elbowBrake=NaN;
        if strcmp(attrValue,'TRUE')
            dataOut{i}.elbowBrake=1;
        end
        if strcmp(attrValue,'FALSE')
            dataOut{i}.elbowBrake=0;
        end
        
    case 'shoulderelevationBrake'
        dataOut{i}.shoulderelevationBrake=NaN;
        if strcmp(attrValue,'TRUE')  dataOut{i}.shoulderelevationBrake=1; end
        if strcmp(attrValue,'FALSE') dataOut{i}.shoulderelevationBrake=0; end
        
    case 'shoulderrotationBrake'
        dataOut{i}.shoulderrotationBrake=NaN;
        if strcmp(attrValue,'TRUE')  dataOut{i}.shoulderrotationBrake=1; end
        if strcmp(attrValue,'FALSE') dataOut{i}.shoulderrotationBrake=0; end
        
    case 'hip'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.hip=str2num(attrValue);
        else    dataOut{i}.hip=NaN;
        end
        
    case 'I1'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.I1=str2num(attrValue);
        else    dataOut{i}.I1=NaN;
        end
        
    case 'I2'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.I2=str2num(attrValue);
        else    dataOut{i}.I2=NaN;
        end
        
    case 'PW1'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.PW1=str2num(attrValue);
        else    dataOut{i}.PW1=NaN;
        end
        
    case 'PW2'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.PW2=str2num(attrValue);
        else    dataOut{i}.PW2=NaN;
        end
        
    case 'tagfound'
        dataOut{i}.tagfound=NaN;
        if strcmp(attrValue,'TRUE')  dataOut{i}.tagfound=1; end
        if strcmp(attrValue,'FALSE') dataOut{i}.tagfound=0; end

    case 'tag'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.tag=str2num(attrValue);
        else    dataOut{i}.tag=NaN;
        end
    case 'rssi'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.rssi=str2num(attrValue);
        else    dataOut{i}.rssi=NaN;
        end
    case 'threshold' %RFID
        if not(isempty(str2num(attrValue)))
            dataOut{i}.threshold=str2num(attrValue);
        else    dataOut{i}.threshold=NaN;
        end
    case 'extPW'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.extPW=str2num(attrValue);
        else    dataOut{i}.extPW=NaN;
        end
    case 'flexPW'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.flexPW=str2num(attrValue);
        else    dataOut{i}.flexPW=NaN;
        end
    case 'EMG1'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.EMG1=str2num(attrValue);
        else    dataOut{i}.EMG1=NaN;
        end
    case 'EMG2'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.EMG2=str2num(attrValue);
        else    dataOut{i}.EMG2=NaN;
        end
    case 'elbowAngle'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.PW2=str2num(attrValue);
        else    dataOut{i}.PW2=NaN;
        end
    case 'shoulderelevationAngle'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.elbowAngle=str2num(attrValue);
        else    dataOut{i}.elbowAngle=NaN;
        end
    case 'shoulderrotationAngle'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.shoulderrotationAngle=str2num(attrValue);
        else    dataOut{i}.shoulderrotationAngle=NaN;
        end
    case 'force0'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.force0=str2num(attrValue);
        else    dataOut{i}.force0=NaN;
        end
    case 'force1'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.force1=str2num(attrValue);
        else    dataOut{i}.force1=NaN;
        end
    case 'force2'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.force2=str2num(attrValue);
        else    dataOut{i}.force2=NaN;
        end
    case 'force3'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.force3=str2num(attrValue);
        else    dataOut{i}.force3=NaN;
        end
    case 'force4'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.force4=str2num(attrValue);
        else    dataOut{i}.force4=NaN;
        end
    case 'force5'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.force5=str2num(attrValue);
        else    dataOut{i}.force5=NaN;
        end
    case 'IMUangle0'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.IMUangle0=str2num(attrValue);
        else    dataOut{i}.IMUangle0=NaN;
        end
        
    case 'IMUangle1'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.IMUangle1=str2num(attrValue);
        else    dataOut{i}.IMUangle1=NaN;
        end
        
    case 'VE1x'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE1x=str2num(attrValue);
        else    dataOut{i}.VE1x=NaN;
        end
    case 'VE1y'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE1y=str2num(attrValue);
        else    dataOut{i}.VE1y=NaN;
        end
    case 'VE1I'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE1I=str2num(attrValue);
        else    dataOut{i}.VE1I=NaN;
        end
        
    case 'VE2x'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE2x=str2num(attrValue);
        else    dataOut{i}.VE2x=NaN;
        end
    case 'VE2y'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE2y=str2num(attrValue);
        else    dataOut{i}.VE2y=NaN;
        end
    case 'VE2I'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE2I=str2num(attrValue);
        else    dataOut{i}.VE2I=NaN;
        end
    case 'VE3x'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE3x=str2num(attrValue);
        else    dataOut{i}.VE3x=NaN;
        end
    case 'VE3y'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE3y=str2num(attrValue);
        else    dataOut{i}.VE3y=NaN;
        end
    case 'VE3I'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE3I=str2num(attrValue);
        else    dataOut{i}.VE3I=NaN;
        end
    case 'VE4x'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE4x=str2num(attrValue);
        else    dataOut{i}.VE4x=NaN;
        end
    case 'VE4y'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE4y=str2num(attrValue);
        else    dataOut{i}.VE4y=NaN;
        end
    case 'VE4I'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE4I=str2num(attrValue);
        else    dataOut{i}.VE4I=NaN;
        end
        
    case 'VE5x'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE5x=str2num(attrValue);
        else    dataOut{i}.VE5x=NaN;
        end
        
    case 'VE5y'
        
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE5y=str2num(attrValue);
        else    dataOut{i}.VE5y=NaN;
        end
        
    case 'VE5I'
        if not(isempty(str2num(attrValue)))
            dataOut{i}.VE5I=str2num(attrValue);
        else    dataOut{i}.VE5I=NaN;
        end
        
        
    otherwise
        fprintf(strcat('Unrecognised case :',attrName));
end

end