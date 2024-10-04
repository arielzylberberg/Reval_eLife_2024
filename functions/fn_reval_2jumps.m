function [dev,values_re,vd] = fn_reval_2jumps(delta_v, v, choices, trials, group)


vd = v; % dynamic value, changed within loop

values_re = nan(length(choices),2);

nsuj = length(nanunique(group));
uni_group = nanunique(group);
for i = 1:nsuj
    J = find(group==uni_group(i));
    for j=1:length(J)
        items = trials(J(j),:);
        values_re(J(j),:) = vd(items,i);
        if choices(J(j))==1
            update = vd(items(1),i) - delta_v;
            if update >= (v(items(1),i) - 1*delta_v)
                vd(items(1),i) = update;
            end
            update = vd(items(2),i) + delta_v;
            if update <= (v(items(2),i) + 1*delta_v)
                vd(items(2),i) = update;
            end
        else
            update = vd(items(1),i) + delta_v;
            if update <= (v(items(1),i) + delta_v)
                vd(items(1),i) = update;
            end
            update  = vd(items(2),i) - delta_v;
            if update >=  (v(items(2),i) - delta_v)
                vd(items(2),i) = vd(items(2),i) - delta_v;
            end
        end
        %             vd = clip(vd,0,3);
    end
end


% goodness of fit
dev = calc_dev(values_re,choices,group);