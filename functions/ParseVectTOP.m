i=1;
j=1;
while ischar(tline) %file not ended
    while (length(tline)==0||(uint8(tline(1))==13 )) %skip empty lines
        % while originale to skip empty lines
        %(length(tline)==0||(uint8(tline(1))==13 && uint8(tline(2))==10 ))
        tline = fgets(fid);
    end
    
    if tline==-1
        break
    end
    
    if (strcmp(tline(1:end-2),'=====AddingSessionData=====') || strcmp(tline(1:end-1),'=====AddingSessionData====='))
        indiceBreak=i;
        break
    end
    
    
    AbsoluteTime(i)=str2num(tline(18:23))+60*str2num(tline(15:16))+3600*str2num(tline(12:13));
    AbsoluteTimeMS(i)=1000*AbsoluteTime(i);
    
    string=tline(24:end);
    while length(string)>0%check if there is residual data in this line
        idx=find(string==delimiter);
        
        % now check that enough data is there
        if length(idx)<2
            data(i).frameError=1;
            attrName='Error';
            attrValue='-999';
            %tline
            %string
            string='';%data makes no sense here.
            fprintf('Error in  frame %d:%s',i,tline);
        end
        
        if length(idx)>2 %we have one or more tokens
            attrName=string(idx(1)+1:idx(2)-1);
            attrValue=string(idx(2)+1:idx(3)-1);
            string=string(idx(3):end);%unprocessed part
        end
        
        if length(idx)==2% we have only one token
            attrName=string(idx(1)+1:idx(2)-1);
            attrValue=string(idx(2)+1:end);
            string='';%no more to read
        end
        
        switch attrName
            
            case 'startState'
                startState{i}=attrValue;
                
            case 'trigger'
                trigger{i}=attrValue;
                
            case 'endState'
                endState{i}=attrValue;
                
            case 'repetition'
                repetition(i)=checkNum(attrValue);
                
            case 'exercise'
                exercise{i}=attrValue;
                IndexexerciseLine(j)=i;
                j=j+1;
                % brakes Bools
            case 'elbowBrake'
                if parse_S1
                    elbowBrake(i)=checkBool(attrValue);
                end
                
            case 'shoulderelevationBrake'
                if parse_S1
                    shoulderelevationBrake(i)=checkBool(attrValue);
                end
                
            case 'shoulderrotationBrake'
                if parse_S1
                    shoulderrotationBrake(i)=checkBool(attrValue);
                end
                
                % angles value
            case 'hipBrake'
                if parse_S1
                    hipBrake(i)=checkNum(attrValue);
                end
            case 'elbowAngle'
                if parse_S1
                    elbowAngle(i)=checkNum(attrValue);
                end
                
            case 'shoulderelevationAngle'
                if parse_S1
                    shoulderelevationAngle(i)=checkNum(attrValue);
                end
                
            case 'shoulderrotationAngle'
                if parse_S1
                    shoulderrotationAngle(i)=checkNum(attrValue);
                end
                % FES values
            case 'get_Biceps_I'
                if parse_S1 biceps_I(i)=checkNum(attrValue); end
            case 'get_Triceps_I'
                if parse_S1 triceps_I(i)=checkNum(attrValue); end
            case 'get_AnteriorDeltoid_I'
                if parse_S1 anteriorDeltoid_I(i)=checkNum(attrValue); end
            case 'get_PosteriorDeltoid_I'
                if parse_S1 posteriorDeltoid_I(i)=checkNum(attrValue); end
            case 'get_MedialDeltoid_I'
                if parse_S1 medialDeltoid_I(i)=checkNum(attrValue); end
            case 'get_Biceps_PW'
                if parse_S1 biceps_PW(i)=checkNum(attrValue); end
            case 'get_Triceps_PW'
                if parse_S1 triceps_PW(i)=checkNum(attrValue); end
            case 'get_AnteriorDeltoid_PW'
                if parse_S1 anteriorDeltoid_PW(i)=checkNum(attrValue); end
            case 'get_PosteriorDeltoid_PW'
                if parse_S1 posteriorDeltoid_PW(i)=checkNum(attrValue); end
            case 'get_MedialDeltoid_PW'
                if parse_S1 medialDeltoid_PW(i)=checkNum(attrValue); end
                % index of streamed data
            case 'index'
                if parse_S1
                    idx2=find(tline==delimiter);
                    temp=tline(idx2(2)+1:idx2(3)-1);
                    switch temp
                        case 'get_Biceps_I'
                            IndexStream_cur(i)=checkNum(attrValue);
                        case 'get_Triceps_I'
                            IndexStream_cur(i)=checkNum(attrValue);
                        case 'get_AnteriorDeltoid_I'
                            IndexStream_cur(i)=checkNum(attrValue);
                        case 'get_PosteriorDeltoid_I'
                            IndexStream_cur(i)=checkNum(attrValue);
                        case 'get_MedialDeltoid_I'
                            IndexStream_cur(i)=checkNum(attrValue);
                            
                        case 'get_Biceps_EMG'
                            IndexStream_EMG(i)=checkNum(attrValue);
                        case 'get_Triceps_EMG'
                            IndexStream_EMG(i)=checkNum(attrValue);
                        case 'get_AnteriorDeltoid_EMG'
                            IndexStream_EMG(i)=checkNum(attrValue);
                        case 'get_PosteriorDeltoid_EMG'
                            IndexStream_EMG(i)=checkNum(attrValue);
                        case 'get_MedialDeltoid_EMG'
                            IndexStream_EMG(i)=checkNum(attrValue);
                            
                        case 'elbowAngle'
                            IndexStream_angle(i)=checkNum(attrValue);
                    end
                end
                
                % EMG values
            case 'get_Biceps_EMG'
                if parse_S1 biceps_EMG(i)=checkNum(attrValue); end
            case 'get_Triceps_EMG'
                if parse_S1 triceps_EMG(i)=checkNum(attrValue); end
            case 'get_AnteriorDeltoid_EMG'
                if parse_S1 anteriorDeltoid_EMG(i)=checkNum(attrValue); end
            case 'get_PosteriorDeltoid_EMG'
                if parse_S1 posteriorDeltoid_EMG(i)=checkNum(attrValue); end
            case 'get_MedialDeltoid_EMG'
                if parse_S1 medialDeltoid_EMG(i)=checkNum(attrValue); end
                
                %startTask
            case 'NextTaskEvent_get_Biceps'
                if parse_S1 NextTaskEvent_biceps(i)=checkBool(attrValue); end
            case 'NextTaskEvent_get_Triceps'
                if parse_S1 NextTaskEvent_triceps(i)=checkBool(attrValue); end
            case 'NextTaskEvent_get_AnteriorDeltoid'
                if parse_S1 NextTaskEvent_anteriorDeltoid(i)=checkBool(attrValue); end
            case 'NextTaskEvent_get_PosteriorDeltoid'
                if parse_S1 NextTaskEvent_posteriorDeltoid(i)=checkBool(attrValue); end
            case 'NextTaskEvent_get_MedialDeltoid'
                if parse_S1 NextTaskEvent_medialDeltoid(i)=checkBool(attrValue); end
            case 'involvement'
                if parse_S1 involvement(i)=checkBool(attrValue(1:end-2)); end
            case 'time'
                if parse_S1 time(i)=checkNum(attrValue); end
                
                % RFID stuff
            case 'tagfound'
                if parse_RFID
                    tagfound(i)=checkBool(attrValue);
                end
            case 'tag'
                if parse_RFID
                    tag(i)=checkNum(attrValue);
                end
            case 'rssi'
                if parse_RFID
                    rssi(i)=checkNum(attrValue);
                end
                
            case 'threshold'
                if parse_RFID
                    threshold(i)=checkNum(attrValue);
                end
               
            otherwise
                %                 fprintf(strcat('Unrecognised case : ',attrName,'\n'));
        end
    end
    
    i=i+1; % go to next frame
    tline = fgets(fid);
