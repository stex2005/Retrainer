%calculate outcome measures

% integrare il parametro valid - to be checked

clear all
close all
clc

currentPath=pwd;

[fname,pathname]=uigetfile('*.mat');

cd(pathname);
load(fname)

NR_exe=max(size(S1exerciseOK));

cd(currentPath)

th_angle=5; %degrees
th_vel=1; %degrees/sec
min_nr_samples_accepted=5;

%codes for selection of angles: [elbow shoul_elev shoul_rot] = [1 2 3]

%ciclo for che scorre tutti gli esercizi - tutti i task e tutte le
%ripetizioni
for n=1:NR_exe
    
    NR_task=S1exerciseOK{n}.Parameters.Total_NR_task;
    
    switch S1exerciseOK{n}.Parameters.Name
        case 'get_S1_E1_Name'
            title_fig='Ant Reach Plane';
            Task_to_consider=[1 3 5 7 9 11];
        case 'get_S1_E2_Name'
            title_fig='Ant Reach Space';
            Task_to_consider=[1 3 5 7 9 11];
        case 'get_S1_E3_Name'
            title_fig='Move Obj Plane';
            Task_to_consider=[1 4 7 9 12 15 17 20 23];
        case 'get_S1_E4_Name'
            title_fig='Move Obj Plane in Space';
            Task_to_consider=[1 4 7 9 12 15 17 20 23];
        case 'get_S1_E5_Name'
            title_fig='Move Obj Space';
            Task_to_consider=[1 4 5 8 10 13 14 17 19 22 23 26];
            
        case 'get_S1_E6_Name'
            title_fig='Lateral Elevation';
            Task_to_consider=[1 3 ];
        case 'get_S1_E7_Name'
            title_fig='Hand to Mouth';
            Task_to_consider=[1 3 ];
        case 'get_S1_E8_Name'
            title_fig='Hand to Mouth Obj';
            Task_to_consider=[1 3 ];
    end
    
    %figura active task (angoli) for each exercise
    
    figure
    
    for t=1:max(size(Task_to_consider))
        t_cur=Task_to_consider(t);
        
        
        %Lat Elev & H2M
        if max(size(Task_to_consider))==2
            switch t
                case 1
                    subplot(121)
                    title_figOK=strcat(title_fig,'- Up');
                    if(strcmp(S1exerciseOK{n}.Parameters.Name,'get_S1_E6_Name'))
                        code_angles=[2];
                    else
                        code_angles=[1];
                    end
                    
                case 2
                    subplot(122)
                    title_figOK=strcat(title_fig,'- Down');
                    if(strcmp(S1exerciseOK{n}.Parameters.Name,'get_S1_E6_Name'))
                        code_angles=[2];
                    else
                        code_angles=[1];
                    end
                    
            end
        end
        
        %Ant Reach (plane & space)
        if max(size(Task_to_consider))==6
            switch t
                case 1
                    subplot(321)
                    title_figOK=strcat(title_fig,'- Center');
                    code_angles=[1 2];
                    
                case 2
                    subplot(322)
                    title_figOK=strcat(title_fig,'- Rest');
                    code_angles=[1 2];
                    
                case 3
                    subplot(323)
                    title_figOK=strcat(title_fig,'- Internal');
                    code_angles=[1 2 3];
                    
                case 4
                    subplot(324)
                    title_figOK=strcat(title_fig,'- Rest');
                    code_angles=[1 2 3];
                    
                case 5
                    subplot(325)
                    title_figOK=strcat(title_fig,'- External');
                    code_angles=[1 2 3];
                    
                case 6
                    subplot(326)
                    title_figOK=strcat(title_fig,'- Rest');
                    code_angles=[1 2 3];
                    
            end
        end
        
        %Mov Obj (Plane & Plane in Space)
        if max(size(Task_to_consider))== 9
            switch t
                case 1
                    subplot(331)
                    title_figOK=strcat(title_fig,'- Rest to Center');
                    code_angles=[1 2];
                case 2
                    subplot(332)
                    title_figOK=strcat(title_fig,'- Center to Internal');
                    code_angles=[ 3];
                case 3
                    subplot(333)
                    title_figOK=strcat(title_fig,'- Internal to Rest');
                    code_angles=[1 2 3];
                case 4
                    subplot(334)
                    title_figOK=strcat(title_fig,'- Rest to Internal');
                    code_angles=[1 2 3];
                case 5
                    subplot(335)
                    title_figOK=strcat(title_fig,'- Internal to External');
                    code_angles=[3];
                    
                case 6
                    subplot(336)
                    title_figOK=strcat(title_fig,'- External to Rest');
                    code_angles=[1 2 3];
                    
                case 7
                    subplot(337)
                    title_figOK=strcat(title_fig,'- Rest to External');
                    code_angles=[1 2 3];
                    
                case 8
                    subplot(338)
                    title_figOK=strcat(title_fig,'- External to Center');
                    code_angles=[3];
                case 9
                    subplot(339)
                    title_figOK=strcat(title_fig,'- Center to Rest');
                    code_angles=[1 2];
                    
            end
            
        end
        
        % Move Obj in Space (ADDED on 9/1/2017) 
        if max(size(Task_to_consider))== 12
            switch t
                case 1
                    subplot(4,3,1)
                    title_figOK=strcat(title_fig,'- Rest to Center');
                    code_angles=[1 2];
                case 2
                    subplot(4,3,2)
                    title_figOK=strcat(title_fig,'- Lift');
                    code_angles=[2];
                case 3
                    subplot(4,3,3)
                    title_figOK=strcat(title_fig,'- Center to Internal ');
                    code_angles=[2 3];
                case 4
                    subplot(4,3,4)
                    title_figOK=strcat(title_fig,'- Internal to Rest');
                    code_angles=[1 2 3];
                case 5
                    subplot(4,3,5)
                    title_figOK=strcat(title_fig,'- Rest to Internal');
                    code_angles=[1 2 3];
                    
                case 6
                    subplot(4,3,6)
                    title_figOK=strcat(title_fig,'- Lift');
                    code_angles=[2];
                    
                case 7
                    subplot(4,3,7)
                    title_figOK=strcat(title_fig,'- Internal to External ');
                    code_angles=[2 3];
                    
                case 8
                    subplot(4,3,8)
                    title_figOK=strcat(title_fig,'- External to Rest');
                    code_angles=[1 2 3];
                case 9
                    subplot(4,3,9)
                    title_figOK=strcat(title_fig,'- Rest to External');
                    code_angles=[1 2 3];
                case 10
                    subplot(4,3,10)
                    title_figOK=strcat(title_fig,'- Lift');
                    code_angles=[ 2];
                case 11
                    subplot(4,3,11)
                    title_figOK=strcat(title_fig,'- External to Center');
                    code_angles=[ 2 3];
                case 12
                    subplot(4,3,12)
                    title_figOK=strcat(title_fig,'- Center to Rest');
                    code_angles=[1 2 ];
                    
            end
            
        end
        
        NR_rep=max(size(S1exerciseOK{n}.Task{t_cur}.rep));
        for r=1:NR_rep
            if(isempty(S1exerciseOK{n}.Task{t_cur}.rep{r}.time_ang)==0)
                %Number of samples for each rep
                S1exerciseOK{n}.Task{t_cur}.NR_samples_rep(r)=max(size(S1exerciseOK{n}.Task{t_cur}.rep{r}.time_ang));
            end
        end
        
        if(isfield(S1exerciseOK{n}.Task{t_cur},'NR_samples_rep'))
            
            %eliminate the repetitions which are much longer then the others
            mean_samples=nanmean(S1exerciseOK{n}.Task{t_cur}.NR_samples_rep);
            std_samples=nanstd(S1exerciseOK{n}.Task{t_cur}.NR_samples_rep);
            
            if(std_samples<5)
                ii=find(S1exerciseOK{n}.Task{t_cur}.NR_samples_rep > mean_samples -3*std_samples & S1exerciseOK{n}.Task{t_cur}.NR_samples_rep < mean_samples + 3*std_samples & S1exerciseOK{n}.Task{t_cur}.NR_samples_rep >min_nr_samples_accepted);
            else
                ii=find(S1exerciseOK{n}.Task{t_cur}.NR_samples_rep > mean_samples -2*std_samples & S1exerciseOK{n}.Task{t_cur}.NR_samples_rep < mean_samples + 2*std_samples & S1exerciseOK{n}.Task{t_cur}.NR_samples_rep >min_nr_samples_accepted);
            end
            
            for p=1:NR_rep
                if(find(ii==p))
                    S1exerciseOK_2{n}.Task{t}.rep{p}=S1exerciseOK{n}.Task{t_cur}.rep{p};
                else
                    S1exerciseOK_2{n}.Task{t}.rep{p}=NaN;
                end
            end
            S1exerciseOK_2{n}.Task{t}.NR_repTOT=NR_rep;
            S1exerciseOK_2{n}.Paramaters=S1exerciseOK{n}.Parameters;
            
            clear ii
            
            %number of rep for each task
            for r=1:NR_rep
                if(isfield(S1exerciseOK_2{n}.Task{t}.rep{r},'time_ang'))
                    if(isempty(S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang)==0)
                        hold on
                        plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle,'b')
                        plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle,'r')
                        plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle,'k')
                        
                        %Number of samples for each rep
                        S1exerciseOK_2{n}.Task{t}.NR_samples_rep(r)=max(size(S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang));
                        
                        %moving average of the angles
                        S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle=smooth(S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle,5);
                        S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle=smooth(S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle,5);
                        S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle=smooth(S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle,5);
                        
                        plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle,'--b')
                        plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle,'--r')
                        plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle,'--k')
                        
                        %ROM for all angles
                        S1exerciseOK_2{n}.Task{t}.ROM_elbow(r)=nanmax(S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle)-nanmin(S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle);
                        S1exerciseOK_2{n}.Task{t}.ROM_SE(r)=nanmax(S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle)-nanmin(S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle);
                        S1exerciseOK_2{n}.Task{t}.ROM_SR(r)=nanmax(S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle)-nanmin(S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle);
                    end
                else
                    S1exerciseOK_2{n}.Task{t}.ROM_elbow(r)=NaN;
                    S1exerciseOK_2{n}.Task{t}.ROM_SE(r)=NaN;
                    S1exerciseOK_2{n}.Task{t}.ROM_SR(r)=NaN;
                    S1exerciseOK_2{n}.Task{t}.NR_samples_rep(r)=NaN;
                end
            end
            
            if(isfield(S1exerciseOK_2{n}.Task{t},'ROM_elbow'))
                S1exerciseOK_2{n}.Task{t}.ROM_elbow_mean=nanmean(S1exerciseOK_2{n}.Task{t}.ROM_elbow);
                S1exerciseOK_2{n}.Task{t}.ROM_elbow_std=nanstd(S1exerciseOK_2{n}.Task{t}.ROM_elbow);
            end
            
            if(isfield(S1exerciseOK_2{n}.Task{t},'ROM_SE'))
                S1exerciseOK_2{n}.Task{t}.ROM_SE_mean=nanmean(S1exerciseOK_2{n}.Task{t}.ROM_SE);
                S1exerciseOK_2{n}.Task{t}.ROM_SE_std=nanstd(S1exerciseOK_2{n}.Task{t}.ROM_SE);
            end
            
            if(isfield(S1exerciseOK_2{n}.Task{t},'ROM_SR'))
                S1exerciseOK_2{n}.Task{t}.ROM_SR_mean=nanmean(S1exerciseOK_2{n}.Task{t}.ROM_SR);
                S1exerciseOK_2{n}.Task{t}.ROM_SR_std=nanstd(S1exerciseOK_2{n}.Task{t}.ROM_SR);
            end
            
            NR_samples=round(nanmean(S1exerciseOK_2{n}.Task{t}.NR_samples_rep));
            
            for r=1:NR_rep
                if(isfield(S1exerciseOK_2{n}.Task{t}.rep{r},'time_ang'))
                    if(isempty(S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang)==0)
                        
                        %time normalization of the three angles
                        S1exerciseOK_2{n}.Task{t}.elbowAngle_norm(1:NR_samples,r)=subactionsnorm(S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle,NR_samples);
                        S1exerciseOK_2{n}.Task{t}.SEAngle_norm(1:NR_samples,r)=subactionsnorm(S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle,NR_samples);
                        S1exerciseOK_2{n}.Task{t}.SRAngle_norm(1:NR_samples,r)=subactionsnorm(S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle,NR_samples);
                        
                        %smoothness for relevant angles (pre-defined + ROM for each
                        %repetition) & identification of the end of the movement
                        
                        find_stream_255=find(diff(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_ang)<-250);
                        if(find_stream_255)
                            S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_ang(find_stream_255+1:end)=S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_ang(find_stream_255+1:end)+256;
                        end
                        find_stream=find(not(diff(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_ang)==1));
                        
                        if(find_stream)
                            display('Attention Stream Angle')
                            [Y,I] = sort(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_ang);
                            S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle=S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle(I);
                            S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle=S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle(I);
                            S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle=S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle(I);
                        end
                        
                        find_stream_cur_255=find(diff(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_cur)<-250);
                        if(find_stream_cur_255)
                            S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_cur(find_stream_cur_255+1:end)=S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_cur(find_stream_cur_255+1:end)+256;
                        end
                        find_stream_cur=find(not(diff(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_cur)==1));
                        
                        if(find_stream_cur)
                            display('Attention Stream Cur')
                            [Y,I] = sort(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_cur);
                            S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle=S1exerciseOK_2{n}.Task{t}.rep{r}.I1(I);
                            S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle=S1exerciseOK_2{n}.Task{t}.rep{r}.I2(I);
                        end
                        
                        find_stream_EMG_255=find(diff(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_EMG)<-250);
                        if(find_stream_EMG_255)
                            S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_EMG(find_stream_EMG_255+1:end)=S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_EMG(find_stream_EMG_255+1:end)+256;
                        end
                        find_stream_EMG=find(not(diff(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_EMG)==1));
                        
                        if(find_stream_EMG)
                            display('Attention Stream EMG')
                            [Y,I] = sort(S1exerciseOK_2{n}.Task{t}.rep{r}.indexstream_EMG);
                            S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle=S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1(I);
                            S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle=S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2(I);
                        end
                        
                        for p=1:max(size(code_angles))
                            switch code_angles(p)
                                case 1
                                    if(S1exerciseOK_2{n}.Task{t}.ROM_elbow(r) > th_angle)
                                        %vel_elbow=diff(S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle)./diff(S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang);
                                        vel_elbow=diff(S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle)./40;
                                        vel_elbow=vel_elbow.*1000; %degrees/s
                                        S1exerciseOK_2{n}.Task{t}.smoothness_elbow(r)=abs(nanmean(vel_elbow)/nanmax(abs(vel_elbow)));
                                        temp_smooth(p)=S1exerciseOK_2{n}.Task{t}.smoothness_elbow(r);
                                        
                                        [m,I]=max(abs(vel_elbow));
                                        ii_mov=find(abs(vel_elbow(I:end))<th_vel);
                                        if(ii_mov)
                                            aa=find(diff(ii_mov)>1);
                                            if(aa)
                                                index_fine_temp(p)=ii_mov(aa(end)+1)+I;
                                            else
                                                index_fine_temp(p)=ii_mov(1)+I;
                                            end
                                            clear ii_mov aa
                                        else
                                            index_fine_temp(p)=max(size(vel_elbow));
                                            clear ii_mov
                                        end
                                        
                                        
                                    else
                                        S1exerciseOK_2{n}.Task{t}.smoothness_elbow(r)=NaN;
                                        temp_smooth(p)=NaN;
                                        index_fine_temp(p)=NaN;
                                    end
                                    
                                case 2
                                    if(S1exerciseOK_2{n}.Task{t}.ROM_SE(r) > th_angle)
                                        %vel_SE=diff(S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle)./diff(S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang);
                                        vel_SE=diff(S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle)./40;
                                        vel_SE=vel_SE.*1000; %degrees/s
                                        S1exerciseOK_2{n}.Task{t}.smoothness_SE(r)=abs(nanmean(vel_SE)/nanmax(abs(vel_SE)));
                                        temp_smooth(p)=S1exerciseOK_2{n}.Task{t}.smoothness_SE(r);
                                        
                                        [m,I]=max(abs(vel_SE));
                                        ii_mov=find(abs(vel_SE(I:end))<th_vel);
                                        if(ii_mov)
                                            aa=find(diff(ii_mov)>1);
                                            if(aa)
                                                index_fine_temp(p)=ii_mov(aa(end)+1)+I;
                                            else
                                                index_fine_temp(p)=ii_mov(1)+I;
                                            end
                                            clear ii_mov aa
                                        else
                                            index_fine_temp(p)=max(size(vel_SE));
                                            clear ii_mov
                                        end
                                        
                                    else
                                        S1exerciseOK_2{n}.Task{t}.smoothness_SE(r)=NaN;
                                        temp_smooth(p)=NaN;
                                        index_fine_temp(p)=NaN;
                                        
                                    end
                                    
                                case 3
                                    if(S1exerciseOK_2{n}.Task{t}.ROM_SR(r) > th_angle)
                                        %vel_SR=diff(S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle)./diff(S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang);
                                        vel_SR=diff(S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle)./40;
                                        vel_SR=vel_SR.*1000;  %degrees/s
                                        S1exerciseOK_2{n}.Task{t}.smoothness_SR(r)=abs(mean(vel_SR)/nanmax(abs(vel_SR)));
                                        temp_smooth(p)=S1exerciseOK_2{n}.Task{t}.smoothness_SR(r);
                                        
                                        [m,I]=max(abs(vel_SR));
                                        ii_mov=find(abs(vel_SR(I:end))<th_vel);
                                        if(ii_mov)
                                            aa=find(diff(ii_mov)>1);
                                            if(aa)
                                                index_fine_temp(p)=ii_mov(aa(end)+1)+I;
                                            else
                                                index_fine_temp(p)=ii_mov(1)+I;
                                            end
                                            clear ii_mov aa
                                        else
                                            index_fine_temp(p)=max(size(vel_SR));
                                            clear ii_mov
                                        end
                                        
                                    else
                                        S1exerciseOK_2{n}.Task{t}.smoothness_SR(r)=NaN;
                                        temp_smooth(p)=NaN;
                                        index_fine_temp(p)=NaN;
                                        
                                    end
                            end
                        end
                        
                        S1exerciseOK_2{n}.Task{t}.smoothness_ALL(r)=nanmean(temp_smooth);
                        S1exerciseOK_2{n}.Task{t}.index_fine(r)=nanmax(index_fine_temp);
                        if(isnan(S1exerciseOK_2{n}.Task{t}.index_fine(r)))
                            S1exerciseOK_2{n}.Task{t}.MT(r)=NaN;
                        else
                            S1exerciseOK_2{n}.Task{t}.MT(r)=(S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(S1exerciseOK_2{n}.Task{t}.index_fine(r))-S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))/1000; %seconds
                        end
                        clear vel_elbow vel_SE vel_SR temp_smooth index_fine_temp find_stream_255 find_stream
                        
                        if(isnan(S1exerciseOK_2{n}.Task{t}.MT(r))==0)
                            plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(S1exerciseOK_2{n}.Task{t}.index_fine(r)) - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.elbowAngle(S1exerciseOK_2{n}.Task{t}.index_fine(r)),'*b')
                            plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(S1exerciseOK_2{n}.Task{t}.index_fine(r)) - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.SEAngle(S1exerciseOK_2{n}.Task{t}.index_fine(r)),'*r')
                            plot((S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(S1exerciseOK_2{n}.Task{t}.index_fine(r)) - S1exerciseOK_2{n}.Task{t}.rep{r}.time_ang(1))./1000,S1exerciseOK_2{n}.Task{t}.rep{r}.SRAngle(S1exerciseOK_2{n}.Task{t}.index_fine(r)),'*k')
                        end
                        
                    end
                else
                    S1exerciseOK_2{n}.Task{t}.MT(r)=NaN;
                    S1exerciseOK_2{n}.Task{t}.smoothness_ALL(r)=NaN;
                    S1exerciseOK_2{n}.Task{t}.index_fine(r)=NaN;
                end
            end
            
            if(isfield(S1exerciseOK_2{n}.Task{t}.rep{r},'time_ang'))
                %calcolo CP for relevant angle (pre-defined + mean ROM)
                for p=1:max(size(code_angles))
                    switch code_angles(p)
                        case 1
                            if(S1exerciseOK_2{n}.Task{t}.ROM_elbow_mean > th_angle)
                                S=svd(S1exerciseOK_2{n}.Task{t}.elbowAngle_norm);
                                S1exerciseOK_2{n}.Task{t}.CP_elbow=S(1)^2./sum(S.^2);
                                temp_CP(p)=S1exerciseOK_2{n}.Task{t}.CP_elbow;
                                clear S
                            else
                                S1exerciseOK_2{n}.Task{t}.CP_elbow=NaN;
                                temp_CP(p)=NaN;
                            end
                            
                        case 2
                            if(S1exerciseOK_2{n}.Task{t}.ROM_SE_mean > th_angle)
                                S=svd(S1exerciseOK_2{n}.Task{t}.SEAngle_norm);
                                S1exerciseOK_2{n}.Task{t}.CP_SEAngle=S(1)^2./sum(S.^2);
                                temp_CP(p)=S1exerciseOK_2{n}.Task{t}.CP_SEAngle;
                                clear S
                            else
                                S1exerciseOK_2{n}.Task{t}.CP_SEAngle=NaN;
                                temp_CP(p)=NaN;
                            end
                            
                        case 3
                            if(S1exerciseOK_2{n}.Task{t}.ROM_SR_mean > th_angle)
                                S=svd(S1exerciseOK_2{n}.Task{t}.SRAngle_norm);
                                S1exerciseOK_2{n}.Task{t}.CP_SRAngle=S(1)^2./sum(S.^2);
                                temp_CP(p)=S1exerciseOK_2{n}.Task{t}.CP_SRAngle;
                                clear S
                            else
                                S1exerciseOK_2{n}.Task{t}.CP_SRAngle=NaN;
                                temp_CP(p)=NaN;
                            end
                            
                    end
                end
                
                
                S1exerciseOK_2{n}.Task{t}.CP_ALL=nanmean(temp_CP);
                clear temp_CP
            else
                S1exerciseOK_2{n}.Task{t}.CP_ALL=NaN;
            end
            
            
            if(t==1)
                legend('elbow','shou elev','shou rot')
            end
            xlabel('time [s]')
            ylabel ('angle [°]')
            title(title_figOK,'FontSize',14,'Fontweight','b')
            
            NR_rep_task(t)=S1exerciseOK_2{n}.Task{t}.NR_repTOT;
            
        else
            S1exerciseOK{n}.Task{t_cur}.NR_samples_rep=NaN;
        end
    end
    
    
    %movement time for the whole exercise
    if(exist('NR_rep_task'))
        
        min_NR_rep=min(NR_rep_task);
        for r=1:min_NR_rep
            temp=0;
            for t=1:max(size(Task_to_consider))
                temp=temp+S1exerciseOK_2{n}.Task{t}.MT(r);
            end
            S1exerciseOK_2{n}.exe_time(r)= temp;
        end
        S1exerciseOK_2{n}.total_rep=min_NR_rep;
        clear NR_rep_task
    end
    
    %calcolo trigger = success /ciclo su tutti i task e tutte le
    %ripetizioni
    
    S1exerciseOK_2{n}.task_timer=0;
    S1exerciseOK_2{n}.task_RFID=0;
    S1exerciseOK_2{n}.task_Angles=0;
    S1exerciseOK_2{n}.task_Manual=0;
    S1exerciseOK_2{n}.total_task=0;
    
    
    for t=1:NR_task
        NR_rep=max(size(S1exerciseOK{n}.Task{t}.rep));
        for r=1:NR_rep
            if (strcmp(S1exerciseOK{n}.Task{t}.rep{r}.trigger,'timer')==1)
                S1exerciseOK_2{n}.task_timer=S1exerciseOK_2{n}.task_timer+1;
            end
            if (strcmp(S1exerciseOK{n}.Task{t}.rep{r}.trigger,'rfid')==1)
                S1exerciseOK_2{n}.task_RFID=S1exerciseOK_2{n}.task_RFID+1;
            end
            if (strcmp(S1exerciseOK{n}.Task{t}.rep{r}.trigger,'newS1Values')==1)
                S1exerciseOK_2{n}.task_Angles=S1exerciseOK_2{n}.task_Angles+1;
            end
            if (strcmp(S1exerciseOK{n}.Task{t}.rep{r}.trigger,'nextStep')==1)
                S1exerciseOK_2{n}.task_Manual=S1exerciseOK_2{n}.task_Manual+1;
            end
            S1exerciseOK_2{n}.total_task=S1exerciseOK_2{n}.total_task+1;
        end
    end
    S1exerciseOK_2{n}.success=(S1exerciseOK_2{n}.task_RFID+ S1exerciseOK_2{n}.task_Angles)/(S1exerciseOK_2{n}.total_task-S1exerciseOK_2{n}.task_timer);
    
    
    %% INVOLVEMENT
    %     Stimolazione si attiva se EMG > soglia1 o soglia2 per 3 campioni consecutivi
    %
    % Involvement: calcoliamo media
    % 1) solo quando la stimolazione = max
    % 2) quanto stimolazione stimolazione > 0
    % Involvement = 1 se EMG medio > soglia3
    
    j1=0;
    j2=0;
    stim_1_ok=0;
    stim_2_ok=0;
    totinv1=0;
    totinv2=0;
    NR_task2=max(size(S1exerciseOK_2{n}.Task))
    
    for t=1:NR_task2
        NR_rep=max(size(S1exerciseOK_2{n}.Task{t}.rep));
        for r=1:NR_rep
            if (isfield(S1exerciseOK_2{n}.Task{t}.rep{r},'time_ang'))
                NR_S=length((S1exerciseOK_2{n}.Task{t}.rep{r}.timeEMG));
                I1_mean=mean(S1exerciseOK_2{n}.Task{t}.rep{r}.I1);
                I2_mean=mean(S1exerciseOK_2{n}.Task{t}.rep{r}.I2);
                EMG1_mean=mean(S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1);
                EMG2_mean=mean(S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2);
                
                for i=1:NR_S-2
                    
                    stim_1_ok=0;
                    stim_2_ok=0;
                    
                    
                    
                    %                 11=find(S1exerciseOK{n}.Task{t}.rep{r}.EMG1(i) > S1exerciseOK{n}.Task{t}.rep{r}.EMG_1a || S1exerciseOK{n}.Task{t}.rep{r}.EMG1(i) > S1exerciseOK{n}.Task{t}.rep{r}.EMG_1b);
                    %
                    if ((S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1(i) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_1a & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1(i+1) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_1a & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1(i+2) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_1a) ...
                            | (S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1(i) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_1b & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1(i+1) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_1b & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1(i+2) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_1b))
                        
                        stim_1_ok=1;
                    end
                    
                    if ((S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2(i) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_2a & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2(i+1) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_2a & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2(i+2) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_2a) ...
                            | (S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2(i) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_2b & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2(i+1) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_2b & S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2(i+2) > S1exerciseOK_2{n}.Task{t}.rep{r}.EMG_2b))
                        
                        stim_2_ok=1;
                    end
                end
                if I1_mean>0
                    if EMG1_mean>S1exerciseOK{n}.Task{t}.rep{r}.EMG_1c
                        S1exerciseOK_2{n}.Task{t}.rep{r}.inv_1=1;
                        totinv1=totinv1+1;
                    else
                        S1exerciseOK_2{n}.Task{t}.rep{r}.inv_1=0;
                    end
                    
                    %                             if S1exerciseOK{n}.Task{t}.rep{r}.I1==S1exerciseOK{n}.Task{t}.rep{r}.I_max_1
                    %                                 if EMG1_mean>EMG_1c
                    %                                     S1exerciseOK_2{n}.Task{t}.rep{r}.inv_1_max=1;
                    %                                 end
                    %                             else
                    %                                 S1exerciseOK_2{n}.Task{t}.rep{r}.inv_1_max=0;
                    %                             end
                else
                    S1exerciseOK_2{n}.Task{t}.rep{r}.inv_1=0;
                end
                
                
                
                if I2_mean>0
                    if EMG2_mean>S1exerciseOK{n}.Task{t}.rep{r}.EMG_2c
                        S1exerciseOK_2{n}.Task{t}.rep{r}.inv_2=1;
                        totinv2=totinv2+1;
                    else
                        S1exerciseOK_2{n}.Task{t}.rep{r}.inv_2=0;
                    end
                    
                    %                             if S1exerciseOK{n}.Task{t}.rep{r}.I2==S1exerciseOK{n}.Task{t}.rep{r}.I_max_2
                    %                                 if EMG2_mean>EMG_2c
                    %                                     S1exerciseOK_2{n}.Task{t}.inv_2_max=1;
                    %                                 end
                    %                             else
                    %                                 S1exerciseOK_2{n}.Task{t}.inv_2_max=0;
                    %                             end
                else
                    S1exerciseOK_2{n}.Task{t}.rep{r}.inv_2=0;
                end
                if stim_1_ok==1
                    j1=j1+1;
                    S1exerciseOK_2{n}.Task{t}.rep{r}.EMG1triggered=1;
                end
                if stim_2_ok==1
                    j2=j2+1;
                    S1exerciseOK_2{n}.Task{t}.rep{r}.EMG2triggered=1;
                end
            else
                display('ripetizione vuota')
            end
        end
        S1exerciseOK_2{n}.Task{t}.EMG1triggered=j1;
        S1exerciseOK_2{n}.Task{t}.EMG2triggered=j2;
        j1=0;
        j2=0;
    end
    S1exerciseOK_2{n}.inv1tot=totinv1;
    S1exerciseOK_2{n}.inv2tot=totinv2;
    totinv1=0;
    totinv2=0;
end





cd(pathname)

filename=strcat(fname(1:end-4),'_outcomes.mat');
save(filename, 'S1exerciseOK', 'S1exerciseOK_2')

cd(currentPath)

