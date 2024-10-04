addpath('../functions'); 

load ../data/prepro_data.mat

%%

[trials_sorted, isort] = sort(dat.trials,2);
I = isort(:,1)==2;
choices_sorted = dat.choices;
choices_sorted(I) = 1-choices_sorted(I);
values_sorted = dat.values;
values_sorted(I,:) = values_sorted(I,[2,1]); % values corresponding to trials_sorted


[u,~,idx] = unique([trials_sorted, dat.group],'rows');


is_same_choice = [];
trial_separation = [];
G = [];
Vs = [];
for i = 1:size(u,1)% unique combinations
    I = idx==i;
    fI = find(I);
    if sum(I)==2
        is_same_choice = [is_same_choice; diff(choices_sorted(I))==0];
        trial_separation = [trial_separation; diff(dat.tr_num(fI))];
        Vs = [Vs; values_sorted(fI(1),:)];
        G = [G; dat.group(fI(1))];
    end
end

% sort
[trial_separation_sorted, Isort] = sort(trial_separation);
is_same_choice_sorted = is_same_choice(Isort);

% 

w = 100; % num trials in average
n = length(is_same_choice_sorted);
clear x y
for i=1:n-w
    y(i) = mean(is_same_choice_sorted(i:i+w-1));
    x(i) = mean(trial_separation_sorted(i:i+w-1));
end

%% plot
p = publish_plot(1,1);

plot(x,y,'k')

% fit exponential
g = fittype('a-b*exp(-c*x)');
xx = x';
yy = y';
f0 = fit(xx,yy,g,'StartPoint',[1, 0, 1]);
hold all
plot(sort(xx),f0(sort(xx)),'color','k');
hold all
plot(xlim,[mean(yy),mean(yy)],'k--','LineWidth',1)

ylabel({'Match probability','for identical repetitions'})
xlabel('Difference in trial number between repeats');
p.format('FontSize',18,'LineWidthAxes',0.5,'LineWidthPlot',1);
axis tight
ylim([0.6,0.95]);

%% stats
depvar = is_same_choice;
interact = bsxfun(@times,adummyvar(G),abs(diff(Vs,[],2)));
indepvar = {'trial_diff',trial_separation,'participant',adummyvar(G),'participant_x_dv',interact};
testSignificance.vars = [1,2,3];
[beta,idx,stats,xreg,LRT] = f_regression(depvar,[],indepvar,testSignificance);
yhat = glmval(beta,xreg,'logit','constant','off');


beta(idx.trial_diff)
stats.p(idx.trial_diff)