end

%%%%%
%%%%%
%%%%% PARTE 2
%%%%%
%%%%%

n=1; 
bi=1; ti=1; mdi=1; adi=1; pdi=1; 
ba=1; ta=1; ada=1; pda=1; mda=1; 
bp=1; tp=1; pdp=1; mdp=1; adp=1;
while ischar(tline)
    notread=0;
    while ((strcmp(tline(1:end-2),'=====AddingSessionData=====') || strcmp(tline(1:end-1),'=====AddingSessionData=====')) || (length(tline)==0))% skip this line
        notread=1;
        tline = fgets(fid);
    end
    
    if tline==-1
        break
    end
    
    if notread == 0
        AbsoluteTime2(n)=str2num(tline(18:23))+60*str2num(tline(15:16))+3600*str2num(tline(12:13));
        AbsoluteTimeMS2(n)=1000*AbsoluteTime2(n);
    end
    string=tline(24:end);
    
    while length(string)>0 %check if there is residual data in this line
        idx=find(string==delimiter);
        
        % now check that enough data is there
        if length(idx)<2
            data(n).frameError=1;
            attrName='Error';
            attrValue='-999';
            %tline
            %string
            string='';%data makes no sense here.
            fprintf('Error in  frame %d:%s',n,tline);
        end
        
        if length(idx)>2 %we have one or more tokens
            attrName=string(idx(1)+1:idx(2)-1);
            attrValue=string(idx(2)+1:idx(3)-1);
            string=string(idx(3):end);%unprocessed part
        end
        
        if length(idx)==2% we have only one token
            attrName=string(idx(1)+1:idx(2)-1);
            attrValue=string(idx(2)+1:end);
            string='';%no more to read
        end
        
        switch attrName
            
            case 'parameter'
                parameter{n}=attrValue;
            case 'use'
                use{n}=attrValue;
            case 'thresholdvalue'
                if strcmp(use{n},'relaxetime')
                    relax_time(n)=checkNum(attrValue);
                end
                
                % CURRENT target
            case 'get_Biceps_I_target'
                if parse_S1
                    Biceps_I_target(n)=checkNum(attrValue);
                    Index_IB(bi)=n;
                    Time_IB(bi)=AbsoluteTime2(n);
                    bi=bi+1;
                end
            case 'get_Triceps_I_target'
                if parse_S1
                    Triceps_I_target(n)=checkNum(attrValue);
                    Index_IT(ti)=n;
                    Time_IT(ti)=AbsoluteTime2(n);
                    ti=ti+1;
                end
            case 'get_AnteriorDeltoid_I_target'
                if parse_S1
                    AnteriorDeltoid_I_target(n)=checkNum(attrValue);
                    Index_IAD(adi)=n;
                    Time_IAD(adi)=AbsoluteTime2(n);
                    adi=adi+1;
                end
            case 'get_PosteriorDeltoid_I_target'
                if parse_S1
                    PosteriorDeltoid_I_target(n)=checkNum(attrValue);
                    Index_IPD(pdi)=n;
                    Time_IPD(pdi)=AbsoluteTime2(n);
                    pdi=pdi+1;
                end
            case 'get_MedialDeltoid_I_target'
                if parse_S1
                    MedialDeltoid_I_target(n)=checkNum(attrValue);
                    Index_IMD(mdi)=n;
                    Time_IMD(mdi)=AbsoluteTime2(n);
                    mdi=mdi+1;
                end            
                
                % EMGa for each muscle 
            case 'get_Biceps_EMGa'
                if parse_S1
                    Biceps_EMGa(n)=checkNum(attrValue);
                    Index_B_EMGa(ba)=n;
                    Time_B_EMGa(ba)=AbsoluteTime2(n);
                    ba=ba+1;
                end
            case 'get_Triceps_EMGa'
                if parse_S1
                    Triceps_EMGa(n)=checkNum(attrValue);
                    Index_T_EMGa(ta)=n;
                    Time_T_EMGa(ta)=AbsoluteTime2(n);
                    ta=ta+1;
                end
            case 'get_AnteriorDeltoid_EMGa'
                if parse_S1
                    AnteriorDeltoid_EMGa(n)=checkNum(attrValue);
                    Index_AD_EMGa(ada)=n;
                    Time_AD_EMGa(ada)=AbsoluteTime2(n);
                    ada=ada+1;
                end
            case 'get_PosteriorDeltoid_EMGa'
                if parse_S1
                    PosteriorDeltoid_EMGa(n)=checkNum(attrValue);
                    Index_PD_EMGa(pda)=n;
                    Time_PD_EMGa(pda)=AbsoluteTime2(n);
                    pda=pda+1;
                end
            case 'get_MedialDeltoid_EMGa'
                if parse_S1
                    MedialDeltoid_EMGa(n)=checkNum(attrValue);
                    Index_MD_EMGa(mda)=n;
                    Time_MD_EMGa(mda)=AbsoluteTime2(n);
                    mda=mda+1;
                end
                
                % EMGb for each muscle
            case 'get_Biceps_EMGb'
                if parse_S1
                    Biceps_EMGb(n)=checkNum(attrValue);
                end
            case 'get_Triceps_EMGb'
                if parse_S1
                    Triceps_EMGb(n)=checkNum(attrValue);
                end
            case 'get_AnteriorDeltoid_EMGb'
                if parse_S1
                    AnteriorDeltoid_EMGb(n)=checkNum(attrValue);
                end
            case 'get_PosteriorDeltoid_EMGb'
                if parse_S1
                    PosteriorDeltoid_EMGb(n)=checkNum(attrValue);
                end
            case 'get_MedialDeltoid_EMGb'
                if parse_S1
                    MedialDeltoid_EMGb(n)=checkNum(attrValue);
                end
                
                % EMGc for each muscle
            case 'get_Biceps_EMGc'
                if parse_S1
                    Biceps_EMGc(n)=checkNum(attrValue);
                end
            case 'get_Triceps_EMGc'
                if parse_S1
                    Triceps_EMGc(n)=checkNum(attrValue);
                end
            case 'get_AnteriorDeltoid_EMGc'
                if parse_S1
                    AnteriorDeltoid_EMGc(n)=checkNum(attrValue);
                end
            case 'get_PosteriorDeltoid_EMGc'
                if parse_S1
                    PosteriorDeltoid_EMGc(n)=checkNum(attrValue);
                end
            case 'get_MedialDeltoid_EMGc'
                if parse_S1
                    MedialDeltoid_EMGc(n)=checkNum(attrValue);
                end
                
                % PW target
            case 'get_Biceps_PW'
                if parse_S1
                    Biceps_PW_target(n)=checkNum(attrValue); 
                    Index_B_PW(bp)=n;
                    Time_B_PW(bp)=AbsoluteTime2(n);
                    bp=bp+1;
                end
            case 'get_Triceps_PW'
                if parse_S1
                    Triceps_PW_target(n)=checkNum(attrValue);
                    Index_T_PW(tp)=n;
                    Time_T_PW(tp)=AbsoluteTime2(n);
                    tp=tp+1;
                end
            case 'get_AnteriorDeltoid_PW'
                if parse_S1
                    AnteriorDeltoid_PW_target(n)=checkNum(attrValue);
                    Index_AD_PW(adp)=n;
                    Time_AD_PW(adp)=AbsoluteTime2(n);
                    adp=adp+1;
                end
            case 'get_PosteriorDeltoid_PW'
                if parse_S1
                    PosteriorDeltoid_PW_target(n)=checkNum(attrValue);
                    Index_PD_PW(pdp)=n;
                    Time_PD_PW(pdp)=AbsoluteTime2(n);
                    pdp=pdp+1;
                end
            case 'get_MedialDeltoid_PW'
                if parse_S1
                    MedialDeltoid_PW_target(n)=checkNum(attrValue);
                    Index_MD_PW(mdp)=n;
                    Time_MD_PW(mdp)=AbsoluteTime2(n);
                    mdp=mdp+1;
                end
            otherwise
                %                 fprintf(strcat('Unrecognised case : ',attrName,'\n'));
                
        end
        
    end   
    n=n+1; % go to next frame
    tline = fgets(fid);
    
end

Biceps_TH=[Time_B_EMGa' Biceps_EMGa(Index_B_EMGa) Biceps_EMGb(Index_B_EMGa) Biceps_EMGc(Index_B_EMGa)];

Triceps_TH=[Time_T_EMGa' Triceps_EMGa(Index_T_EMGa) Triceps_EMGb(Index_T_EMGa) Triceps_EMGc(Index_T_EMGa)];

AnteriorDeltoid_TH=[Time_AD_EMGa' AnteriorDeltoid_EMGa(Index_AD_EMGa) AnteriorDeltoid_EMGb(Index_AD_EMGa) AnteriorDeltoid_EMGc(Index_AD_EMGa)];

MedialDeltoid_TH=[Time_MD_EMGa' MedialDeltoid_EMGa(Index_MD_EMGa) MedialDeltoid_EMGb(Index_MD_EMGa) MedialDeltoid_EMGc(Index_MD_EMGa)];

PosteriorDeltoid_TH=[Time_PD_EMGa' PosteriorDeltoid_EMGa(Index_PD_EMGa) PosteriorDeltoid_EMGb(Index_PD_EMGa) PosteriorDeltoid_EMGc(Index_PD_EMGa)];


