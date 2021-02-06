%% Stream Parser

% This code parses the data stream and creates a valid MATLAB struct that 
% contains all the kinematics/emg data for all the sessions of each patient.
% The struct organizes the sessions in type of exercises, repetitions 
% and sub-tasks.
%
% Inputs:
% txt-files: files containing the data stream for one patient, all the
% sessions. Each file contains a session.
%
% Outputs:
% MAT-file: file containing the data structure for one patient, all the
% sessions.
%
% Example:
% Input: Combined_SessionData_XXX.txt
% Output: VB-S1-R-0**_allSessions.mat

%% Clean
clear all
close all
clc

%% Dependencies
%Adding functions path
currentPath=pwd;
path = [currentPath '/functions'];
addpath(path);

%% Initialization
delimiter=' ';
parse_S1=1;
parse_RFID=1;

%% Select files to be parsed
% S1/RETRAINER/PATIENT-XX-YY/CombinedSession-ZZ
cd('../S1/RETRAINER')
% Select files
[FileName,PathName,FilterIndex] = uigetfile('*.txt','MultiSelect','ON');

% Get number of sessions to be parsed
NR_sessions=max(size(FileName)); 

%% Parse each session
for index_session=1:NR_sessions
    
    
    %% Setup script to get number of lines
    % Enter path
    cd(PathName);
    % Open file
    fid = fopen(FileName{index_session});
    % Exit path
    cd(currentPath);
    
    % Read first line from file
    tline = fgets(fid);
    i=0;
    
    % Until end of file
    while ischar(tline) %file not ended
        i=i+1;
        % Get data index
        if (strcmp(tline(1:end-2),'=====AddingSessionData=====') || strcmp(tline(1:end-1),'=====AddingSessionData====='))
            k=i;
        end
        % Read new line from file
        tline = fgets(fid);
    end
    
    % Close file
    fclose(fid);
    
    N=k; % first part (data) 
    M=i-k; % second part (parameters) 
    
    % Allocate memory
    AllocateVectTOP; 
    
    %% Stream Parser
    % Enter path
    cd(PathName);
    % Open session file
    fid = fopen(FileName{index_session}); 
    % Read first line
    tline = fgets(fid);
    cd(currentPath);
    % Parse lines
    ParseVectTOP_v2; 
    % Close file
    fclose(fid);
    
    %% Create MATLAB struct
    
    CreaStructTOP_v3;
    % Exit path
    cd('..'); 
    PathToSave=pwd; 
    
    % Create folder if it doesn't exist
    fn=fullfile(PathToSave,'Results Parsed Data');
    if(not(exist(fn,'dir')))
        mkdir(PathToSave,'Results Parsed Data');
    end
    % Enter path
    cd(fn)
    
    % Fill the 'Sessions' struct with this session
    if(exist('S1exerciseOK'))
        Sessions{index_session}.S1exerciseOK=S1exerciseOK; 
        Sessions{index_session}.Date=FileName{index_session}(22:22+7);
    else
        disp('No Exercises for that session to be saved')
        Sessions{index_session}.S1exerciseOK=NaN;
        Sessions{index_session}.Date=FileName{index_session}(22:22+7);
    end
    
    % Exit path
    cd(currentPath)
    
    % Clear variables
    clearvars -except Sessions PathName fn currentPath delimiter parse_S1 parse_RFID FileName NR_sessions index_session
    
    
end

%%save the final structure
if(exist('Sessions'))
    cd(fn)
    filename=strcat(FileName{1}(31:end-4),'_allSessions_Test.mat');
    save(filename, 'Sessions')
else
    disp('No Session to be saved')
end

cd(currentPath)
