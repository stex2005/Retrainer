%% Outcome Measures

% This code refines the data structure for the single patient and computes
% the outcome measures that are added to the original data structure.
%
% Inputs:
% MAT-file: file containing the data structure for one patient, all the
% sessions.
%
% Outputs:
% MAT-file: file containing the data structure for one patient, all the
% sessions + the computed outcome measures that are added to the original
% structure.
%
% Example:
% Input: VB-S1-R-0**_allSessions.mat
% Output: VB-S1-R-0**_allSessions_Outcomes.mat
%



%% CCC

ccc

% flags to plot Debug stuff

DebugMode = 0;
DebugModeInv = 0;
DebugModeIndex = 0;


%% Load MAT-file containing data structure of one patient

cd(userpath)
cd('DataAnalysis/mfile');
currentPath=pwd;
addpath(currentPath);
cd('../SessionData');
addpath(pwd);

[FileName,PathName]=uigetfile('*.mat');

cd(PathName)
load(FileName)
cd(currentPath)

%% Initialization

threshold_angle     = 3;            % ROM threshold used to compute Smoothness and Index_fine [degrees]
threshold_velocity  = 5;            % Angular velocity threshold used to compute Index_fine [degrees/sec]
threshold_velocity_samples = 5;     % # of samples above the "threshold_velocity" used to compute Index_fine
threshold_EMG       = 50;           % if EMG thresholds (1a,1b,1c,2a,2b,2c) are above this limit, section is discarded
min_number_samples  = 5;

%% Main Program

NR_sessions = max(size(Sessions));
% NR_sessions = 22;

