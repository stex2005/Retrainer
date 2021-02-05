%% CCC

ccc


%% Define exercises for each patient manually
%ANKF-015
 subjects{1}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
%ANKF-022
 subjects{2}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
%ANKF-030
  subjects{3}.exe_to_consider{1}.Name = 'get_S1_E7_Name';
%ANKF-034
 subjects{4}.exe_to_consider{1}.Name = 'get_S1_E7_Name';
%ANKF-046
  subjects{5}.exe_to_consider{1}.Name = 'get_S1_E7_Name';
%ANKF-063
  subjects{6}.exe_to_consider{1}.Name = 'get_S1_E7_Name';
%ANKF-065
   subjects{7}.exe_to_consider{1}.Name = 'get_S1_E7_Name';
 %ANKF-070
 subjects{8}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
 %ANKF-082
  subjects{9}.exe_to_consider{1}.Name = 'get_S1_E7_Name';
 %VB-004
 subjects{10}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
 %VB-005
 subjects{11}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
 subjects{11}.exe_to_consider{2}.Name = 'get_S1_E7_Name';
%VB-010
 subjects{12}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
 subjects{12}.exe_to_consider{2}.Name = 'get_S1_E6_Name';
 subjects{12}.exe_to_consider{3}.Name = 'get_S1_E7_Name';
 %VB-011
  subjects{13}.exe_to_consider{1}.Name = 'get_S1_E6_Name';
% % VB-020
 subjects{14}.exe_to_consider{1}.Name = 'get_S1_E6_Name';
 subjects{14}.exe_to_consider{2}.Name = 'get_S1_E7_Name';
% %VB-023
 subjects{15}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
% %VB-028
subjects{16}.exe_to_consider{1}.Name = 'get_S1_E6_Name';
subjects{16}.exe_to_consider{2}.Name = 'get_S1_E7_Name';
%VB-31
subjects{17}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
subjects{17}.exe_to_consider{2}.Name = 'get_S1_E7_Name';
%VB-036
subjects{18}.exe_to_consider{1}.Name = 'get_S1_E6_Name';
subjects{18}.exe_to_consider{2}.Name = 'get_S1_E7_Name';
%VB-038
subjects{19}.exe_to_consider{1}.Name = 'get_S1_E1_Name';
subjects{19}.exe_to_consider{2}.Name = 'get_S1_E6_Name';
subjects{19}.exe_to_consider{3}.Name = 'get_S1_E7_Name';
%VB-048
subjects{20}.exe_to_consider{1}.Name = 'get_S1_E6_Name';
%VB-060 
subjects{21}.exe_to_consider{1}.Name = 'get_S1_E6_Name';
subjects{21}.exe_to_consider{2}.Name = 'get_S1_E7_Name';
%VB-114
subjects{22}.exe_to_consider{1}.Name = 'get_S1_E6_Name';



%% Import Data

% cd(userpath)
% cd('DataAnalysis/mfile-git-Retrainer');
currentPath=pwd;
addpath(currentPath);
cd('../Results Outcome Data');
addpath(pwd);

 
 %% Allocate Excel Table
 
