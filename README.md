# Retrainer Kinematics Data Analysis

---
# Run all script from this folder
---

## Step 1 - Stream Parser
The first step parses the data stream and creates a valid MATLAB struct that contains all the kinematics/emg data for all the sessions of each patient.
The struct organizes the sessions in type of exercises, repetitions and sub-tasks.
To run the stream parser 
- `Run_Step1_Parser` for each patient
- Select all the sessions (at the same time) to be analysed for each patient. Select multiple files in S1/RETRAINER/XXX-S1-R-YYY/Sessions/Combined_SessionData_ZZZ.txt
- Wait until the program stops.

- Inputs:
txt-files "Combined_SessionData_XXX.txt": files containing the data stream for one patient, all the
sessions. Each file contains a session.

- Outputs:
MAT-file "VB-S1-R-0**_allSessions.mat": in "Results Parsed Data", file containing the data structure for one patient, all the sessions.

## Step 2 - Compute Outcome Measures
The second step takes the parsed MATLAB struct of each patient and computes the outcome measures for each session, exercise and sub-task.
The program analyses the parsed struct data and appends the desired outcome measures. This code refines the data structure for the single patient and computes
the outcome measures that are added to the original data structure.

To compute the outcome measures
- `Run_Step2_ComputeOutcomeMeasures` (you can choose to open only one patient or more than one)

- Inputs:
MAT-file "VB-S1-R-0**_allSessions.mat": file containing the data structure for one patient, all the
sessions.

- Outputs:
MAT-file "VB-S1-R-0**_allSessions_Outcomes.mat": file containing the data structure for one patient, all the
sessions + the computed outcome measures that are added to the original
structure.

## Step 3 - Create Figures
The third step is used to create figures from the previously computed outcome measures. 
The user can specify in the script the number of subjects to be analyzed.

- Select number of patients
- Select exercise to analyse for each patient
- `Run_Step3_CreateFigures`

## Step 4 - Create Tables
The fourth step is used to create tables and figures from the previously computed outcome measures. 
The user has to select the exercises to be considered for each subject. The code then creates a table for each exercise.

- `Run_Step4_CreateTables`
