function [dev,values_re,vd] = fn_reval_hd_binary(theta, v,values,choices,trials,group,split_by)


a = theta(1); %delta_b if x<median(split_by);
b = theta(2); %delta_b if x>=median(split_by);


vd = v; % dynamic value, changed within loop

values_re = nan(size(values));


nsuj = length(nanunique(group));
uni_group = nanunique(group);
for i = 1:nsuj
    J = find(group==uni_group(i));
    
    m = nanmedian(split_by(J));
    
    for j=1:length(J)
        items = trials(J(j),:);
        values_re(J(j),:) = vd(items,i);
        x = split_by(J(j));
        
        if x<m
            delta_v = a;
        else
            delta_v = b;
        end
        %delta_v = a + b*exp(-1*c*x);
        
        if choices(J(j))==1
            vd(items(1),i) = vd(items(1),i) - delta_v;
            vd(items(2),i) = vd(items(2),i) + delta_v;
        else
            vd(items(1),i) = vd(items(1),i) + delta_v;
            vd(items(2),i) = vd(items(2),i) - delta_v;
        end
        %             vd = clip(vd,0,3);
    end
end


% goodness of fit
dev = calc_dev(values_re,choices,group);

% print
% fprintf('err=%.3f \n',dev);
