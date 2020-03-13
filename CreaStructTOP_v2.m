if(exist('S1exercise'))
    clear S1exercise
end

if(exist('S1exerciseOK'))
    clear S1exerciseOK
end


%% find the number of different exercises done and create the main structured data
iNtask_AD=find(not(isnan(NextTaskEvent_anteriorDeltoid)));
iNtask_b=find(not(isnan(NextTaskEvent_biceps)));
iNtask_PD=find(not(isnan(NextTaskEvent_posteriorDeltoid)));
iNtask_MD=find(not(isnan(NextTaskEvent_medialDeltoid)));
iNtask_t=find(not(isnan(NextTaskEvent_triceps)));


if(isempty(iNtask_AD)==0)
    index_NextTask=iNtask_AD;
elseif(isempty(iNtask_b)==0)
    index_NextTask=iNtask_b;
elseif(isempty(iNtask_PD)==0)
    index_NextTask=iNtask_PD;
elseif(isempty(iNtask_MD)==0)
    index_NextTask=iNtask_MD;
elseif(isempty(iNtask_t)==0)
    index_NextTask=iNtask_t;
end

Name='';
AbsoluteTimeMS=AbsoluteTimeMS-AbsoluteTimeMS(1);

j=1; %index of exercises
for i=1:length(IndexexerciseLine)
    
    if ((strcmp(exercise{IndexexerciseLine(i)},Name) == 0 && strcmp(exercise{IndexexerciseLine(i)},'get_ExercisesDone') == 0) || (strcmp(startState{IndexexerciseLine(i)},'InitializeStateMachine') == 1))
        
        %%
        S1exercise{j}.Parameters.Name=exercise{IndexexerciseLine(i)};
        g=1; %index of muscles
        
        if ne(length(iNtask_t),0)
            S1exercise{j}.Parameters.StimMuscle{g}='Triceps';
            I(g,:)=triceps_I;
            PW(g,:)=triceps_PW;
            EMG(g,:)=triceps_EMG;
            
            %param
            EMG_THa(g,:)=Triceps_EMGa;
            EMG_THb(g,:)=Triceps_EMGb;
            EMG_THc(g,:)=Triceps_EMGc;
            I_target(g,:)=Triceps_I_target;
            PW_target(g,:)=Triceps_PW_target;
            
            NextTaskEvent(g,:)=NextTaskEvent_triceps;
            g=g+1;
        end
        if ne(length(iNtask_AD),0)
            S1exercise{j}.Parameters.StimMuscle{g}='Anterior Deltoid';
            EMG(g,:)=anteriorDeltoid_EMG;
            I(g,:)=anteriorDeltoid_I;
            PW(g,:)=anteriorDeltoid_PW;
            
            %param
            EMG_THa(g,:)=AnteriorDeltoid_EMGa;
            EMG_THb(g,:)=AnteriorDeltoid_EMGb;
            EMG_THc(g,:)=AnteriorDeltoid_EMGc;
            I_target(g,:)=AnteriorDeltoid_I_target;
            PW_target(g,:)=AnteriorDeltoid_PW_target;
            
            NextTaskEvent(g,:)= NextTaskEvent_anteriorDeltoid;
            g=g+1;
            
        end
        if ne(length(iNtask_MD),0)
            S1exercise{j}.Parameters.StimMuscle{g}='Medial Deltoid';
            EMG(g,:)=medialDeltoid_EMG;
            I(g,:)=medialDeltoid_I;
            PW(g,:)=medialDeltoid_PW;
            
            %param
            EMG_THa(g,:)=MedialDeltoid_EMGa;
            EMG_THb(g,:)=MedialDeltoid_EMGb;
            EMG_THc(g,:)=MedialDeltoid_EMGc;
            I_target(g,:)=(MedialDeltoid_I_target);
            PW_target(g,:)=(MedialDeltoid_PW_target);
            
            
            NextTaskEvent(g,:)=NextTaskEvent_medialDeltoid;
            g=g+1;
            
        end
        if ne(length(iNtask_PD),0)
            S1exercise{j}.Parameters.StimMuscle{g}='Posterior Deltoid';
            EMG(g,:)=posteriorDeltoid_EMG;
            I(g,:)=posteriorDeltoid_I;
            PW(g,:)=posteriorDeltoid_PW;
            
            %param
            EMG_THa(g,:)=PosteriorDeltoid_EMGa;
            EMG_THb(g,:)=PosteriorDeltoid_EMGb;
            EMG_THc(g,:)=PosteriorDeltoid_EMGc;
            I_target(g,:)=(PosteriorDeltoid_I_target);
            PW_target(g,:)=(PosteriorDeltoid_PW_target);
            
            NextTaskEvent(g,:)=NextTaskEvent_posteriorDeltoid;
            g=g+1;
            
        end
        if ne(length(iNtask_b),0)
            S1exercise{j}.Parameters.StimMuscle{g}='Biceps';
            EMG(g,:)=biceps_EMG;
            I(g,:)=biceps_I;
            PW(g,:)=biceps_PW;
            
            %param
            EMG_THa(g,:)=Biceps_EMGa;
            EMG_THb(g,:)=Biceps_EMGb;
            EMG_THc(g,:)=Biceps_EMGc;
            I_target(g,:)=(Biceps_I_target);
            PW_target(g,:)=(Biceps_PW_target);
            
            NextTaskEvent(g,:)=NextTaskEvent_biceps;
            g=g+1;
            
        end
        
        %vettori Tempo per identificare i parametri senza NaN
        
        index_param1=find(not(isnan(EMG_THa(1,:))));
        index_param2=find(not(isnan(EMG_THa(2,:))));
        
        AbsoluteTime_param_1_nonan=AbsoluteTime_param(index_param1);
        EMG_THa_1=EMG_THa(1,index_param1);
        EMG_THb_1=EMG_THb(1,index_param1);
        EMG_THc_1=EMG_THc(1,index_param1);
        I_target_1=I_target(1,index_param1);
        PW_target_1=PW_target(1,index_param1);
        
        
        AbsoluteTime_param_2_nonan=AbsoluteTime_param(index_param2);
        EMG_THa_2=EMG_THa(2,index_param2);
        EMG_THb_2=EMG_THb(2,index_param2);
        EMG_THc_2=EMG_THc(2,index_param2);
        I_target_2=I_target(2,index_param2);
        PW_target_2=PW_target(2,index_param2);
        
        Name=exercise{IndexexerciseLine(i)};
              
        switch Name
            case 'get_S1_E1_Name'
                S1exercise{j}.Parameters.Total_NR_task=12;
            case 'get_S1_E2_Name'
                S1exercise{j}.Parameters.Total_NR_task=12;
            case 'get_S1_E3_Name'
                S1exercise{j}.Parameters.Total_NR_task=24;
            case 'get_S1_E4_Name'
                S1exercise{j}.Parameters.Total_NR_task=24;
            case 'get_S1_E5_Name'
                S1exercise{j}.Parameters.Total_NR_task=27;
            case 'get_S1_E6_Name'
                S1exercise{j}.Parameters.Total_NR_task=4;
            case 'get_S1_E7_Name'
                S1exercise{j}.Parameters.Total_NR_task=4;
            case 'get_S1_E8_Name'
                S1exercise{j}.Parameters.Total_NR_task=4;
        end
        
        j=j+1;
    end
    if (strcmp(exercise{IndexexerciseLine(i)},'get_ExercisesDone') == 1)
        Name='';
    end
