function [dev,values_re,vd] = re_val_2d(theta, v,values,choices,trials,group,varargin)

split_by = choices;
for i=1:2:length(varargin)
    if isequal(varargin{i},'split_by')
        split_by = varargin{i+1};
    end
end


delta_v_chosen = theta(1);
delta_v_unchosen = theta(2);

vd = v; % dynamic value, changed within loop

values_re = nan(size(values));

nsuj = length(nanunique(group));
uni_group = nanunique(group);
for i = 1:nsuj
    J = find(group==uni_group(i));
    for j=1:length(J)
        items = trials(J(j),:);
        values_re(J(j),:) = vd(items,i);
        if split_by(J(j))==1
            vd(items(1),i) = vd(items(1),i) - delta_v_unchosen;
            vd(items(2),i) = vd(items(2),i) + delta_v_chosen;
        else
            vd(items(1),i) = vd(items(1),i) + delta_v_chosen;
            vd(items(2),i) = vd(items(2),i) - delta_v_unchosen;
        end
        %             vd = clip(vd,0,3);
    end
end


% goodness of fit
indepvar = {'val_left',values_re(:,1),'val_right',values_re(:,2),'group',adummyvar(group)};
[beta,idx,stats,x,LRT] = f_regression(choices,[],indepvar);
dev = stats.DEV;