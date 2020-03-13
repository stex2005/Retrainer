close all
clc
clear all

NR_sub=6;

currentPath=pwd;


 
 %%

figure(1)
figure(2)

for n=1:NR_sub
    
    for d=1:2
        
        [fname,pathname]=uigetfile('*.mat');
        
        cd(pathname);
        load(fname)
        
        switch n %subject
            case 1
                exe_to_consider=2;
            case 2
                exe_to_consider=1;
            case 3
                switch d % day
                    case 1
                        exe_to_consider=2;
                    case 2
                        exe_to_consider=1;
                end
            case 4
                switch d % day
                    case 1
                        exe_to_consider=1;
                    case 2
                        exe_to_consider=1;
                end
            case 5
                switch d % day
                    case 1
                        exe_to_consider=2;
                    case 2
                        exe_to_consider=1;
                end
                
            case 6
                switch d % day
                    case 1
                        exe_to_consider=1;
                    case 2
                        exe_to_consider=1;
                end
                
        end
        
        M(d)=nanmean(S1exerciseOK_2{exe_to_consider}.exe_time);
        S(d)=nanstd(S1exerciseOK_2{exe_to_consider}.exe_time);
        
        EXE_TIME_mat(n,d)= M(d); 
        
        success(d)=S1exerciseOK_2{exe_to_consider}.success*100;
        
        success_mat(n,d)=success(d); 
        
        NR_task=max(size(S1exerciseOK_2{exe_to_consider}.Task));
        temp_smoothness=[];
        for t=1:NR_task
            CP(t)=S1exerciseOK_2{exe_to_consider}.Task{t}.CP_ALL;
            temp_smoothness=[temp_smoothness S1exerciseOK_2{exe_to_consider}.Task{t}.smoothness_ALL];
            ROM_elbow(t)=S1exerciseOK_2{exe_to_consider}.Task{t}.ROM_elbow_mean;
            ROM_SE(t)=S1exerciseOK_2{exe_to_consider}.Task{t}.ROM_SE_mean;
            ROM_SR(t)=S1exerciseOK_2{exe_to_consider}.Task{t}.ROM_SR_mean;
        end
        
        CP_mean_task(d)=nanmean(CP);
        CP_mean_mat(n,d)=CP_mean_task(d);
        CP_std_task(d)=nanstd(CP);
        CP_std_mat(n,d)=CP_std_task(d);
        
        smoothness_mean_task(d)=nanmean(temp_smoothness);
        smoothness_mean_mat(n,d)=smoothness_mean_task(d);
        smoothness_std_task(d)=nanstd(temp_smoothness);
        smoothness_std_mat(n,d)=smoothness_std_task(d);
        
        [m,I]=max(ROM_elbow);
        ROM_elbow_mean(d)=nanmean(S1exerciseOK_2{exe_to_consider}.Task{I}.ROM_elbow);
        ROM_elbow_mean_mat(n,d)=ROM_elbow_mean(d);
        ROM_elbow_std(d)=nanstd(S1exerciseOK_2{exe_to_consider}.Task{I}.ROM_elbow);
        ROM_elbow_std_mat(n,d)=ROM_elbow_std(d);
        
        [m,I]=max(ROM_SE);
        ROM_SE_mean(d)=nanmean(S1exerciseOK_2{exe_to_consider}.Task{I}.ROM_SE);
        ROM_SE_mean_mat(n,d)=ROM_SE_mean(d);
        ROM_SE_std(d)=nanstd(S1exerciseOK_2{exe_to_consider}.Task{I}.ROM_SE);
        ROM_SE_std_mat(n,d)=ROM_SE_std(d);
        
        [m,I]=max(ROM_SR);
        ROM_SR_mean(d)=nanmean(S1exerciseOK_2{exe_to_consider}.Task{I}.ROM_SR);
        ROM_SR_mean_mat(n,d)=ROM_SR_mean(d);
        ROM_SR_std(d)=nanstd(S1exerciseOK_2{exe_to_consider}.Task{I}.ROM_SR);
        ROM_SR_std_mat(n,d)=ROM_SR_std(d);
        
        
        switch d
            case 1
                Exe_time_d1=S1exerciseOK_2{exe_to_consider}.exe_time;
            case 2
                Exe_time_d2=S1exerciseOK_2{exe_to_consider}.exe_time;
        end
        
        
        clear CP temp_smoothness ROM_SE ROM_SR ROM_elbow
        
    end
    
    
    
    
    figure (1)
    subplot(221)
    switch n
        case 1
            plot([1 2],M,'--*','Color','k','MarkerSize',12)
            hold on
