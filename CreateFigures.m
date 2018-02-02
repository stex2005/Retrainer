%% CCC

ccc

%% Initialization

NR_subjects = 1;

% Define exercises for each patient manually
subjects{1}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
subjects{1}.exe_to_consider{2}.Name = 'get_S1_E6_Name';
subjects{1}.exe_to_consider{3}.Name = 'get_S1_E7_Name';
% 
% subjects{2}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
% subjects{2}.exe_to_consider{2}.Name = 'get_S1_E6_Name';
% subjects{2}.exe_to_consider{3}.Name = 'get_S1_E7_Name';


%% Import Data

cd(userpath)
cd('DataAnalysis/mfile-git-Retrainer');
currentPath=pwd;
addpath(currentPath);
cd('../SessionData');
addpath(pwd);

 
 %% Create Figures and Graphs

for index_subject = 1:NR_subjects
    
    [FileName,PathName]=uigetfile('*.mat');
    cd(PathName)
    load(FileName)
    subjects{index_subject}.Name = FileName(1:end-25);
    
    
    
    NR_sessions = max(size(Sessions_Outcomes));
    NR_exe_to_consider = max(size(subjects{index_subject}.exe_to_consider));
    
   
    % Allocate structure
    
    for index_session=1:NR_sessions
        for index_exe_to_consider = 1:NR_exe_to_consider
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.STD = nan(1,NR_sessions);
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.STD = nan(1,NR_sessions);
                               
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Anova_Outcome = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Anova_Session = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.p = NaN;
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success = nan(1,NR_sessions);
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.total_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.stimulated_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_100_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_50_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.zerothreshold_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.used_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.tasktime_1_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Inv_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.NewInv_enabled_tasks = nan(1,NR_sessions);


                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.TH1 = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.TH2 = nan(1,NR_sessions);
                
                
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_STD = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_STD = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_STD = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_STD = nan(1,NR_sessions);
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow_STD = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE_STD = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR_STD = nan(1,NR_sessions);
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered_Mean = nan(1,NR_sessions);
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement_Mean = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.NewInvolvement_Mean = nan(1,NR_sessions);
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Muscles = strings(2,NR_sessions);
                
                
        end  
    end
    
    
    for index_session=1:NR_sessions
        
        if not(isempty(Sessions_Outcomes{index_session}))
        index_exe_OK = NaN(1,NR_exe_to_consider);
        
        NR_exe = max(size(Sessions_Outcomes{index_session}.Exercises));
        
        
        % First run to isolate and sort exercises to be considered
        
        for index_exe = 1:NR_exe 
            for index_exe_to_consider = 1:NR_exe_to_consider
                if Sessions_Outcomes{index_session}.Exercises{index_exe}.Parameters.Name == subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Name
                    index_exe_OK(index_exe_to_consider) = index_exe;
                end
            end
        end
        
                       
        % Create Mat Structure with outcome measures
                
        for index_exe_to_consider = 1:NR_exe_to_consider
            if not(isnan(index_exe_OK(index_exe_to_consider)))
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT2);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT2);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Anova_Outcome       = [ subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Anova_Outcome Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT];
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Anova_Session       = [ subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Anova_Session index_session*ones(1,max(size(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT)))];                     
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success(index_session)   = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.success*100;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.total_enabled_tasks(index_session)               = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.total_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.stimulated_enabled_tasks(index_session)          = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.stimulated_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.zerothreshold_enabled_tasks(index_session)       = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.zerothreshold_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_100_enabled_tasks(index_session)   = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.highthreshold_100_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_50_enabled_tasks(index_session)    = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.highthreshold_50_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.used_enabled_tasks(index_session)                = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.used_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.tasktime_1_enabled_tasks(index_session)          = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.tasktime_1_enabled_tasks;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Inv_enabled_tasks(index_session)                 = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Inv_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.NewInv_enabled_tasks(index_session)              = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.NewInv_enabled_tasks;

                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_enabled_tasks(index_session)       = nansum(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.highthreshold_enabled_tasks);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.TH1(index_session)                               = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.TH1; 
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.TH2(index_session)                               = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.TH2; 
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_elbow);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_elbow);       
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_SE);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_SE);     
                                                
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_SR);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_SR);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_SR);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness_SR);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_elbow);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_elbow); 
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SE);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SE); 
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR_Mean(index_session) = nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SR);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR_STD(index_session)  = nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SR);
                        
                        size_reshape = size(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.EMGtriggered);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered_Mean(index_session) = nanmean(reshape(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.EMGtriggered,size_reshape(1)*size_reshape(2),1));