end

Name='';
ex_index=0;

for i=1:length(IndexexerciseLine)
    if ((strcmp(exercise{IndexexerciseLine(i)},Name) == 0 && strcmp(exercise{IndexexerciseLine(i)},'get_ExercisesDone') == 0) || (strcmp(startState{IndexexerciseLine(i)},'InitializeStateMachine') == 1))
        ex_index=ex_index+1;
        w=1; %index of repetition
        task_i=1; %index of task
        %         display('index New Exe - 2')
        %         IndexexerciseLine(i)
        Name=exercise{IndexexerciseLine(i)};
        
      
        
    end
    if (strcmp(exercise{IndexexerciseLine(i)},Name) == 1 && strcmp(exercise{IndexexerciseLine(i)},'get_ExercisesDone') == 0)
        
        if  (   strcmp(startState{IndexexerciseLine(i)}(end-4:end),'Pause') == 0 && strcmp(startState{IndexexerciseLine(i)},'S1_E8_Step00') == 0 && ...
                strcmp(startState{IndexexerciseLine(i)}(end-5:end),'_Start') == 0 && strcmp(startState{IndexexerciseLine(i)},'InitializeStateMachine') == 0 && ...
                strcmp(startState{IndexexerciseLine(i)}(end-4:end),'_Stop') == 0 && strcmp(startState{IndexexerciseLine(i)},'S1_E6_Step0') == 0 ...
                && strcmp(startState{IndexexerciseLine(i)},'S1_E1_Step00')== 0 && strcmp(startState{IndexexerciseLine(i)},'S1_E3_Step00')== 0 ...
                && strcmp(startState{IndexexerciseLine(i)},'S1_E7_Step00')== 0 && strcmp(startState{IndexexerciseLine(i)},'S1_E2_Step00') == 0  && ...
                strcmp(trigger{IndexexerciseLine(i)},'pause')==0 && strcmp(trigger{IndexexerciseLine(i)},'exit')==0 && ...
                strcmp(startState{IndexexerciseLine(i)},'S1_E4_Step00')== 0 && strcmp(startState{IndexexerciseLine(i)},'S1_E5_Step00')== 0 && ...
                strcmp(exercise{IndexexerciseLine(i)},'get_ExercisesDone') == 0)
            
            index=IndexexerciseLine(i);
            if(index==IndexexerciseLine(end))
                break
            else
                indexNext=IndexexerciseLine(i+1);
                
                % start_task to identify the beginning of the task
                a=find(index_NextTask>index,1);
                init_task=index_NextTask(a);
                S1exercise{ex_index}.Task{task_i}.rep{w}.valid=1;
                
                if (init_task>indexNext)
                    display('attenzione inizio - riga:')
                    index
                    init_task=index;
                    S1exercise{ex_index}.Task{task_i}.rep{w}.valid=0;
                end
                
                indexall=init_task:indexNext;
                indexall_inv=index:indexNext;
                
                
                S1exercise{ex_index}.Task{task_i}.rep{w}.I1=I(1,indexall);
                if min(size(I))==2
                    S1exercise{ex_index}.Task{task_i}.rep{w}.I2=I(2,indexall);
                end
                
                S1exercise{ex_index}.Task{task_i}.rep{w}.PW1=PW(1,indexall)';
                if min(size(PW))==2
                    S1exercise{ex_index}.Task{task_i}.rep{w}.PW2=PW(2,indexall)';
                end
                
                S1exercise{ex_index}.Task{task_i}.rep{w}.EMG1=EMG(1,indexall);
                if min(size(EMG))==2
                    S1exercise{ex_index}.Task{task_i}.rep{w}.EMG2=EMG(2,indexall)';
                end
                
                S1exercise{ex_index}.Task{task_i}.rep{w}.elbowAngle=elbowAngle(indexall);
                S1exercise{ex_index}.Task{task_i}.rep{w}.SEAngle=shoulderelevationAngle(indexall);
                S1exercise{ex_index}.Task{task_i}.rep{w}.SRAngle=shoulderrotationAngle(indexall);
                
                S1exercise{ex_index}.Task{task_i}.rep{w}.AbsTimeMS=AbsoluteTimeMS(indexall);
                S1exercise{ex_index}.Task{task_i}.rep{w}.indexstream_ang=IndexStream_angle(indexall);
                S1exercise{ex_index}.Task{task_i}.rep{w}.indexstream_EMG=IndexStream_EMG(indexall);
                S1exercise{ex_index}.Task{task_i}.rep{w}.indexstream_cur=IndexStream_cur(indexall);
                
                S1exercise{ex_index}.Task{task_i}.rep{w}.Name=startState{IndexexerciseLine(i)};
                S1exercise{ex_index}.Task{task_i}.rep{w}.Index=IndexexerciseLine(i);
                
                %SOGLIE
                TimeNext=AbsoluteTime(indexNext);
                
                find_1=find(AbsoluteTime_param_1_nonan<TimeNext,1, 'last');
                find_2=find(AbsoluteTime_param_2_nonan<TimeNext,1, 'last');
                
                %param muscle 1
                S1exercise{ex_index}.Task{task_i}.rep{w}.time_param1=AbsoluteTime_param_1_nonan(find_1)*1000;
                S1exercise{ex_index}.Task{task_i}.rep{w}.EMG_1a=EMG_THa_1(find_1);
                S1exercise{ex_index}.Task{task_i}.rep{w}.EMG_1b=EMG_THb_1(find_1);
                S1exercise{ex_index}.Task{task_i}.rep{w}.EMG_1c=EMG_THc_1(find_1);
                S1exercise{ex_index}.Task{task_i}.rep{w}.I_max_1=I_target_1(find_1);
                S1exercise{ex_index}.Task{task_i}.rep{w}.PW_max_1=PW_target_1(find_1);
                
                %param muscle 2
                S1exercise{ex_index}.Task{task_i}.rep{w}.time_param2=AbsoluteTime_param_2_nonan(find_2)*1000;
                S1exercise{ex_index}.Task{task_i}.rep{w}.EMG_2a=EMG_THa_2(find_2);
                S1exercise{ex_index}.Task{task_i}.rep{w}.EMG_2b=EMG_THb_2(find_2);
                S1exercise{ex_index}.Task{task_i}.rep{w}.EMG_2c=EMG_THc_2(find_2);
                S1exercise{ex_index}.Task{task_i}.rep{w}.I_max_2=I_target_2(find_2);
                S1exercise{ex_index}.Task{task_i}.rep{w}.PW_max_2=PW_target_2(find_2);
                
                
                %trigger
                S1exercise{ex_index}.Task{task_i}.rep{w}.trigger=trigger{index};
                
                % enable + tasktime
                S1exercise{ex_index}.Task{task_i}.rep{w}.Enable1=NextTaskEvent(1,init_task);
                if min(size(NextTaskEvent))==2
                    S1exercise{ex_index}.Task{task_i}.rep{w}.Enable2=NextTaskEvent(2,init_task);
                end
                S1exercise{ex_index}.Task{task_i}.rep{w}.tasktime=time(init_task);
                S1exercise{ex_index}.Task{task_i}.rep{w}.time_enable=AbsoluteTimeMS(init_task);
                
                %involvement
                S1exercise{ex_index}.Task{task_i}.rep{w}.involvement=involvement(indexall_inv)';
                S1exercise{ex_index}.Task{task_i}.rep{w}.AbsTimeMS_inv=AbsoluteTimeMS(indexall_inv);
                
                clear index indexNext indexall init_task find_1 find_2
                
                if (mod(task_i,S1exercise{ex_index}.Parameters.Total_NR_task)==0)
                    task_i=1;
                    w=w+1;
                    IndexexerciseLine(i);
                else
                    task_i=task_i+1;
                end
            end
            
        end
        
    end
        
    if(strcmp(exercise{IndexexerciseLine(i)},'get_ExercisesDone') == 1)
        Name='';
    end