%             errorbar([1 2],M,S,'k')
        case 2
            plot([1.1 2.1],M,'--*','Color','r','MarkerSize',12)
            hold on
%             errorbar([1.1 2.1],M,S,'r')
            
        case 3
            plot([1.2 2.2],M,'--*','Color','b','MarkerSize',12)
            hold on
%             errorbar([1.2 2.2],M,S,'b')
        case 4
            plot([1.3 2.3],M,'--*','Color','m','MarkerSize',12)
            hold on
%             errorbar([1.3 2.3],M,S,'m')
        case 5
            plot([1.4 2.4],M,'--*','Color','g','MarkerSize',12)
            hold on
%             errorbar([1.4 2.4],M,S,'g')    
        case 6
            plot([0.9 1.9],M,'--*','Color',[0 0.6 0],'MarkerSize',12)
            hold on
%             errorbar([0.9 1.9],M,S,'Color',[0 0.6 0])
    end
    title('Exercise duration [s] ','FontSize',14,'FontWeight','b')
    set(gca,'XTick',[1 2.05])
    set(gca,'XTickLabel',['Day 1';'Day N'])
    set(gca,'Fontsize',14)
    xlim([0.5 3])
    
    subplot(222)
    switch n
        case 1
            plot([1 2],success,'--*','Color','k','MarkerSize',12)
            hold on
%             errorbar([1 2],success,[0 0],'k')
            ylim([45 105])
        case 2
            plot([1.1 2.1],success,'--*','Color','r','MarkerSize',12)
            hold on
%             errorbar([1.1 2.1],success,[0 0],'r')
        case 3
            plot([1.2 2.2],success,'--*','Color','b','MarkerSize',12)
            hold on
%             errorbar([1.2 2.2],success,[0 0],'b')
        case 4
            plot([1.3 2.3],success,'--*','Color','m','MarkerSize',12)
            hold on
%             errorbar([1.3 2.3],success,[0 0],'m') 
        case 5
            plot([1.4 2.4],success,'--*','Color','g','MarkerSize',12)
            hold on
%             errorbar([1.4 2.4],success,[0 0],'g')    
        case 6
            plot([0.9 1.9],success,'--*','Color',[0 0.6 0],'MarkerSize',12)
            hold on
%             errorbar([0.9 1.9],success,[0 0],'Color',[0 0.6 0])
    end
    title('% of successful tasks','FontSize',14,'FontWeight','b')
    set(gca,'XTick',[1 2.05])
    set(gca,'XTickLabel',['Day 1';'Day N'])
    set(gca,'Fontsize',14)
    xlim([0.5 3])
    
    subplot(223)
    switch n
        case 1
            plot([1 2],smoothness_mean_task,'--*','Color','k','MarkerSize',12)
            hold on
%             errorbar([1 2],smoothness_mean_task,smoothness_std_task,'k')
            
        case 2
            plot([1.1 2.1],smoothness_mean_task,'--*','Color','r','MarkerSize',12)
            hold on
%             errorbar([1.1 2.1],smoothness_mean_task,smoothness_std_task,'r')
        case 3
            plot([1.2 2.2],smoothness_mean_task,'--*','Color','b','MarkerSize',12)
            hold on
%             errorbar([1.2 2.2],smoothness_mean_task,smoothness_std_task,'b')
        case 4
            plot([1.3 2.3],smoothness_mean_task,'--*','Color','m','MarkerSize',12)
            hold on
%             errorbar([1.3 2.3],smoothness_mean_task,smoothness_std_task,'m') 
        case 5
            plot([1.4 2.4],smoothness_mean_task,'--*','Color','g','MarkerSize',12)
            hold on
%             errorbar([1.4 2.4],smoothness_mean_task,smoothness_std_task,'g')    
        case 6
            plot([0.9 1.9],smoothness_mean_task,'--*','Color',[0 0.6 0],'MarkerSize',12)
            hold on