%                       
                        size_reshape = size(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Involvement);
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement_Mean(index_session) = nanmean(reshape(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Involvement,size_reshape(1)*size_reshape(2),1));
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.NewInvolvement_Mean(index_session) = nanmean(reshape(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.NewInvolvement,size_reshape(1)*size_reshape(2),1));
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Muscles(:,index_session) = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Muscles';                     
            end
        end % end for exe to consider
                 
        end % if not isempty 
    end % end for sessions

    %% Plots
    
    title_fig = sprintf('Patient %s: Movement Time',subjects{index_subject}.Name);
    figure_MT = figure(1); set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
    title_fig = sprintf('Patient %s: Smoothness',subjects{index_subject}.Name);
    figure_Smoothness = figure(2); set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
    title_fig = sprintf('Patient %s: ROM',subjects{index_subject}.Name);
    figure_ROM = figure(3); set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
    
    for index_exe_to_consider = 1:NR_exe_to_consider
            
            
            switch subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Name
                case 'get_S1_E1_Name'
                    title_exe='Ant Reach Plane';
                    code_angles = [ 1 3 ];
                    marker = '-*';
                 case 'get_S1_E2_Name'
                    title_exe='Ant Reach Space';
                case 'get_S1_E3_Name'
                    title_exe='Move Obj Plane';
                case 'get_S1_E4_Name' 
                    title_exe='Move Obj Plane in Space';
                case 'get_S1_E5_Name'
                    title_exe='Move Obj Space';
                case 'get_S1_E6_Name'
                    title_exe='Lateral Elevation';
                    code_angles = [2];
                    marker = '-o';
                case 'get_S1_E7_Name'
                    title_exe='Hand to Mouth';
                    code_angles = [1];
                    marker = '-d';
                case 'get_S1_E8_Name'
                    title_exe='Hand to Mouth Obj';
            end
            
            
            
            
            
            
            
            %% Figure 1: MT,Success,Smoothness,ROM
            
            
%             title_fig = sprintf('Exercise %d: %s',index_exe_to_consider,title_exe);
%             figure; set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig,'Name',title_fig);
            figure(1);
            % MT
%             subplot(2,2,1)
            hold on
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean,marker,'MarkerSize',9,'Color','B');
            hold on
            errorbar(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.STD,'B')
            
%             plot2 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.Mean,'-o','Color','G');
%             errorbar(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.STD,'G')
            
            xlabel('Sessions [#]')
            ylabel('Exercise duration [s]')
            set(gca,'Fontsize',12,'FontWeight','b')
            xlim([-0.5 30.5])
%             legend([plot1 plot2],'Computed with detection of end of motion','Computed on total exercise time')

            % Success
%             subplot(2,2,2)
%             
%             plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success,'o','Color','B')
%             hold on
%             errorbar(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success,zeros(1,NR_sessions),'B')
%             
%             xlabel('Sessions [#]')
%             ylabel('Success Rate [%]')
%             set(gca,'Fontsize',12,'FontWeight','b')
%             ylim([-5 105])
%             xlim([-0.5 28.5])
            
            % Smoothness
%             subplot(2,2,3)

            figure(2);
            hold on
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_Mean,marker,'MarkerSize',9,'Color','B');
            hold on
            errorbar(1:max(size(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_Mean)),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_STD,'B')
            
            %{
            plot2 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_Mean,'o','Color','B')
            hold on
            errorbar(1:max(size(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_Mean)),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_elbow_STD,'B')
            plot3 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_Mean,'o','Color','R')
            errorbar(1:max(size(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_Mean)),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SE_STD,'R')
            plot4 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_Mean,'o','Color','K')
            errorbar(1:max(size(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_Mean)),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness_SR_STD,'K')
            %}
            
            xlabel('Sessions [#]')
            ylabel('Smoothness [a.u]')
            set(gca,'Fontsize',12,'FontWeight','b')
            ylim([-0.05 1.05]);
            xlim([-0.5 28.5]);
            legend({'Averaged'},'Fontsize',8,'FontWeight','normal')
                
            
            % ROM
%             subplot(2,2,4)
            figure(3);
            hold on
            if not(isempty(find(code_angles==1)))
                plot1 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow_Mean,marker,'MarkerSize',10,'Color','B')
                errorbar(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow_Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow_STD,'B')
            end
            if not(isempty(find(code_angles==2)))
            plot2 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE_Mean,marker,'MarkerSize',10,'Color','R')
            errorbar(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE_Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE_STD,'R')
            end
            if not(isempty(find(code_angles==3)))
            plot3 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR_Mean,marker,'MarkerSize',10,'Color','K')
            errorbar(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR_Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR_STD,'K')
            end
            
            xlabel('Sessions [#]')
            ylabel('ROM [°]')
            set(gca,'Fontsize',12,'FontWeight','b')
            ylim([-0.5 100.5]);
            xlim([-0.5 28.5]);
%             leg = legend([plot1 plot2 plot3],'Elbow','Shoulder Elevation','Shoulder Rotation');
%             leg.FontSize = 8;
%             leg.Location = 'northeast';
%             leg.FontWeight = 'normal';
            
            
            % Save Figure
            print(gcf, '-dtiffn', strcat(subjects{index_subject}.Name,' ',title_exe,' Outcomes'))