end


%eliminiamo esercizi senza tasks o con meno di 3 ripetizioni

ex_indexOK=0;
for n=1:ex_index
    if(isfield(S1exercise{n},'Task'))
        if(max(size(S1exercise{n}.Task{1}.rep))>3)
            ex_indexOK=ex_indexOK+1;
            S1exerciseOK{ex_indexOK}=S1exercise{n};
        end
        
    end
end


for j=1:ex_indexOK
    display('New exe')
    for r=1:max(size(S1exerciseOK{j}.Task))
        display('New Task')
        for n=1:max(size(S1exerciseOK{j}.Task{r}.rep))
            display(S1exerciseOK{j}.Task{r}.rep{n}.Name)
            
            %REMOVE NAN
            
            %stream current
            ID=find(isnan(S1exerciseOK{j}.Task{r}.rep{n}.I1)==0);
            S1exerciseOK{j}.Task{r}.rep{n}.I1=S1exerciseOK{j}.Task{r}.rep{n}.I1(ID);
            if(isfield(S1exerciseOK{j}.Task{r}.rep{n},'I2'))
                S1exerciseOK{j}.Task{r}.rep{n}.I2=S1exerciseOK{j}.Task{r}.rep{n}.I2(ID);
            end
            S1exerciseOK{j}.Task{r}.rep{n}.PW1=S1exerciseOK{j}.Task{r}.rep{n}.PW1(ID);
            if(isfield(S1exerciseOK{j}.Task{r}.rep{n},'PW2'))
                S1exerciseOK{j}.Task{r}.rep{n}.PW2=S1exerciseOK{j}.Task{r}.rep{n}.PW2(ID);
            end
            
            S1exerciseOK{j}.Task{r}.rep{n}.timeI=S1exerciseOK{j}.Task{r}.rep{n}.AbsTimeMS(ID);
            S1exerciseOK{j}.Task{r}.rep{n}.indexstream_cur=S1exerciseOK{j}.Task{r}.rep{n}.indexstream_cur(ID);
            
            %stream EMG
            clear ID
            ID=find(isnan(S1exerciseOK{j}.Task{r}.rep{n}.EMG1)==0);
            S1exerciseOK{j}.Task{r}.rep{n}.EMG1=S1exerciseOK{j}.Task{r}.rep{n}.EMG1(ID);
            if(isfield(S1exerciseOK{j}.Task{r}.rep{n},'EMG2'))
                S1exerciseOK{j}.Task{r}.rep{n}.EMG2=S1exerciseOK{j}.Task{r}.rep{n}.EMG2(ID);
            end
            
            S1exerciseOK{j}.Task{r}.rep{n}.timeEMG=S1exerciseOK{j}.Task{r}.rep{n}.AbsTimeMS(ID);
            S1exerciseOK{j}.Task{r}.rep{n}.indexstream_EMG=S1exerciseOK{j}.Task{r}.rep{n}.indexstream_EMG(ID);
            
            
            %stream angle
            clear ID
            ID=find(isnan(S1exerciseOK{j}.Task{r}.rep{n}.elbowAngle)==0);
            S1exerciseOK{j}.Task{r}.rep{n}.elbowAngle=S1exerciseOK{j}.Task{r}.rep{n}.elbowAngle(ID);
            S1exerciseOK{j}.Task{r}.rep{n}.SEAngle=S1exerciseOK{j}.Task{r}.rep{n}.SEAngle(ID);
            S1exerciseOK{j}.Task{r}.rep{n}.SRAngle=S1exerciseOK{j}.Task{r}.rep{n}.SRAngle(ID);
            S1exerciseOK{j}.Task{r}.rep{n}.time_ang=S1exerciseOK{j}.Task{r}.rep{n}.AbsTimeMS(ID);
            S1exerciseOK{j}.Task{r}.rep{n}.indexstream_ang=S1exerciseOK{j}.Task{r}.rep{n}.indexstream_ang(ID);
            
            
            %involvement
            clear ID
            ID=find(isnan(S1exerciseOK{j}.Task{r}.rep{n}.involvement)==0);
            if (ID)
                S1exerciseOK{j}.Task{r}.rep{n}.involvement=S1exerciseOK{j}.Task{r}.rep{n}.involvement(ID);
                S1exerciseOK{j}.Task{r}.rep{n}.time_inv=S1exerciseOK{j}.Task{r}.rep{n}.AbsTimeMS_inv(ID);
                
            else
                S1exerciseOK{j}.Task{r}.rep{n}.involvement=NaN;
                S1exerciseOK{j}.Task{r}.rep{n}.time_inv=NaN;
            end
            
            
        end
    end