%             errorbar([0.9 1.9],smoothness_mean_task,smoothness_std_task,'Color',[0 0.6 0])
    end
    title('Smoothness [0-1]','FontSize',14,'FontWeight','b')
    set(gca,'XTick',[1 2.05])
    set(gca,'XTickLabel',['Day 1';'Day N'])
    set(gca,'Fontsize',14)
    xlim([0.5 3])
    
    subplot(224)
    switch n
        case 1
            plot([1 2],CP_mean_task,'--*','Color','k','MarkerSize',12)
            hold on
%             errorbar([1 2],CP_mean_task,CP_std_task,'k')
        case 2
            plot([1.1 2.1],CP_mean_task,'--*','Color','r','MarkerSize',12)
            hold on
%             errorbar([1.1 2.1],CP_mean_task,CP_std_task,'r')
        case 3
            plot([1.2 2.2],CP_mean_task,'--*','Color','b','MarkerSize',12)
            hold on
%             errorbar([1.2 2.2],CP_mean_task,CP_std_task,'b')
        case 4
            plot([1.3 2.3],CP_mean_task,'--*','Color','m','MarkerSize',12)
            hold on
%             errorbar([1.3 2.3],CP_mean_task,CP_std_task,'m')
        case 5
            plot([1.4 2.4],CP_mean_task,'--*','Color','g','MarkerSize',12)
            hold on
%             errorbar([1.4 2.4],CP_mean_task,CP_std_task,'g')    
        case 6
            plot([0.9 1.9],CP_mean_task,'--*','Color',[0 0.6 0],'MarkerSize',12)
            hold on
%             errorbar([0.9 1.9],CP_mean_task,CP_std_task,'Color',[0 0.6 0])
    end
    title('Coefficient of Periodicity [0-1]','FontSize',14,'FontWeight','b')
    set(gca,'XTick',[1 2.05])
    set(gca,'XTickLabel',['Day 1';'Day N'])
    set(gca,'Fontsize',14)
    xlim([0.5 3])
    
    %maximal ROM
    figure(2)
    subplot(311)
    switch n
        case 1
            plot([1 2],ROM_elbow_mean,'--*','Color','k','MarkerSize',12)
            hold on
%             errorbar([1 2],ROM_elbow_mean,ROM_elbow_std,'k')
            
        case 2
            plot([1.1 2.1],ROM_elbow_mean,'--*','Color','r','MarkerSize',12)
            hold on
%             errorbar([1.1 2.1],ROM_elbow_mean,ROM_elbow_std,'r')
        case 3
            plot([1.2 2.2],ROM_elbow_mean,'--*','Color','b','MarkerSize',12)
            hold on
%             errorbar([1.2 2.2],ROM_elbow_mean,ROM_elbow_std,'b')
        case 4
            plot([1.3 2.3],ROM_elbow_mean,'--*','Color','m','MarkerSize',12)
            hold on
%             errorbar([1.3 2.3],ROM_elbow_mean,ROM_elbow_std,'m') 
        case 5
            plot([1.4 2.4],ROM_elbow_mean,'--*','Color','g','MarkerSize',12)
            hold on
%             errorbar([1.4 2.4],ROM_elbow_mean,ROM_elbow_std,'g')    
        case 6
            plot([0.9 1.9],ROM_elbow_mean,'--*','Color',[0 0.6 0],'MarkerSize',12)
            hold on
%             errorbar([0.9 1.9],ROM_elbow_mean,ROM_elbow_std,'Color',[0 0.6 0])
    end
    title('Maximal ROM','FontSize',14,'FontWeight','b')
    set(gca,'XTick',[1 2.05])
    set(gca,'XTickLabel',['Day 1';'Day N'])
    set(gca,'Fontsize',14)
    xlim([0.5 3])
    ylabel('elbow [°]')
    
    subplot(312)
    switch n
        case 1
            plot([1 2],ROM_SE_mean,'--*','Color','k','MarkerSize',12)
            hold on
%             errorbar([1 2],ROM_SE_mean,ROM_SR_std,'k')
        case 2
            plot([1.1 2.1],ROM_SE_mean,'--*','Color','r','MarkerSize',12)
            hold on
%             errorbar([1.1 2.1],ROM_SE_mean,ROM_SR_std,'r')
        case 3
            plot([1.2 2.2],ROM_SE_mean,'--*','Color','b','MarkerSize',12)
            hold on
