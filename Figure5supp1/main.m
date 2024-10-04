load ../data/prepro_data.mat
m = load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');

%%
values = dat.values;
values_re = m.values_re_opt;
dv = diff(values,[],2);
dv_re = diff(values_re,[],2);

agroup = adummyvar(dat.group);  

%% choice regre
depvar = dat.choices;
indepvar = {'dv',dv,'dv_re_delta',dv_re-dv,'group',agroup};
testSignificance.vars = [1,2];
[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

stats.p(idx.dv)
stats.p(idx.dv_re_delta)

stats.beta(idx.dv)
stats.beta(idx.dv_re_delta)

stats.se(idx.dv)
stats.se(idx.dv_re_delta)

%%
depvar = dat.choices;
indepvar = {'dv',dv,'dv_re',dv_re,'group',agroup};
testSignificance.vars = [1,2];
[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

stats.p(idx.dv)
stats.p(idx.dv_re)

%% same per suj

uni_group = unique(dat.group);
nsuj = length(uni_group);

for i=1:length(uni_group)
    I = dat.group==uni_group(i);

    depvar = dat.choices(I);
    indepvar = {'dv',dv(I),'dv_re',dv_re(I),'group',ones(sum(I),1)};
    testSignificance.vars = [1,2];
    [beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);
    
    BETA(i) = beta(idx.dv);
    BETA_RE(i) = beta(idx.dv_re);

    SE(i) = stats.se(idx.dv);
    SE_RE(i) = stats.se(idx.dv_re);
end
%%
p = publish_plot(1,1);
plot([0,0],[-8,8],'r');
hold on
plot([-8,8],[0,0],'r');

for i=1:length(uni_group)
    plot([BETA(i)-SE(i), BETA(i)+SE(i)] ,[BETA_RE(i), BETA_RE(i)],'k');
    hold on
    plot([BETA(i), BETA(i)] ,[BETA_RE(i)-SE_RE(i), BETA_RE(i)+SE_RE(i)],'k');
end
for i=1:length(uni_group)
    plot(BETA(i),BETA_RE(i),'ko','MarkerFaceColor','w');
end
% symmetric_x(gca);
% symmetric_y(gca);

str = 'logit[p_{right}] = \beta_0 + \beta_s \Deltav_s + \beta_d \Deltav_d';
text(0.4,-4,str);

xlabel('\beta_s');
ylabel('\beta_d');

p.format();

axis square;
set(gca,'xtick',[-8:2:8]);