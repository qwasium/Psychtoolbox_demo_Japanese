load em_data_5go.mat

reactiontimes = responsetime(conditionsrand==1) - targettime(conditionsrand==1);
meanRT = mean(reactiontimes);
plot(reactiontimes, '--or', 'LineWidth', 4, 'MarkerSize',10)
set(gca,'FontSize',18)
xlabel('Go trial number')
ylabel('Reaction time (s)')

errors_commission = length(find(buttonpressed(conditionsrand==2)==1));
error_percentage = (errors_commission/(nTrials-numbergo))*100;