%             errorbar([1.2 2.2],ROM_SE_mean,ROM_SR_std,'b')
        case 4
            plot([1.3 2.3],ROM_SE_mean,'--*','Color','m','MarkerSize',12)
            hold on
%             errorbar([1.3 2.3],ROM_SE_mean,ROM_SR_std,'m')
        case 5
            plot([1.4 2.4],ROM_SE_mean,'--*','Color','g','MarkerSize',12)
            hold on
%             errorbar([1.4 2.4],ROM_SE_mean,ROM_SR_std,'g')    
        case 6
            plot([0.9 1.9],ROM_SE_mean,'--*','Color',[0 0.6 0],'MarkerSize',12)
            hold on
%             errorbar([0.9 1.9],ROM_SE_mean,ROM_SR_std,'Color',[0 0.6 0])
    end
    set(gca,'XTick',[1 2.05])
    set(gca,'XTickLabel',['Day 1';'Day N'])
    set(gca,'Fontsize',14)
    xlim([0.5 3])
    ylabel('shoulder elevation [°]')
    
    
    subplot(313)
    switch n
        case 1
            plot([1 2],ROM_SR_mean,'--*','Color','k','MarkerSize',12)
            hold on
%             errorbar([1 2],ROM_SR_mean,ROM_SR_std,'k')
            
        case 2
            plot([1.1 2.1],ROM_SR_mean,'--*','Color','r','MarkerSize',12)
            hold on
%             errorbar([1.1 2.1],ROM_SR_mean,ROM_SR_std,'r')
        case 3
            plot([1.2 2.2],ROM_SR_mean,'--*','Color','b','MarkerSize',12)
            hold on
%             errorbar([1.2 2.2],ROM_SR_mean,ROM_SR_std,'b')
        case 4
            plot([1.3 2.3],ROM_SR_mean,'--*','Color','m','MarkerSize',12)
            hold on
%             errorbar([1.3 2.3],ROM_SR_mean,ROM_SR_std,'m')
        case 5
            plot([1.4 2.4],ROM_SR_mean,'--*','Color','g','MarkerSize',12)
            hold on
%             errorbar([1.4 2.4],ROM_SR_mean,ROM_SR_std,'g')    
        case 6
            plot([0.9 1.9],ROM_SR_mean,'--*','Color',[0 0.6 0],'MarkerSize',12)
            hold on
%             errorbar([0.9 1.9],ROM_SR_mean,ROM_SR_std,'Color',[0 0.6 0])
    end
    set(gca,'XTick',[1 2.05])
    set(gca,'XTickLabel',['Day 1';'Day N'])
    set(gca,'Fontsize',14)
    xlim([0.5 3])
    ylabel('shoulder rotation [°]') 
    
  end



%% ANALISI STATISTICA

% Wilcoxon signed rank test non parametric test for paired samples 
 
p_exe_time = signrank(EXE_TIME_mat(:,1),EXE_TIME_mat(:,2)); 
p_success = signrank(success_mat(:,1),success_mat(:,2)); 
p_CP_mean= signrank(CP_mean_mat(:,1),CP_mean_mat(:,2));
p_CP_std= signrank(CP_std_mat(:,1),CP_std_mat(:,2));
p_smoothness_mean=signrank(smoothness_mean_mat(:,1),smoothness_mean_mat(:,2));
p_smoothness_std=signrank(smoothness_std_mat(:,1),smoothness_std_mat(:,2));
p_ROM_elbow_mean=signrank(ROM_elbow_mean_mat(:,1),ROM_elbow_mean_mat(:,2));
p_ROM_elbow_std=signrank(ROM_elbow_std_mat(:,1),ROM_elbow_std_mat(:,2));
p_ROM_SE_mean=signrank(ROM_SE_mean_mat(:,1),ROM_SE_mean_mat(:,2));
p_ROM_SE_std=signrank(ROM_SE_std_mat(:,1),ROM_SE_std_mat(:,2));
p_ROM_SR_mean=signrank(ROM_SR_mean_mat(:,1),ROM_SR_mean_mat(:,2));
p_ROM_SR_std=signrank(ROM_SR_std_mat(:,1),ROM_SR_std_mat(:,2));

cd(currentPath)
