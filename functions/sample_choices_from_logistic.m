function choices_fake = sample_choices_from_logistic(choices, group, values,logit_seed)

if nargin>3
    rng(logit_seed,'twister');
end

ntr = length(group);
nsuj = length(nanunique(group));

% simulate choices
dv = values(:,2) - values(:,1);
pright_logistic = nan(ntr,1);
uni_group = unique(group);
for i=1:nsuj
    I = group==uni_group(i);
    depvar = choices(I);
    indepvar = {'dv',dv(I),'ones',ones(sum(I),1)};
    [beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar);
    pright_logistic(I) = glmval(beta,x,'logit','constant','off');
end
choices_fake = rand(ntr,1)<pright_logistic; % simulated choices

end