% Running for each Session
for index_session =	1:NR_sessions
    
    fprintf('Session %d/%d: %s \n',index_session,NR_sessions,Sessions{index_session}.Date);
    if not(isempty(Sessions{index_session}.S1exerciseOK))                   % Check if the Session is empty
        Exercises_Temp = Sessions{index_session}.S1exerciseOK;              % Use a Temporary Variable
        NR_exe = max(size(Exercises_Temp));
        
        %% Check Multiple exercises
        
        Names = strings(1,NR_exe);
        
        for index_exe = 1:NR_exe                                            % Save in an array the names of all exercises
            Names(index_exe) = Exercises_Temp{index_exe}.Parameters.Name;
        end
        
        if max(size(Exercises_Temp))> 1
            for index_name = 1:8                                            % For each Exercise (from E1 to E8)
                
                Exercise_Name = strcat('get_S1_E',string(index_name),'_Name');
                Index_String = strfind(Names,Exercise_Name);                % Find how many times the exercise is performed in one session
                Index = find(not(cellfun('isempty', Index_String)));
                if max(size(Index)) > 1                                     % If an exercise is performed more than one time in one session
                    
                    Index = sort(Index,'descend');
                    for i = 1:(max(size(Index)-1))                          % Merge all the repetitions in one unique exercise
                        fprintf('Merging Exe %d to %d\n',Index(i),Index(i+1));
                        
                        Exercises_Temp{Index(i+1)}.rep = [ Exercises_Temp{Index(i+1)}.rep Exercises_Temp{Index(i)}.rep];
                        Exercises_Temp{Index(i)} = [];
                        
                    end
                    
                    
                end
                
            end
            clear Index_String Index Exercise_Name
            
            Exercises_Temp = Exercises_Temp(~cellfun('isempty',Exercises_Temp)); % Clear structure from empty cells
            NR_exe = max(size(Exercises_Temp));
        end
        
        % Running for each Exercise
        for index_exe = 1:NR_exe
            
            NR_rep = max(size(Exercises_Temp{index_exe}.rep));                  % Find NR_rep
            Exercises_Temp{index_exe}.total_NR_rep = NR_rep;
            NR_task = Exercises_Temp{index_exe}.Parameters.Total_NR_task;       % Find theoretical NR_task
            
            
            switch Exercises_Temp{index_exe}.Parameters.Name                    % Define "Task_to_consider" according to exercise
                case 'get_S1_E1_Name'
                    title_exe='Ant Reach Plane';
                    Task_to_consider=[1 3 5 7 9 11];
                case 'get_S1_E2_Name'
                    title_exe='Ant Reach Space';
                    Task_to_consider=[1 3 5 7 9 11];
                case 'get_S1_E3_Name'
                    title_exe='Move Obj Plane';
                    Task_to_consider=[1 4 7 9 12 15 17 20 23];
                case 'get_S1_E4_Name'
                    title_exe='Move Obj Plane in Space';
                    Task_to_consider=[1 4 7 9 12 15 17 20 23];
                case 'get_S1_E5_Name'
                    title_exe='Move Obj Space';
                    Task_to_consider=[1 4 5 8 10 13 14 17 19 22 23 26];
                case 'get_S1_E6_Name'
                    title_exe='Lateral Elevation';
                    Task_to_consider=[1 3 ];
                case 'get_S1_E7_Name'
                    title_exe='Hand to Mouth';
                    Task_to_consider=[1 3 ];
                case 'get_S1_E8_Name'
                    title_exe='Hand to Mouth Obj';
                    Task_to_consider=[1 3 ];
            end
            NR_task_to_consider = max(size(Task_to_consider));                  % Define dimension of "Task_to_consider"
            fprintf('Exercise %d/%d: %s \n',index_exe,NR_exe,title_exe);
            
            
            %% Compute "Success Rate"
            
            Exercises_Temp{index_exe}.task_timer  = 0;
            Exercises_Temp{index_exe}.task_RFID   = 0;
            Exercises_Temp{index_exe}.task_Angles = 0;
            Exercises_Temp{index_exe}.task_Manual = 0;
            Exercises_Temp{index_exe}.task_Error  = 0;
            Exercises_Temp{index_exe}.total_task  = 0;
            
            % For all sections count the number of times that a task is
            % triggered by:
            % 1) timer
            % 2) RFID match
            % 3) angle target reached
            % 4) manual trigger
            
            for index_rep = 1:NR_rep
                for index_task = 1:NR_task
                    if (strcmp(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.trigger,'timer')==1)
                        Exercises_Temp{index_exe}.task_timer=Exercises_Temp{index_exe}.task_timer+1;
                    elseif (strcmp(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.trigger,'rfid')==1)
                        Exercises_Temp{index_exe}.task_RFID=Exercises_Temp{index_exe}.task_RFID+1;
                    elseif (strcmp(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.trigger,'newS1Values')==1)
                        Exercises_Temp{index_exe}.task_Angles=Exercises_Temp{index_exe}.task_Angles+1;
                    elseif (strcmp(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.trigger,'nextStep')==1)
                        Exercises_Temp{index_exe}.task_Manual=Exercises_Temp{index_exe}.task_Manual+1;
                    else
                        Exercises_Temp{index_exe}.task_Manual=Exercises_Temp{index_exe}.task_Error+1;
                    end
                    Exercises_Temp{index_exe}.total_task=Exercises_Temp{index_exe}.total_task+1;
                end % end for tasks
            end % end for reps
            
            % Discard "task_timer" since they trigger the end of relax phases
            % Compute success rate
            Exercises_Temp{index_exe}.success = ( Exercises_Temp{index_exe}.task_RFID + Exercises_Temp{index_exe}.task_Angles ) / ( Exercises_Temp{index_exe}.total_task - Exercises_Temp{index_exe}.task_timer );
            
            
            %% NR_Samples for each section
            
            Exercises_Temp{index_exe}.total_samples = nan(NR_rep,NR_task_to_consider);
            
            for index_rep = 1:NR_rep
                for index_task_to_consider = 1:NR_task_to_consider
                    index_task = Task_to_consider(index_task_to_consider);
                    
                    Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min              = min([ max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang)), ...
                        max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG)), ...
                        max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeI))]);
                    Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles           = max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang));
                    
                    Exercises_Temp{index_exe}.total_samples(index_rep,index_task_to_consider) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles;
                    
                end % end for tasks
            end % end for reps
            
            %% Remove too long or too short sections
            
            for index_task_to_consider = 1:NR_task_to_consider
                index_task = Task_to_consider(index_task_to_consider);
                
                % compute mean # of samples during a section for each active task.
                mean_samples = nanmean(Exercises_Temp{index_exe}.total_samples(:,index_task_to_consider));
                std_samples  = nanstd(Exercises_Temp{index_exe}.total_samples(:,index_task_to_consider));
                
                for index_rep = 1:NR_rep
                    
                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid == 1
                        if(std_samples < 5)
                            if (Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles < mean_samples - 5*std_samples || ...
                                    Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles > mean_samples + 5*std_samples || ...
                                    Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles < min_number_samples)
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid = 0;
                            end
                        else
                            if (Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles < mean_samples - 3*std_samples || ...
                                    Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles > mean_samples + 3*std_samples || ...
                                    Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_angles < min_number_samples)
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid = 0;
                            end
                        end
                        %    UNCOMMENT THIS PART TO REMOVE ERRORS - ex. ANKF-006
                        
                        if  nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle) > 100 || nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle) > 100 || nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle) > 100
                            
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid = 0;
                        end
                        
                        
                    end
                end % end for reps
            end % end for tasks
            
            clear mean_samples std_samples
            
            %% ROM angles
            
            Exercises_Temp{index_exe}.ROM_elbow   = NaN(1,NR_rep);
            Exercises_Temp{index_exe}.ROM_SE      = NaN(1,NR_rep);
            Exercises_Temp{index_exe}.ROM_SR      = NaN(1,NR_rep);
            
            for index_rep = 1:NR_rep
                
                Exercises_Temp{index_exe}.rep{index_rep}.ROM_elbow = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.ROM_SE = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.ROM_SR = NaN(1,NR_task_to_consider);
                
                for index_task_to_consider = 1:NR_task_to_consider
                    index_task = Task_to_consider(index_task_to_consider);
                    
                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid == 1
                        
                        % Max ROM for each section
                        Exercises_Temp{index_exe}.rep{index_rep}.ROM_elbow(index_task_to_consider)= nanmax(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle) - ...
                            nanmin(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle);
                        Exercises_Temp{index_exe}.rep{index_rep}.ROM_SE(index_task_to_consider)   = nanmax(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle) - ...
                            nanmin(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle);
                        Exercises_Temp{index_exe}.rep{index_rep}.ROM_SR(index_task_to_consider)   = nanmax(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle) - ...
                            nanmin(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle);
                    end
                    
                end % for tasks
                
                % Max ROM for each Rep, over Tasks
                Exercises_Temp{index_exe}.ROM_elbow(index_rep) = nanmax(Exercises_Temp{index_exe}.rep{index_rep}.ROM_elbow);
                Exercises_Temp{index_exe}.ROM_SE(index_rep)    = nanmax(Exercises_Temp{index_exe}.rep{index_rep}.ROM_SE);
                Exercises_Temp{index_exe}.ROM_SR(index_rep)  = nanmax(Exercises_Temp{index_exe}.rep{index_rep}.ROM_SR);
                
            end % for reps
            
            %% Smoothness & Index Fine
            
            % Allocate vectors
            Exercises_Temp{index_exe}.MT   = NaN(1,NR_rep);     % Compute from "StartTask" to "Index_fine"
            Exercises_Temp{index_exe}.MT2  = NaN(1,NR_rep);     % Compute from "StartTask" to end
            Exercises_Temp{index_exe}.NR_rep_complete = 0;      % Number of reps with all "task_to_consider" available (not valid = 0)
            
            for index_rep = 1:NR_rep
                
                Exercises_Temp{index_exe}.rep{index_rep}.MT                       = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.MT2                      = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_elbow         = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_SE            = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_SR            = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_elbow         = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SE            = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SR            = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine               = NaN(1,NR_task_to_consider);
                
                
                for index_task_to_consider = 1:NR_task_to_consider
                    index_task = Task_to_consider(index_task_to_consider);
                    
                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid == 1
                        
                        %% Correct Angle Stream
                        
                        % When section is longer than 255 samples, index is
                        % realligned in order to be increasing linearly up to
                        % the end of the section.
                        
                        find_stream_255=find(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang)<-245);
                        if(find_stream_255)
                            while(find_stream_255)
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang(find_stream_255+1:end)=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang(find_stream_255+1:end)+256;
                                find_stream_255=find(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang)<-250);
                            end
                        end
                        
                        % When indexstream is not increasing linearly, the
                        % section is resorted according to indexstream.
                        
                        find_stream=find(not(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang)==1));
                        if(find_stream)
                            fprintf('Attention Stream Angle Rep: %d\n',index_rep);
                            if DebugModeIndex
                                figure
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang)
                            end
                            [Y,I] = sort(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang);
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang(I);
                            if DebugModeIndex
                                figure
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_ang)
                            end
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(I);
                            if DebugModeIndex
                                figure
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang)
                            end
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle(I);
                            %                         if DebugModeIndex
                            %                             figure
                            %                             plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle)
                            %                         end
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle(I);
                            %                         if DebugModeIndex
                            %                             figure
                            %                             plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle)
                            %                         end
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle(I);
                            %                         if DebugModeIndex
                            %                             figure
                            %                             plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle)
                            %                         end
                        end
                        
                        %% Corrent Current Stream
                        
                        % When section is longer than 255 samples, index is
                        % realligned in order to be increasing linearly up to
                        % the end of the section.
                        
                        find_stream_cur_255=find(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur)<-245);
                        if(find_stream_cur_255)
                            while(find_stream_cur_255)
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur(find_stream_cur_255+1:end)=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur(find_stream_cur_255+1:end)+256;
                                find_stream_cur_255=find(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur)<-250);
                            end
                        end
                        
                        % When indexstream is not increasing linearly, the
                        % section is resorted according to indexstream.
                        
                        find_stream_cur=find(not(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur)==1));
                        if(find_stream_cur)
                            fprintf('Attention Stream Current Rep: %d\n',index_rep);
                            [Y,I] = sort(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur);
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_cur(I);
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeI = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeI(I);
                            if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'I1')
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I1=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I1(I);
                            end
                            if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'I2')
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I2=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I2(I);
                            end
                        end
                        
                        %% Correct EMG Stream
                        
                        % When section is longer than 255 samples, index is
                        % realligned in order to be increasing linearly up to
                        % the end of the section.
                        
                        find_stream_EMG_255=find(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG)<-250);
                        if(find_stream_EMG_255)
                            while(find_stream_EMG_255)
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG(find_stream_EMG_255+1:end)=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG(find_stream_EMG_255+1:end)+256;
                                find_stream_EMG_255=find(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG)<-250);
                            end
                        end
                        
                        % When indexstream is not increasing linearly, the
                        % section is resorted according to indexstream.
                        
                        find_stream_EMG=find(not(diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG)==1));
                        if(find_stream_EMG)
                            fprintf('Attention Stream EMG Rep: %d\n',index_rep);
                            [Y,I] = sort(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG);
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.indexstream_EMG(I);
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG(I);
                            if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'EMG1')
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1(I);
                            end
                            if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'EMG2')
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2=Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2(I);
                            end
                        end
                        
                        %% Compute Smoothness & Index Fine - ELBOW
                        
                        
                        % Consider only sections with ROM > "threshold_angle"
                        % otherwise outcomes are not representative of the
                        % actual movement.
                        
                        if Exercises_Temp{index_exe}.rep{index_rep}.ROM_elbow(index_task_to_consider) > threshold_angle
                            
                            % Compute velocity of the elbow [degrees/sec]
                            vel_elbow=diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle)./40;
                            vel_elbow=vel_elbow.*1000;
                            
                            % Compute "Index_fine" as the last instant when the
                            % angular velocity is above "threshold_velocity"
                            % for "threshold_velocity_samples" amount of times.
                            
                            ii_mov = find(abs(vel_elbow) > threshold_velocity);
                            a=diff(ii_mov');
                            b=find([a inf]>1);
                            c=diff([0 b]); %length of the sequences
                            c=c(1:find(c>threshold_velocity_samples,1,'last'));
                            d=sum(c);      %endpoints of the sequences
                            if d ~= 0
                                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_elbow(index_task_to_consider)=ii_mov(d);
                            else
                                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_elbow(index_task_to_consider)=max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle));
                            end
                            clear a b c d ii_mov
                            
                            % Compute Smoothness as mean velocity/ max velocity
                            % from "StartTask" to "Index_fine"
                            vel_elbow = vel_elbow(1:Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_elbow(index_task_to_consider)-1);
                            Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_elbow(index_task_to_consider) = abs(nanmean(vel_elbow) / nanmax(abs(vel_elbow)));
                            
                            if DebugMode
                                figure
                                plot(abs(vel_elbow))
                                hold on
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle)
                                hline(threshold_velocity,'R');
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_elbow(index_task_to_consider),Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_elbow(index_task_to_consider)),'*r');
                            end
                        end
                        
                        %% Compute Smoothness & Index Fine - SE
                        
                        if Exercises_Temp{index_exe}.rep{index_rep}.ROM_SE(index_task_to_consider) > threshold_angle
                            
                            vel_SE=diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle)./40;
                            vel_SE=vel_SE.*1000; %degrees/s
                            
                            ii_mov = find(abs(vel_SE) > threshold_velocity);
                            a=diff(ii_mov');
                            b=find([a inf]>1);
                            c=diff([0 b]); %length of the sequences
                            c=c(1:find(c>threshold_velocity_samples,1,'last'));
                            d=sum(c);      %endpoints of the sequences
                            if d ~= 0
                                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SE(index_task_to_consider)=ii_mov(d);
                            else
                                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SE(index_task_to_consider)=max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle));
                            end
                            clear a b c d ii_mov
                            
                            vel_SE = vel_SE(1:Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SE(index_task_to_consider)-1);
                            Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_SE(index_task_to_consider) = abs(nanmean(vel_SE) / nanmax(abs(vel_SE)));
                            
                            if DebugMode
                                figure
                                plot(abs(vel_SE))
                                hold on
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle)
                                hline(threshold_velocity,'R');
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SE(index_task_to_consider),Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SE(index_task_to_consider)),'*r');
                            end
                        end
                        
                        %% Compute Smoothness & Index Fine - SR
                        
                        if Exercises_Temp{index_exe}.rep{index_rep}.ROM_SR(index_task_to_consider) > threshold_angle
                            
                            %vel_SR=diff(S1exercise_Temp_2{n}.Task{t}.rep{r}.SRAngle)./diff(S1exercise_Temp_2{n}.Task{t}.rep{r}.time_ang);
                            vel_SR=diff(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle)./40;
                            vel_SR=vel_SR.*1000; %degrees/s
                            
                            ii_mov = find(abs(vel_SR) > threshold_velocity);
                            a=diff(ii_mov');
                            b=find([a inf]>1);
                            c=diff([0 b]); %length of the sequences
                            c=c(1:find(c>threshold_velocity_samples,1,'last'));
                            d=sum(c);      %endpoints of the sequences
                            if d ~= 0
                                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SR(index_task_to_consider)=ii_mov(d);
                            else
                                Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SR(index_task_to_consider)=max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle));
                            end
                            clear a b c d ii_mov
                            
                            vel_SR = vel_SR(1:Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SR(index_task_to_consider)-1);
                            Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_SR(index_task_to_consider) = abs(nanmean(vel_SR) / nanmax(abs(vel_SR)));
                            
                            if DebugMode
                                figure
                                plot(abs(vel_SR))
                                hold on
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle)
                                hline(threshold_velocity,'R');
                                plot(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SR(index_task_to_consider),Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SR(index_task_to_consider)),'*r');
                            end
                        end
                        
                        Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider) = max([Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_elbow(index_task_to_consider), ...
                            Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SE(index_task_to_consider), ...
                            Exercises_Temp{index_exe}.rep{index_rep}.Index_fine_SR(index_task_to_consider)]);
                        
                        
                        %% Compute MT
                        
                        if(isnan(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)))
                            Exercises_Temp{index_exe}.rep{index_rep}.MT(index_task_to_consider) = NaN;
                        else
                            Exercises_Temp{index_exe}.rep{index_rep}.MT(index_task_to_consider) = (Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)) - ...
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))/1000; %seconds
                        end
                        
                        Exercises_Temp{index_exe}.rep{index_rep}.MT2(index_task_to_consider) = (Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(end) - ...
                            Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))/1000;
                        
                    end % end if valids
                end % end for tasks
                
                if isnan(Exercises_Temp{index_exe}.rep{index_rep}.MT) == zeros(1,NR_task_to_consider)
                    Exercises_Temp{index_exe}.MT(index_rep) = sum(Exercises_Temp{index_exe}.rep{index_rep}.MT);
                    Exercises_Temp{index_exe}.NR_rep_complete = Exercises_Temp{index_exe}.NR_rep_complete+1;
                end
                
                if isnan(Exercises_Temp{index_exe}.rep{index_rep}.MT2) == zeros(1,NR_task_to_consider)
                    Exercises_Temp{index_exe}.MT2(index_rep) = sum(Exercises_Temp{index_exe}.rep{index_rep}.MT2);
                end
                
                Exercises_Temp{index_exe}.Smoothness_elbow(index_rep) = nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_elbow(index_task_to_consider));
                Exercises_Temp{index_exe}.Smoothness_SE(index_rep)    = nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_SE(index_task_to_consider));
                Exercises_Temp{index_exe}.Smoothness_SR(index_rep)    = nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Smoothness_SR(index_task_to_consider));
                
                if Exercises_Temp{index_exe}.Parameters.Name == 'get_S1_E6_Name'
                    Exercises_Temp{index_exe}.Smoothness(index_rep) = Exercises_Temp{index_exe}.Smoothness_SE(index_rep);
                else
                    Exercises_Temp{index_exe}.Smoothness(index_rep) = nanmean([  Exercises_Temp{index_exe}.Smoothness_elbow(index_rep)     Exercises_Temp{index_exe}.Smoothness_SE(index_rep)     Exercises_Temp{index_exe}.Smoothness_SR(index_rep)]);
                end
                
            end %end for reps
            
            Exercises_Temp{index_exe}.Completed = Exercises_Temp{index_exe}.NR_rep_complete/Exercises_Temp{index_exe}.total_NR_rep;
            
            %% Create figures for each task of interest
            
            title_fig = sprintf('Session %d - Exercise %d',index_session,index_exe);
            figure('Name',title_fig);
            
            
            % Running for each task of interest
            for index_task_to_consider = 1:NR_task_to_consider
                index_task = Task_to_consider(index_task_to_consider);
                fprintf('Task %d/%d\n',index_task_to_consider,NR_task_to_consider);
                
                if NR_task_to_consider == 2
                    switch index_task_to_consider
                        case 1
                            subplot(121)
                            title_OK=strcat(title_exe,'- Up');
                        case 2
                            subplot(122)
                            title_OK=strcat(title_exe,'- Down');
                    end
                end
                
                if NR_task_to_consider==6
                    switch index_task_to_consider
                        case 1
                            subplot(321)
                            title_OK=strcat(title_exe,'- Center');
                            
                        case 2
                            subplot(322)
                            title_OK=strcat(title_exe,'- Rest');
                            
                        case 3
                            subplot(323)
                            title_OK=strcat(title_exe,'- Internal');
                            
                        case 4
                            subplot(324)
                            title_OK=strcat(title_exe,'- Rest');
                            
                        case 5
                            subplot(325)
                            title_OK=strcat(title_exe,'- External');
                            
                        case 6
                            subplot(326)
                            title_OK=strcat(title_exe,'- Rest');
                            
                    end
                end
                
                if NR_task_to_consider== 9
                    switch index_task_to_consider
                        case 1
                            subplot(331)
                            title_OK=strcat(title_exe,'- Rest to Center');
                            
                        case 2
                            subplot(332)
                            title_OK=strcat(title_exe,'- Center to Internal');
                            
                        case 3
                            subplot(333)
                            title_OK=strcat(title_exe,'- Internal to Rest');
                            
                        case 4
                            subplot(334)
                            title_OK=strcat(title_exe,'- Rest to Internal');
                            
                        case 5
                            subplot(335)
                            title_OK=strcat(title_exe,'- Internal to External');
                            
                        case 6
                            subplot(336)
                            title_OK=strcat(title_exe,'- External to Rest');
                            
                        case 7
                            subplot(337)
                            title_OK=strcat(title_exe,'- Rest to External');
                            
                        case 8
                            subplot(338)
                            title_OK=strcat(title_exe,'- External to Center');
                            
                        case 9
                            subplot(339)
                            title_OK=strcat(title_exe,'- Center to Rest');
                    end
                end
                
                for index_rep = 1:NR_rep
                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid == 1
                        
                        % Plot angles
                        hold on
                        plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle,'b')
                        plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle,'r')
                        plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle,'k')
                        
                        %Moving average of the angles
                        Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle=smooth(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle,5);
                        Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle=smooth(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle,5);
                        Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle=smooth(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle,5);
                        
                        % Plot smoothed angles
                        plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle,'--b')
                        plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle,'--r')
                        plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle,'--k')
                        
                        if(isnan(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider))==0)
                            plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)) - ...
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000, ...
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.elbowAngle(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)),'*b')
                            plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)) - ...
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000, ...
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SEAngle(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)),'*r')
                            plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)) - ...
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.time_ang(1))./1000, ...
                                Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.SRAngle(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)),'*k')
                        end
                    end
                end % end for reps
                
                xlabel('time [s]')
                ylabel ('angle [�]')
                title(title_OK,'FontSize',14,'Fontweight','b')
                
                
            end % end for tasks
            
            
            %% INVOLVEMENT & TRIGGER STIMULATION
            
            Exercises_Temp{index_exe}.EMGtriggered                              = NaN(NR_rep,2*NR_task_to_consider);
            
            Exercises_Temp{index_exe}.Involvement                               = NaN(NR_rep,2*NR_task_to_consider);
            Exercises_Temp{index_exe}.NewInvolvement                            = NaN(NR_rep,2*NR_task_to_consider);
            Exercises_Temp{index_exe}.Muscles                                   = '';
            Exercises_Temp{index_exe}.TH1                                       = NaN;
            Exercises_Temp{index_exe}.TH2                                       = NaN;
            
            Exercises_Temp{index_exe}.total_enabled_tasks                       = 0;
            Exercises_Temp{index_exe}.stimulated_enabled_tasks                  = 0;
            Exercises_Temp{index_exe}.notstimulated_enabled_tasks               = 0;
            Exercises_Temp{index_exe}.highthreshold_100_enabled_tasks           = 0;
            Exercises_Temp{index_exe}.highthreshold_50_enabled_tasks            = 0;
            Exercises_Temp{index_exe}.highthreshold_enabled_tasks               = [ NaN NaN ]; % One for each muscle
            
            Exercises_Temp{index_exe}.zerothreshold_enabled_tasks               = 0;
            Exercises_Temp{index_exe}.used_enabled_tasks                        = 0;
            Exercises_Temp{index_exe}.Inv_enabled_tasks                         = 0;
            Exercises_Temp{index_exe}.NewInv_enabled_tasks                      = 0;
            Exercises_Temp{index_exe}.tasktime_1_enabled_tasks                  = 0;
            
            
            Threshold_EMG = [ NaN NaN ] ; %TODO
            Threshold_INV = [ NaN NaN ] ; %TODO
            
            for index_rep = 1:NR_rep
                
                Exercises_Temp{index_exe}.rep{index_rep}.EMG1triggered          = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.EMG2triggered          = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Involvement1           = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.Involvement2           = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement1           = NaN(1,NR_task_to_consider);
                Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement2           = NaN(1,NR_task_to_consider);
                
                
                for index_task_to_consider = 1:NR_task_to_consider
                    index_task = Task_to_consider(index_task_to_consider);
                    
                    % Save Enabled Muscles
                    if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'Enable1')
                        if(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.Enable1 == 1)
                            
                            if not(ismember(Exercises_Temp{index_exe}.Parameters.StimMuscle(1),Exercises_Temp{index_exe}.Muscles))
                                Exercises_Temp{index_exe}.Muscles = [Exercises_Temp{index_exe}.Muscles Exercises_Temp{index_exe}.Parameters.StimMuscle(1)];
                            else
                                Exercises_Temp{index_exe}.Muscles = [Exercises_Temp{index_exe}.Muscles ''];
                            end
                        end
                    end
                    if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'Enable2')
                        if(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.Enable2 == 1)
                            
                            if not(ismember(Exercises_Temp{index_exe}.Parameters.StimMuscle(2),Exercises_Temp{index_exe}.Muscles))
                                Exercises_Temp{index_exe}.Muscles = [Exercises_Temp{index_exe}.Muscles Exercises_Temp{index_exe}.Parameters.StimMuscle(2)];
                            else
                                Exercises_Temp{index_exe}.Muscles = [Exercises_Temp{index_exe}.Muscles ''];
                            end
                        end
                    end
                    
                    
                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.valid == 1 && Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min > 1  % If the section is valid and #samples is not too low
                        
                        timeEMG_plot  = (Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG(1))./1000;   % Time normalization vectors
                        timeI_plot    = (Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeI - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeI(1))./1000;
                        
                        
                        %% EMG 1
                        
                        if (isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'EMG1') && isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'I1') && not(isempty(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1a)))
                            
                            %Define EMG 1 Threshold according to enable
                            if(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.Enable1 == 1)
                                Exercises_Temp{index_exe}.total_enabled_tasks=Exercises_Temp{index_exe}.total_enabled_tasks+1;
                                
                                % Definition of the Thresholds for EMG trigger
                                if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'Enable2')
                                    if(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.Enable2 == 0)
                                        % Single Muscle Trigger
                                        if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1a ~= Threshold_EMG(1) %&& Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1a ~=0
                                            Threshold_EMG(1) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1a
                                        end
                                    else
                                        % Cross Muscle Trigger
                                        if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1b ~= Threshold_EMG(1) %&& Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1b ~=0
                                            Threshold_EMG(1) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1b
                                        end
                                    end
                                else
                                    % If only one muscle is defined
                                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1a ~= Threshold_EMG(1) %&& Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1a ~=0
                                        Threshold_EMG(1) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1a
                                    end
                                    
                                end
                                
                                % Definition of Threshold for Involvement
                                if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1c ~= Threshold_INV(1)% && Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1c ~=0
                                    Threshold_INV(1) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1c
                                end
                                
                                %%
                                
                                I_EMG = [];
                                I_I   = find(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I1==0,1,'last');
                                
                                % if EMG is somehow triggered
                                if I_I < max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1))
                                    Exercises_Temp{index_exe}.stimulated_enabled_tasks=Exercises_Temp{index_exe}.stimulated_enabled_tasks+1;
                                end
                                
                                if I_I < max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1)) % if EMG is somehow triggered
                                    %% Trigger Stimulation
                                    NewThreshold_INV(1) = nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1(1:I_I))*1.2;
                                    
                                    Exercises_Temp{index_exe}.used_enabled_tasks         = Exercises_Temp{index_exe}.used_enabled_tasks+1;
                                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.tasktime == 1
                                        Exercises_Temp{index_exe}.tasktime_1_enabled_tasks   = Exercises_Temp{index_exe}.tasktime_1_enabled_tasks+1;
                                    end
                                    
                                    
                                    I_EMG=find(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1(1:min([I_I,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min]))>Threshold_EMG(1))';
                                    if (timeI_plot(I_I) > Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.tasktime && CheckMaxConsecutive(I_EMG) < 3)
                                        Exercises_Temp{index_exe}.rep{index_rep}.EMG1triggered(index_task_to_consider) = 0;
                                        if DebugModeInv
                                            disp('Timeout Triggered');
                                        end
                                    else
                                        
                                        Exercises_Temp{index_exe}.rep{index_rep}.EMG1triggered(index_task_to_consider) = 1;
                                        if DebugModeInv
                                            disp('EMG Triggered')
                                        end
                                    end
                                    
                                    
                                    %% Involvement
                                    
                                    if not(isnan(nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1(I_I:min([Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider) Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min])))))
                                        
                                        if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1c < 50
                                            Exercises_Temp{index_exe}.Inv_enabled_tasks = Exercises_Temp{index_exe}.Inv_enabled_tasks+1;
                                            if nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1(I_I:min([Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider) Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min]))) > Threshold_INV(1)
                                                Exercises_Temp{index_exe}.rep{index_rep}.Involvement1(index_task_to_consider) = 1;
                                            else
                                                Exercises_Temp{index_exe}.rep{index_rep}.Involvement1(index_task_to_consider) = 0;
                                            end
                                        end
                                        
                                        Exercises_Temp{index_exe}.NewInv_enabled_tasks = Exercises_Temp{index_exe}.NewInv_enabled_tasks+1;
                                        if nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1(I_I:min([Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider) Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min]))) > NewThreshold_INV(1)
                                            Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement1(index_task_to_consider) = 1;
                                            if DebugModeInv
                                                disp('Involvement');
                                            end
                                        else
                                            Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement1(index_task_to_consider) = 0;
                                            if DebugModeInv
                                                disp('Not Involvement')
                                            end
                                        end
                                    else
                                        if DebugModeInv
                                            disp('Not Triggered')
                                        end
                                    end
                                    
                                    
                                end
                                %%
                                
                                if DebugModeInv
                                    title_fig = sprintf('EMG & Current - Exe %d - Session %d - Task %d - Rep %d - EMG 1',index_exe,index_session,index_task,index_rep);
                                    figure('Name',title_fig);
                                    plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1);
                                    hold on
                                    plot(timeI_plot,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I1);
                                    %plot(timeEMG_plot(I_EMG),Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG1(I_EMG),'o');
                                    hline(Threshold_EMG(1),'R');
                                    hline(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_1c,'B');
                                    if not(isnan(I_I))
                                        vline(timeI_plot(I_I),'K')
                                        vline(timeI_plot(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)),'K');
                                    end
                                end
                                
                                % Thresholds
                                if Threshold_EMG(1) > 100
                                    Exercises_Temp{index_exe}.highthreshold_100_enabled_tasks = Exercises_Temp{index_exe}.highthreshold_100_enabled_tasks+1;
                                end
                                if Threshold_EMG(1) > 50
                                    Exercises_Temp{index_exe}.highthreshold_50_enabled_tasks = Exercises_Temp{index_exe}.highthreshold_50_enabled_tasks+1;
                                    Exercises_Temp{index_exe}.highthreshold_enabled_tasks(1) = 1;
                                end
                                if Threshold_EMG(1) == 0
                                    Exercises_Temp{index_exe}.zerothreshold_enabled_tasks = Exercises_Temp{index_exe}.zerothreshold_enabled_tasks+1;
                                end
                                
                            end % end if enables
                            
                        end % end if Muscle 1 is used
                        %% EMG 2
                        
                        if (isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'EMG2') && isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'I2') && not(isempty(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2a)))
                            
                            %Define EMG 2 Threshold according to enable
                            if(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.Enable2 == 1)
                                Exercises_Temp{index_exe}.total_enabled_tasks=Exercises_Temp{index_exe}.total_enabled_tasks+1;
                                
                                % Definition of the Thresholds for EMG trigger
                                if isfield(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task},'Enable2')
                                    if(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.Enable1 == 0)
                                        % Single Muscle Trigger
                                        if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2a ~= Threshold_EMG(2) %&& Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2a ~=0
                                            Threshold_EMG(2) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2a
                                        end
                                    else
                                        % Cross Muscle Trigger
                                        if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2b ~= Threshold_EMG(2) %&& Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2b ~=0
                                            Threshold_EMG(2) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2b
                                        end
                                    end
                                else
                                    % If only one muscle is defined
                                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2a ~= Threshold_EMG(2) %&& Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2a ~=0
                                        Threshold_EMG(2) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2a
                                    end
                                end
                                
                                % Definition of Threshold for Involvement
                                if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2c ~= Threshold_INV(2) %&& Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2c ~=0
                                    Threshold_INV(2) = Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2c
                                end
                                
                                
                                
                                I_EMG = [];
                                I_I=find(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I2==0,1,'last');
                                
                                
                                
                                % if EMG is somehow triggered
                                if I_I < max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2))
                                    Exercises_Temp{index_exe}.stimulated_enabled_tasks=Exercises_Temp{index_exe}.stimulated_enabled_tasks+1;
                                else
                                    Exercises_Temp{index_exe}.notstimulated_enabled_tasks=Exercises_Temp{index_exe}.notstimulated_enabled_tasks+1;
                                end
                                
                                
                                
                                
                                if I_I < max(size(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2)) % if EMG is somehow triggered
                                    %% Trigger Stimulation
                                    NewThreshold_INV(2) = nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2(1:I_I))*1.2;
                                    
                                    I_EMG=find(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2(1:min([I_I,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min]))>Threshold_EMG(2))';
                                    
                                    if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.tasktime == 1
                                        Exercises_Temp{index_exe}.tasktime_1_enabled_tasks   = Exercises_Temp{index_exe}.tasktime_1_enabled_tasks+1;
                                    end
                                    
                                    if (timeI_plot(I_I) > Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.tasktime && CheckMaxConsecutive(I_EMG) < 3)
                                        Exercises_Temp{index_exe}.rep{index_rep}.EMG2triggered(index_task_to_consider) = 0;
                                        if DebugModeInv
                                            disp('Timeout Triggered');
                                        end
                                    else
                                        
                                        Exercises_Temp{index_exe}.rep{index_rep}.EMG2triggered(index_task_to_consider) = 1;
                                        if DebugModeInv
                                            disp('EMG Triggered')
                                        end
                                    end
                                    
                                    %% Involvement
                                    if not(isnan(nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2(I_I:min([Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider) Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min])))))
                                        
                                        if Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2c < 50
                                            Exercises_Temp{index_exe}.Inv_enabled_tasks         = Exercises_Temp{index_exe}.Inv_enabled_tasks+1;
                                            if nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2(I_I:min([Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider) Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min]))) > Threshold_INV(2)
                                                Exercises_Temp{index_exe}.rep{index_rep}.Involvement2(index_task_to_consider) = 1;
                                            else
                                                Exercises_Temp{index_exe}.rep{index_rep}.Involvement2(index_task_to_consider) = 0;
                                            end
                                        end
                                        
                                        Exercises_Temp{index_exe}.NewInv_enabled_tasks         = Exercises_Temp{index_exe}.NewInv_enabled_tasks+1;
                                        if nanmean(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2(I_I:min([Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider) Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.NR_samples_min]))) > NewThreshold_INV(2)
                                            Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement2(index_task_to_consider) = 1;
                                            if DebugModeInv
                                                disp('Involvement');
                                            end
                                        else
                                            Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement2(index_task_to_consider) = 0;
                                            if DebugModeInv
                                                disp('Not Involvement')
                                            end
                                        end
                                        
                                    else
                                        if DebugModeInv
                                            disp('Not Triggered')
                                        end
                                    end
                                end
                                
                                if DebugModeInv
                                    title_fig = sprintf('EMG & Current - Exe %d - Session %d - Task %d - Rep %d - EMG 2',index_exe,index_session,index_task,index_rep);
                                    figure('Name',title_fig);
                                    plot((Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG - Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.timeEMG(1))./1000,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2);
                                    hold on
                                    plot(timeI_plot,Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.I2);
                                    %plot(timeEMG_plot(I_EMG),Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG2(I_EMG),'o');
                                    hline(NewThreshold_INV(2));
                                    hline(Threshold_EMG(2),'R');
                                    hline(Exercises_Temp{index_exe}.rep{index_rep}.Task{index_task}.EMG_2c,'B');
                                    if not(isnan(I_I))
                                        vline(timeI_plot(I_I),'K')
                                        vline(timeI_plot(Exercises_Temp{index_exe}.rep{index_rep}.Index_fine(index_task_to_consider)),'K');
                                    end
                                end
                                
                                
                                if Threshold_EMG(2) > 100
                                    Exercises_Temp{index_exe}.highthreshold_100_enabled_tasks = Exercises_Temp{index_exe}.highthreshold_100_enabled_tasks+1;
                                end
                                if Threshold_EMG(2) > 50
                                    Exercises_Temp{index_exe}.highthreshold_50_enabled_tasks = Exercises_Temp{index_exe}.highthreshold_50_enabled_tasks+1;
                                    Exercises_Temp{index_exe}.highthreshold_enabled_tasks(2) = 1;
                                end
                                if Threshold_EMG(2) == 0
                                    Exercises_Temp{index_exe}.zerothreshold_enabled_tasks = Exercises_Temp{index_exe}.zerothreshold_enabled_tasks+1;
                                end
                                
                            end % end if enables
                        end % end if Muscle 2 is used
                        
                        
                        
                        
                    end % end if valids
                    
                end %end for tasks
                
                Exercises_Temp{index_exe}.EMGtriggered(index_rep,:) = [Exercises_Temp{index_exe}.rep{index_rep}.EMG1triggered Exercises_Temp{index_exe}.rep{index_rep}.EMG2triggered];
                Exercises_Temp{index_exe}.Involvement(index_rep,:) = [Exercises_Temp{index_exe}.rep{index_rep}.Involvement1 Exercises_Temp{index_exe}.rep{index_rep}.Involvement2];
                Exercises_Temp{index_exe}.NewInvolvement(index_rep,:) = [Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement1 Exercises_Temp{index_exe}.rep{index_rep}.NewInvolvement2];
                
            end %end for rep
            
            Exercises_Temp{index_exe}.Stimulated = Exercises_Temp{index_exe}.stimulated_enabled_tasks/Exercises_Temp{index_exe}.total_enabled_tasks;
            
            
            
            Exercises_Temp{index_exe}.TH1 = Threshold_EMG(1);
            Exercises_Temp{index_exe}.TH2 = Threshold_EMG(2);
            
            
        end % end for exercises
        
        
        
        Sessions_Outcomes{index_session}.Exercises = Exercises_Temp;
        Sessions_Outcomes{index_session}.Date = Sessions{index_session}.Date;
        
    else
        disp('Empty Session');
    end
    
end % end for sessions

cd(PathName)

filename=strcat(FileName(1:end-4),'_Outcomes.mat');
save(filename, 'Sessions_Outcomes')

cd(currentPath)