%             saveas(gcf,strcat(subjects{index_subject}.Name,' ',title_exe,'.tiff'))
                  
            %% Figure 2: EMG triggered vs Timeout triggered, Involvement
            
            %{
            
            title_fig = sprintf('Exercise %d: %s',index_exe_to_consider,title_exe);
            figure; set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
            set(gca,'Fontsize',12,'FontWeight','b')
            
            subplot(2,1,1)
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.total_enabled_tasks,'-o','Color','K')
            hold on
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.stimulated_enabled_tasks,'-o','Color','B')
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_100_enabled_tasks,'-*','Color','R')
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_50_enabled_tasks,'-*','Color','K')
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.zerothreshold_enabled_tasks,'-*','Color','B')
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.used_enabled_tasks,'-o','Color','G')
            
            
            
            xlabel('Sessions [#]')
            ylabel('Metadata [# tasks]')
            legend({'Enabled','Stimul','100 Thresh','50 Thresh','# 0 Thresh','Used'},'Fontsize','Location','east','Fontsize',8,'FontWeight','normal');
            legend('Location','northeast');
            
            xlim([-0.5 30.5]);
            
            subplot(2,1,2)
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.TH1,'-o','Color','r')
            hold on
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.TH2,'-o','Color','b')
            hline(50,'k');
            hline(100,'k');
            xlabel('Sessions [#]')
            ylabel('Threshold EMG')
            set(gca,'Fontsize',12,'FontWeight','b')
            legend('EMG 1','EMG 2');
            legend('Location','northeast');
            xlim([-0.5 30.5]);
            ylim([-5 155])
            
            % Save Figure
            print(gcf, '-dtiffn', strcat(subjects{index_subject}.Name,' ',title_exe,' Metadata'))
            %saveas(gcf,strcat(subjects{index_subject}.Name,' ',title_exe,' Involvement.jpg'))
            
            %}
            
            %% Figure 3:
            

            title_fig = sprintf('Exercise %d: %s',index_exe_to_consider,title_exe);
            figure; set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
            
            % EMG triggered vs timeout triggered
            subplot(2,1,1)
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered_Mean*100,'-ok','MarkerFaceColor','G','MarkerSize',7)
            hold on
            
            xlabel('Sessions [#]')
            ylabel('EMG triggered [%]')
            set(gca,'Fontsize',12,'FontWeight','b')
            ylim([-5 160])
            xlim([-1.5 30.5]);
            
            find_1 = find(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_enabled_tasks == 1);
            plot(find_1,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered_Mean(find_1)*100,'ok','MarkerFaceColor','B','MarkerSize',7);
            
            find_2 = find(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.highthreshold_enabled_tasks == 2);
            plot(find_2,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered_Mean(find_2)*100,'ok','MarkerFaceColor','R','MarkerSize',7);
            
            legend({'No Th > 50','One Th > 50','Both Ths > 50'},'Location','east','Fontsize',8,'FontWeight','normal');          
            
            xt = [-1 -1 -1 ];
            yt = [150 130 110];
            str = {'# enabled','# stim','# tasktime=1'};
            text(xt,yt,str,'Fontsize',10,'FontWeight','b','HorizontalAlignment','left');
            
                        
            for index_session = 1:NR_sessions
                xt = [index_session index_session index_session];
                yt = [150 130 110];
                str = {num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.total_enabled_tasks(index_session)),...
                       num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.stimulated_enabled_tasks(index_session)),...
                       num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.tasktime_1_enabled_tasks(index_session))};
                text(xt,yt,str,'Fontsize',10,'FontWeight','n','HorizontalAlignment','center')
            end
            
            
            
            % Involvement
            subplot(2,1,2)
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement_Mean*100,'-ok','MarkerFaceColor','B','MarkerSize',7)
            hold on
            plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.NewInvolvement_Mean*100,'-ok','MarkerFaceColor','R','MarkerSize',7)
            xlabel('Sessions [#]')
            ylabel('Involvement [%]')
            set(gca,'Fontsize',12,'FontWeight','b')
            ylim([-5 140])
            xlim([-1.5 30.5]);
            legend({'Involvement Real','New Involvement'},'Location','east','Fontsize',8,'FontWeight','normal');

            xt = [-1 -1 ];
            yt = [130 110];
            str = {'# Inv','# NewInv'};
            text(xt,yt,str,'Fontsize',10,'FontWeight','b','HorizontalAlignment','left');
            
                        
            for index_session = 1:NR_sessions
                xt = [index_session index_session];
                yt = [130 110];
                str = {num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Inv_enabled_tasks(index_session)),...
                       num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.NewInv_enabled_tasks(index_session))};
                       
                text(xt,yt,str,'Fontsize',10,'FontWeight','n','HorizontalAlignment','center')
            end
            
            
            % Save Figure
            print(gcf, '-dtiffn', strcat(subjects{index_subject}.Name,' ',title_exe,' EMG'))
            %saveas(gcf,strcat(subjects{index_subject}.Name,' ',title_exe,' Involvement.jpg'))
            
            %}
            
            
            
    end
end

    



