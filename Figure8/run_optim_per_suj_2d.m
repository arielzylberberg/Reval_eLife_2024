clear
% load ../rawdata/prepro_data.mat
% load ../data_from_akram/prepro_data.mat



aux = load('../data/prepro_data.mat');
dat = aux.dat;
str = 'delta_vals_optim_per_suj';
    


%%

string_to_eval = fields_to_vars('dat',dat);
eval(string_to_eval);

% nsuj = 30;
ntr = length(dat.choices);

%%
tg = [0.2,0.2];
tl = [-1,-1];
th = [2,2];

options = optimset('Display','final');
%% all suj together

fn_fit = @(theta) (re_val_2d(theta, v,values,choices,trials,group));
[delta_v_opt_all, fval, exitflag, output] = fminsearchbnd(@(theta) fn_fit(theta),...
    tg,tl,th,options);
% eval best
[dev_opt_all,values_re_opt_all] = fn_fit(delta_v_opt_all);

%% per suj

uni_group = unique(group);
for i=1:length(uni_group)
    I = group==uni_group(i);
    fn_fit = @(theta) (re_val_2d(theta, v(:,i),values(I,:),choices(I),trials(I,:),group(I)));
    [delta_v_opt(i,:), fval, exitflag, output] = fminsearchbnd(@(theta) fn_fit(theta),...
        tg,tl,th,options);
    % eval best
    [dev_opt(i),values_re_opt(I,:)] = fn_fit(delta_v_opt(i,:));
end

%%
save delta_vals_optim_per_suj_2d delta_v_opt values_re_opt

%%
% goodness of fit
indepvar = {'val_left',values_re_opt(:,1),'val_right',values_re_opt(:,2),'group',adummyvar(group)};
[beta,idx,stats,x,LRT] = f_regression(choices,[],indepvar);
dev = stats.DEV;

%% sh plot

[newScat, newHist] = fn_hist_plot(delta_v_opt(:,1), delta_v_opt(:,2),[0,0.6],'\delta_{chosen}','-1 \times \delta_{unchosen}',21,[],0);
[h,pval] = ttest2(delta_v_opt(:,1),delta_v_opt(:,2));

set(gcf,'CurrentAxes',newScat)
text(0.1,0.5,['p-val(ttest)=',roundstr(pval,4)],'fontsize',14)

exportgraphics(gcf,'fig_corner_hist_chosen_unchosen.pdf','ContentType','vector','BackgroundColor','none');