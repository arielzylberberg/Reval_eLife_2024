function [dev_persuj,dev_sum] = calc_dev(values,choices,group)


% goodness of fit
% indepvar = {'val_left',values(:,1),'val_right',values(:,2),'group',adummyvar(group)};
% [beta,idx,stats,x,LRT] = f_regression(choices,[],indepvar);
% dev = stats.DEV;

uni_group = nanunique(group);
nsuj = length(uni_group);
dev_persuj = nan(nsuj,1);
for i=1:nsuj
    I = group==uni_group(i);
    % goodness of fit
    indepvar = {'val_left',values(I,1),'val_right',values(I,2),'group',adummyvar(group(I))};
    [beta,idx,stats,x,LRT] = f_regression(choices(I),[],indepvar);
    dev_persuj(i) = stats.DEV;
end
dev_sum = sum(dev_persuj);