end




%%

%figure angle exe 1 (ok solo se 4 task)

i_ex=1;


figure

for r=1:4
    switch r
        case 1
            subplot(221)
        case 2
            subplot(222)
        case 3
            subplot(223)
        case 4
            subplot(224)
    end
    
    
    for n=1:max(size(S1exerciseOK{i_ex}.Task{r}.rep))
        if(isempty(S1exerciseOK{i_ex}.Task{r}.rep{n}.time_ang)==0)
            hold on
            plot(S1exerciseOK{i_ex}.Task{r}.rep{n}.time_ang - S1exerciseOK{i_ex}.Task{r}.rep{n}.time_ang(1),S1exerciseOK{i_ex}.Task{r}.rep{n}.elbowAngle,'b')
            plot(S1exerciseOK{i_ex}.Task{r}.rep{n}.time_ang - S1exerciseOK{i_ex}.Task{r}.rep{n}.time_ang(1),S1exerciseOK{i_ex}.Task{r}.rep{n}.SEAngle,'r')
            plot(S1exerciseOK{i_ex}.Task{r}.rep{n}.time_ang - S1exerciseOK{i_ex}.Task{r}.rep{n}.time_ang(1),S1exerciseOK{i_ex}.Task{r}.rep{n}.SRAngle,'k')
        end
    end
    legend('elbow','shou elev','shou rot')
    xlabel('time [ms]')
    ylabel ('angle [°]')
    title(strcat(S1exerciseOK{i_ex}.Parameters.Name,S1exerciseOK{i_ex}.Task{r}.rep{n}.Name),'Fontweight','b')
