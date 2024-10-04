function [delta_v_opt,dev_opt,values_re_opt] = do_optim_2jumps(v,choices,trials,group)

tguess = [0.0];
tlow = [-3];
thigh = [3];

options = optimset('Display','final');

uni_group = unique(group);
nsuj = length(uni_group);
ntr = length(group);

% init
delta_v_opt   = nan(1,nsuj); %optimal delta-value
dev_opt       = nan(1,nsuj); % deviance of the regression, for the optimal delta_v
values_re_opt = nan(ntr,2); % value of both left/right items in each trial

% go
for i=1:nsuj
    I = group==uni_group(i);
    fn_fit = @(theta) (fn_reval_2jumps(theta, v(:,i),choices(I),trials(I,:),group(I)));
    [delta_v_opt(i), fval, exitflag, output] = fminsearchbnd(@(theta) fn_fit(theta),...
        tguess,tlow,thigh,options);
    
    % eval best delta_v:
    [dev_opt(i),values_re_opt(I,:)] = fn_fit(delta_v_opt(i));
end
