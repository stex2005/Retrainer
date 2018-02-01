
%% numlines known -> allocate vars
% for everything needed according to view
AbsoluteTime = NaN(N,1);
AbsoluteTimeMS = NaN(N,1);

% for S1
if parse_S1
    elbowBrake					   = NaN(N,1); 
    shoulderelevationBrake		   = NaN(N,1);
    shoulderrotationBrake		   = NaN(N,1);
    hipBrake					   = NaN(N,1);
    
    biceps_I					   = NaN(N,1);
    triceps_I					   = NaN(N,1);
    anteriorDeltoid_I              = NaN(N,1);
    posteriorDeltoid_I             = NaN(N,1);
    medialDeltoid_I                = NaN(N,1);
    
    biceps_PW				       = NaN(N,1);  
    triceps_PW					   = NaN(N,1);
    anteriorDeltoid_PW             = NaN(N,1);
    posteriorDeltoid_PW            = NaN(N,1);
    medialDeltoid_PW               = NaN(N,1);
    
    biceps_EMG					   = NaN(N,1);        
    triceps_EMG					   = NaN(N,1);
    anteriorDeltoid_EMG            = NaN(N,1);  
    posteriorDeltoid_EMG           = NaN(N,1);    
    medialDeltoid_EMG              = NaN(N,1);
    
    elbowAngle					   = NaN(N,1);
    shoulderelevationAngle		   = NaN(N,1);
    shoulderrotationAngle		   = NaN(N,1);
    
    NextTaskEvent_biceps           = NaN(N,1);
    NextTaskEvent_triceps          = NaN(N,1);
    NextTaskEvent_anteriorDeltoid  = NaN(N,1);
    NextTaskEvent_posteriorDeltoid = NaN(N,1);
    NextTaskEvent_medialDeltoid    = NaN(N,1);
    time                           = NaN(N,1);
    involvement                    = NaN(N,1);
    repetition                     = NaN(N,1);
    
    IndexStream_angle              = NaN(N,1);
    IndexStream_EMG                = NaN(N,1);
    IndexStream_cur                = NaN(N,1);

    startState{N}                  ='';
    trigger{N}                     ='';
    endState{N}                    ='';
    exercise{N}                    ='';
    
    %%%%%
    %%%%%
    %%%%% PARTE 2
    %%%%%
    %%%%%
    
    AbsoluteTime_par = NaN(M,1);
    AbsoluteTimeMS_par = NaN(M,1);
    
    relax_time = NaN(M,1);
    
    % ANTERIOR DELTOID: I_target, PW, EMGa, EMGb, EMGc
    
    AnteriorDeltoid_I_target        = NaN(M,1);
    AnteriorDeltoid_PW_target       = NaN(M,1);
    AnteriorDeltoid_EMGa            = NaN(M,1);
    AnteriorDeltoid_EMGb            = NaN(M,1);
    AnteriorDeltoid_EMGc            = NaN(M,1);
    
    % MEDIAL DELTOID: I_target, PW, EMGa, EMGb, EMGc
    
    MedialDeltoid_I_target          = NaN(M,1);
    MedialDeltoid_PW_target         = NaN(M,1);
    MedialDeltoid_EMGa              = NaN(M,1);
    MedialDeltoid_EMGb              = NaN(M,1);
    MedialDeltoid_EMGc              = NaN(M,1);
    
    % POSTERIOR DELTOID: I_target, PW, EMGa, EMGb, EMGc
    
    PosteriorDeltoid_I_target       = NaN(M,1);
    PosteriorDeltoid_PW_target      = NaN(M,1);
    PosteriorDeltoid_EMGa           = NaN(M,1);
    PosteriorDeltoid_EMGb           = NaN(M,1);
    PosteriorDeltoid_EMGc           = NaN(M,1);
    
    % BICEPS: I_target, PW, EMGa, EMGb, EMGc
    
    Biceps_I_target                 = NaN(M,1);
    Biceps_PW_target                = NaN(M,1);
    Biceps_EMGa                     = NaN(M,1);
    Biceps_EMGb                     = NaN(M,1);
    Biceps_EMGc                     = NaN(M,1);
    
    % TRICEPS: I_target, PW, EMGa, EMGb, EMGc
    
    Triceps_I_target                = NaN(M,1);
    Triceps_PW_target               = NaN(M,1);
    Triceps_EMGa                    = NaN(M,1);
    Triceps_EMGb                    = NaN(M,1);
    Triceps_EMGc                    = NaN(M,1);
    
    parameter{M}                    ='';  
    use{M}                          ='';
    
end


% for RFID
if parse_RFID
    tagfound					= NaN(1,N);
    tag							= NaN(1,N);
    rssi						= NaN(1,N);
    threshold					= NaN(1,N);
end
