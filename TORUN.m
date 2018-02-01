%% Parser

%% CCC

clear all
close all
clc

%% Import Data

cd(userpath)
cd('DataAnalysis/mfile');
currentPath=pwd;
addpath(currentPath);
cd('../SessionData');
addpath(pwd);

[FileName,PathName,FilterIndex] = uigetfile('*.txt','MultiSelect','on');
NR_sessions=max(size(FileName)); 

%% Initialization

delimiter=' ';
parse_S1=1;
parse_RFID=1;

%% Running for each Session

for index_session=1:NR_sessions
    
    
    %% one dry run just to get numlines
    cd(PathName);
    fid = fopen(FileName{index_session});
    cd(currentPath);
    
    tline = fgets(fid);
    i=0;
    
    while ischar(tline) %file not ended
        i=i+1;
        if (strcmp(tline(1:end-2),'=====AddingSessionData=====') || strcmp(tline(1:end-1),'=====AddingSessionData====='))
            k=i;
        end
        tline = fgets(fid);
    end
    
    fclose(fid);
    
    M=i-k; % second part (parameters) 
    N=k; % first part (data) 
    
    %allocate memory
    AllocateVectTOP; 
    
    
    %% parser
    
    cd(PathName);
    fid = fopen(FileName{index_session}); 
    tline = fgets(fid);
    cd(currentPath);

    ParseVectTOP_v2; 
    
    fclose(fid);
    
    %%
    CreaStructTOP_v3;
    
    fn=fullfile(PathName,'Results');
    if(not(exist(fn,'dir')))
        mkdir(PathName,'Results');
    end
    
    cd(fn)
    
    if(exist('S1exerciseOK'))
        Sessions{index_session}.S1exerciseOK=S1exerciseOK; 
        Sessions{index_session}.Date=FileName{index_session}(22:22+7);
    else
        disp('No Exercises for that session to be saved')
        Sessions{index_session}.S1exerciseOK=NaN;
        Sessions{index_session}.Date=FileName{index_session}(22:22+7);
    end
    
    cd(currentPath)
    
    
    clearvars -except Sessions PathName fn currentPath delimiter parse_S1 parse_RFID FileName NR_sessions index_session
    
    
end

%%save the final structure
if(exist('Sessions'))
    cd(fn)
    filename=strcat(FileName{1}(31:end-4),'_allSessions.mat');
    save(filename, 'Sessions')
else
    disp('No Session to be saved')
end

cd(currentPath)