end


% %figure current
figure
%
for r=1:4
    switch r
        case 1
            subplot(221)
        case 2
            subplot(222)
        case 3
            subplot(223)
        case 4
            subplot(224)
    end
    
    
    for n=1:max(size(S1exerciseOK{i_ex}.Task{r}.rep))
        if(isempty(S1exerciseOK{i_ex}.Task{r}.rep{n}.timeI)==0)
            hold on
            plot(S1exerciseOK{i_ex}.Task{r}.rep{n}.timeI - S1exerciseOK{i_ex}.Task{r}.rep{n}.timeI(1), S1exerciseOK{i_ex}.Task{r}.rep{n}.I1,'b')
            plot(S1exerciseOK{i_ex}.Task{r}.rep{n}.timeI - S1exerciseOK{i_ex}.Task{r}.rep{n}.timeI(1),S1exerciseOK{i_ex}.Task{r}.rep{n}.I2,'r')
        end
    end
    legend('M1','M2')
    xlabel('time [ms]')
    ylabel ('current [mA]')
    title(strcat(S1exerciseOK{i_ex}.Parameters.Name,S1exerciseOK{i_ex}.Task{r}.rep{n}.Name),'Fontweight','b')
end


%figure EMG
figure

for r=1:4
    switch r
        case 1
            subplot(221)
        case 2
            subplot(222)
        case 3
            subplot(223)
        case 4
            subplot(224)
    end
    
    
    for n=1:max(size(S1exerciseOK{i_ex}.Task{r}.rep))
        if(isempty(S1exerciseOK{i_ex}.Task{r}.rep{n}.timeEMG)==0)
            hold on
            plot(S1exerciseOK{i_ex}.Task{r}.rep{n}.timeEMG - S1exerciseOK{i_ex}.Task{r}.rep{n}.timeEMG(1), S1exerciseOK{i_ex}.Task{r}.rep{n}.EMG1,'b')
            plot(S1exerciseOK{i_ex}.Task{r}.rep{n}.timeEMG - S1exerciseOK{i_ex}.Task{r}.rep{n}.timeEMG(1),S1exerciseOK{i_ex}.Task{r}.rep{n}.EMG2,'r')
        end
        
    end
    legend('M1','M2')
    xlabel('time [ms]')
    ylabel ('EMG [\muV]')
    title(strcat(S1exerciseOK{i_ex}.Parameters.Name,S1exerciseOK{i_ex}.Task{r}.rep{n}.Name),'Fontweight','b')
end