testname=inputdlg({'New Filename: '});
xlsname = strcat(testname{1});
xlsname = strcat(xlsname,'.xlsx');
xlsname = strcat(pwd,'\',xlsname);

s1e1Name = strcat(testname{1}, '_get_S1_E1_Name');
s1e1Name = strcat(s1e1Name,'.xlsx');
s1e1Name = strcat(pwd,'\',s1e1Name);

s1e6Name = strcat(testname{1}, '_get_S1_E6_Name');
s1e6Name = strcat(s1e6Name,'.xlsx');
s1e6Name = strcat(pwd,'\',s1e6Name);

s1e7Name = strcat(testname{1}, '_get_S1_E7_Name');
s1e7Name = strcat(s1e7Name,'.xlsx');
s1e7Name = strcat(pwd,'\',s1e7Name);

if exist(xlsname, 'file')
    delete(xlsname);
end

if exist(s1e1Name, 'file')
    delete(s1e1Name);
end

if exist(s1e6Name, 'file')
    delete(s1e6Name);
end

if exist(s1e7Name, 'file')
    delete(s1e7Name);
end
heading = { 'Patient','Exercise','# Sessions', ...
            'Movement Time T0','Movement Time T1','Movement Time p-value', ...
            'Smoothness T0','Smoothness T1','Smoothness p-value', ...
            'ROM Elbow T0','ROM Elbow T1','ROM Elbow p-value', ...
            'ROM SE T0','ROM SE T1','ROM SE p-value', ...
            'ROM SR T0','ROM SR T1','ROM SR p-value', ...
            'EMG-triggered tasks %', ...
            'Involved tasks %', ...
            'Involved tasks % recomputed', ...
            'Success rate %' };
[STATUS,MESSAGE] = xlswrite(xlsname,heading);
[STATUS,MESSAGE] = xlswrite(s1e1Name,heading);
[STATUS,MESSAGE] = xlswrite(s1e6Name,heading);
[STATUS,MESSAGE] = xlswrite(s1e7Name,heading);

%% For each subject

% [FileName,PathName]=uigetfile('*.mat');
[FileName,PathName,FilterIndex] = uigetfile('*.mat','MultiSelect','on');
NR_subjects=max(size(FileName));


% for each of the selected files
for index_subject = 1:NR_subjects
    
    % load the file 
    cd(PathName)
    load(FileName{index_subject})
	% set the name of the subject to be the file name
    subjects{index_subject}.Name = FileName{index_subject}(1:end-255);
   
   
	% get the number of sessions from the variable Sessions_Outcomes
    NR_sessions = max(size(Sessions_Outcomes));
	% get the exe to consider array (ex: get_S1_E6_Name)
    NR_exe_to_consider = max(size(subjects{index_subject}.exe_to_consider));
    
   
    % Allocate structure
       
	% for each of the sessions
    for index_session=1:NR_sessions
		% for each of the exes
        for index_exe_to_consider = 1:NR_exe_to_consider
			% initialize all the stats to NaN or empty
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean  = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.STD   = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.first = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.last  = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Array{index_session} = NaN;
                                                                                            
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Mean          = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.STD           = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.first         = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.last          = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Array{index_session} = NaN;
                               
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Mean           = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.STD            = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.first          = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.last           = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Array{index_session} = NaN ;
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Mean           = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.STD            = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.first          = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.last           = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Array{index_session} = NaN ;
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Mean                 = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.STD                  = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.first                = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.last                 = [];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Array{index_session} = NaN ;
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered.Mean           = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered.Array{index_session} = NaN ;
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement.Mean                 = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement.Array{index_session} = NaN ;
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.used_enabled_tasks = nan(1,NR_sessions);
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.inv_used_enabled_tasks = nan(1,NR_sessions);

                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success = nan(1,NR_sessions);
                
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Muscles = strings(2,NR_sessions);
                
                
        end  
    end
    
    
    
    %for each of the sessions
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
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean(index_session)= nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.STD(index_session)= nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Array{index_session}= Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.MT;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Mean(index_session)= nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.STD(index_session)= nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Array{index_session}= Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Smoothness;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Mean(index_session)= nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_elbow);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.STD(index_session)= nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_elbow);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Array{index_session}= Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_elbow;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Mean(index_session)= nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SE);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.STD(index_session)= nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SE);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Array{index_session}= Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SE;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Mean(index_session)= nanmean(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SR);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.STD(index_session)= nanstd(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SR);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Array{index_session}= Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.ROM_SR;
                        
                        size_reshape = size(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.EMGtriggered);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered.Mean(index_session) = nanmean(reshape(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.EMGtriggered,size_reshape(1)*size_reshape(2),1));
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered.Array{index_session}= reshape(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.EMGtriggered,size_reshape(1)*size_reshape(2),1);

                        size_reshape = size(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Involvement);
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement.Mean(index_session) = nanmean(reshape(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Involvement,size_reshape(1)*size_reshape(2),1));
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement.Array{index_session}= reshape(Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Involvement,size_reshape(1)*size_reshape(2),1);
                        
                       
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.used_enabled_tasks(index_session)                = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.used_enabled_tasks;
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.inv_used_enabled_tasks(index_session)            = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.inv_used_enabled_tasks;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success(index_session) = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.success*100;
                        
                        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Muscles(:,index_session) = Sessions_Outcomes{index_session}.Exercises{index_exe_OK(index_exe_to_consider)}.Muscles';                     
            end
        end % end for exe to consider
                 
        end % if not isempty 
    end % end for sessions

    
    
    
    
   
    for index_exe_to_consider = 1:NR_exe_to_consider
        
        switch subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Name
            case 'get_S1_E1_Name'
                title_exe='Ant Reach Plane';
                code_angles = [1 2 3];
                MT_yrange = [0 30];
            case 'get_S1_E2_Name'
                title_exe='Ant Reach Space';
            case 'get_S1_E3_Name'
                title_exe='Move Obj Plane';
            case 'get_S1_E4_Name'
                title_exe='Move Obj Plane in Space';
            case 'get_S1_E5_Name'
                title_exe='Move Obj Space';
                code_angles = [1 2 3];
                MT_yrange = [0 100];
            case 'get_S1_E6_Name'
                title_exe='Lateral Elevation';
                code_angles = 2;
                MT_yrange = [0 8];
            case 'get_S1_E7_Name'
                title_exe='Hand to Mouth';
                code_angles = [1 2];
                MT_yrange = [0 8];
            case 'get_S1_E8_Name'
                title_exe='Hand to Mouth Obj';
        end
        
        %% T-Test Statistics
        
        index_all = find(not(isnan(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean)));
        
        subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Muscles = subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Muscles(:,index_all);
       
        index_first = find(not(isnan(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean)),3,'first');
        if not(isempty(index_first))
            for i = 1:max(size(index_first))
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.first = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.first subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Array{index_first(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.first = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.first subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Array{index_first(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.first = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.first subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Array{index_first(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.first = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.first subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Array{index_first(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.first = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.first subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Array{index_first(i)}];
            end
        end
        index_last = find(not(isnan(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean)),3,'last');
        if not(isempty(index_first))
            
            for i = 1:max(size(index_first))
                 subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.last = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.last subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Array{index_last(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.last = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.last subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Array{index_last(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.last = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.last subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Array{index_last(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.last = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.last subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Array{index_last(i)}];
                subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.last = [subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.last subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Array{index_last(i)}];
            end
        end

        [~,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.p]         = ttest2(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.first,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.last);
        [~,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.p] = ttest2(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.first,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.last);
        [~,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.p]  = ttest2(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.first,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.last);
        [~,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.p]     = ttest2(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.first,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.last);
        [~,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.p]     = ttest2(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.first,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.last);
        
        %% Table
        
        %Movement Time
        MT_T0           = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.first),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.first),'%.1f'),')') ;
        MT_T1           = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.last),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.last),'%.1f'),')') ;
        if subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.p >= 0.001
            MT_p        = num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.p,'%.3f');
        else
            MT_p        = '< 0.001';
        end
        
        %Smoothness
        Smoothness_T0   = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.first),'%.2f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.first),'%.2f'),')') ;
        Smoothness_T1   = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.last),'%.2f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.last),'%.2f'),')') ;
        if subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.p >= 0.001
            Smoothness_p        = num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.p,'%.3f');
        else
            Smoothness_p        = '< 0.001';
        end
        
        %ROM elbow
        if not(isempty(find(code_angles==1, 1)))
            ROM_elbow_T0 = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.first),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.first),'%.1f'),')') ;
            ROM_elbow_T1 = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.last),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.last),'%.1f'),')') ;
            if subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.p >= 0.001
                ROM_elbow_p = num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.p,'%.3f');
            else
                ROM_elbow_p = '< 0.001';
            end
        else
            ROM_elbow_T0 = 'N.A.';
            ROM_elbow_T1 = 'N.A.';
            ROM_elbow_p = 'N.A.';
        end
        
        %ROM SE
        if not(isempty(find(code_angles==2, 1)))
            ROM_SE_T0 = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.first),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.first),'%.1f'),')') ;
            ROM_SE_T1 = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.last),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.last),'%.1f'),')') ;
            if subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.p >= 0.001
                ROM_SE_p = num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.p,'%.3f');
            else
                ROM_SE_p = '< 0.001';
            end
        else
            ROM_SE_T0 = 'N.A.';
            ROM_SE_T1 = 'N.A.';
            ROM_SE_p = 'N.A.';
        end
        
        %ROM SR
        if not(isempty(find(code_angles==3, 1)))
            ROM_SR_T0 = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.first),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.first),'%.1f'),')') ;
            ROM_SR_T1 = strcat(num2str(nanmean(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.last),'%.1f'),' (',num2str(nanstd(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.last),'%.1f'),')') ;
            if subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.p >= 0.001
                ROM_SR_p = num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.p,'%.3f');
            else
                ROM_SR_p = '< 0.001';
            end
        else
            ROM_SR_T0 = 'N.A.';
            ROM_SR_T1 = 'N.A.';
            ROM_SR_p = 'N.A.';
        end
        
        %EMG triggered
        index_EMG = find(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.used_enabled_tasks > 3);
        EMGtriggered = strcat(num2str(nanmedian(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered.Mean(index_EMG)*100),'%.1f'),' (',num2str(iqr(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.EMGtriggered.Mean(index_EMG)*100),'%.1f'),')');
        
        %Involvement
        index_INV = find(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.inv_used_enabled_tasks > 3);
        Involvement = strcat(num2str(nanmedian(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement.Mean(index_INV)*100),'%.1f'),' (',num2str(iqr(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Involvement.Mean(index_INV)*100),'%.1f'),')');
        
        %Success
        Success = strcat(num2str(nanmedian(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success),'%.1f'),' (',num2str(iqr(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Success),'%.1f'),')');

        % pass the name of the excel file, the name of the subject, the name of exe, the number of subjects we have done so far?
		% and other various calculated statistics, 
		% testname = 'filetosave'
		exerciseName = strcat(testname{1});
		exerciseName = strcat(exerciseName, subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Name); 
		exerciseName = strcat(exerciseName,'.xlsx');
		exerciseName = strcat(pwd,'\',exerciseName);
        
        heading = { 'Patient','Exercise','# Sessions', ...
            'Movement Time T0','Movement Time T1','Movement Time p-value', ...
            'Smoothness T0','Smoothness T1','Smoothness p-value', ...
            'ROM Elbow T0','ROM Elbow T1','ROM Elbow p-value', ...
            'ROM SE T0','ROM SE T1','ROM SE p-value', ...
            'ROM SR T0','ROM SR T1','ROM SR p-value', ...
            'EMG-triggered tasks %', ...
            'Involved tasks %', ...
            'Involved tasks % recomputed', ...
            'Success rate %' };
        [STATUS,MESSAGE] = xlswrite(exerciseName,heading);
        xlsappend(exerciseName,{ subjects{index_subject}.Name title_exe num2str(max(size(index_all))) ...
                            MT_T0 MT_T1 MT_p ...
                            Smoothness_T0 Smoothness_T1 Smoothness_p ...
                            ROM_elbow_T0 ROM_elbow_T1 ROM_elbow_p ...
                            ROM_SE_T0 ROM_SE_T1 ROM_SE_p ...
                            ROM_SR_T0 ROM_SR_T1 ROM_SR_p ...
                            EMGtriggered ...
                            Involvement ...
                            Success
                            });   
                        
       %% Plots
%{
%         title_fig = sprintf('%s - Exercise %d: %s',subjects{index_subject}.Name,index_exe_to_consider,title_exe);
%         set(gcf,'Name',title_fig); % 'Position', get(0, 'Screensize'),'Name',title_fig,
        
        
        % MT
%         subplot(1,3,1)
        figure
        plot(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean(index_all),'ok','MarkerFaceColor','k','MarkerSize',7)
        hold on
        errorbar(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.Mean(index_all),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT.STD(index_all),'Color','k')

        %             plot2 = plot(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.Mean,'-o','Color','G');
        %             errorbar(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.Mean,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.MT2.STD,'G')

        xlabel('Sessions [#]')
        ylabel('Exercise duration [s]')
        set(gca,'Fontsize',12,'FontWeight','b')
        xlim([-0.5 28.5])
        ylim(MT_yrange);
        title_fig = sprintf('%s - %s - MT',subjects{index_subject}.Name,title_exe);
        set(gcf,'Name',title_fig); % 'Position', get(0, 'Screensize'),'Name',title_fig,
        print(gcf, '-dtiffn', title_fig)
        savefig(title_fig)
        
        % Smoothness
        figure
%         subplot(1,3,2)
        plot(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Mean(index_all),'ok','MarkerFaceColor','k','MarkerSize',7)
        hold on
        errorbar(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.Mean(index_all),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Smoothness.STD(index_all),'Color','k')
        
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
        title_fig = sprintf('%s - %s - Smoothness',subjects{index_subject}.Name,title_exe);
        set(gcf,'Name',title_fig); % 'Position', get(0, 'Screensize'),'Name',title_fig,
        print(gcf, '-dtiffn', title_fig)
        savefig(title_fig)

        
        % ROM
        figure;
        hold on
        if not(isempty(find(code_angles==1, 1)))
            plot1 = plot(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Mean(index_all),'--ok','MarkerFaceColor','w','MarkerSize',7);
            errorbar(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.Mean(index_all),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_elbow.STD(index_all),'Color','k','LineStyle','none')
            
        end
        if not(isempty(find(code_angles==2, 1)))
            plot2 = plot(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Mean(index_all),'-dk','MarkerFaceColor','k','MarkerSize',7);
            errorbar(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.Mean(index_all),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SE.STD(index_all),'k')
            
        end
        if not(isempty(find(code_angles==3, 1)))
            plot3 = plot(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Mean(index_all),'-*k','MarkerFaceColor','k','MarkerSize',7);
            errorbar(index_all,subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.Mean(index_all),subjects{index_subject}.exe_to_consider{index_exe_to_consider}.ROM_SR.STD(index_all),'K')
            
        end
        
        if not(isempty(find(code_angles==1, 1))) && not(isempty(find(code_angles==2, 1))) && not(isempty(find(code_angles==3, 1)))
            leg = legend([plot1 plot2 plot3],'Elbow','Shoulder Elevation','Shoulder Rotation');
%         elseif not(isempty(find(code_angles==1, 1))) && not(isempty(find(code_angles==2, 1)))
%             leg = legend([plot1 plot2],'Elbow','Shoulder Elevation');
%         elseif not(isempty(find(code_angles==2, 1)))
%             leg = legend(plot2,'Shoulder Elevation');
        end
        
        xlabel('Sessions [#]')
        ylabel('ROM [�]')
        set(gca,'Fontsize',12,'FontWeight','b')
        ylim([-0.5 100.5]);
        xlim([-0.5 28.5]);
%         leg = legend([plot1 plot2 plot3],'Elbow','Shoulder Elevation','Shoulder Rotation');
        leg.FontSize = 12;
        leg.Location = 'northeast';
        leg.FontWeight = 'normal';
        title_fig = sprintf('%s - %s - ROMs',subjects{index_subject}.Name,title_exe);
        set(gcf,'Name',title_fig); % 'Position', get(0, 'Screensize'),'Name',title_fig,
        print(gcf, '-dtiffn', title_fig)
        savefig(title_fig)

   %}     
        
    end
end

filename='Outcomes.mat';
save(filename, 'subjects')

    
    
      
    
        
    %% Plots
  %{  
%     title_fig = sprintf('Patient %s: Movement Time',subjects{index_subject}.Name);
%     figure_MT = figure(1); 
%     set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
%     set(gcf,'Name',title_fig);
%     title_fig = sprintf('Patient %s: Smoothness',subjects{index_subject}.Name);
%     figure_Smoothness = figure(2); 
%     set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
%     title_fig = sprintf('Patient %s: ROM',subjects{index_subject}.Name);
%     figure_ROM = figure(3); set(gcf, 'Position', get(0, 'Screensize'),'Name',title_fig);
    
    for index_exe_to_consider = 1:NR_exe_to_consider
            
            
            
            
            
            
            
            
            
            
            %% Figure 1: MT,Success,Smoothness,ROM
            
            
            
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
%{
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
            ylabel('ROM [�]')
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
                str = {num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.inv_used_enabled_tasks(index_session)),...
                       num2str(subjects{index_subject}.exe_to_consider{index_exe_to_consider}.Newinv_used_enabled_tasks(index_session))};
                       
                text(xt,yt,str,'Fontsize',10,'FontWeight','n','HorizontalAlignment','center')
            end
            
            
            % Save Figure
            print(gcf, '-dtiffn', strcat(subjects{index_subject}.Name,' ',title_exe,' EMG'))
            %saveas(gcf,strcat(subjects{index_subject}.Name,' ',title_exe,' Involvement.jpg'))
            
           
            
            
        %}    
        end
   
end

    
 %}


