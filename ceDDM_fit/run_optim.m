addpath('../functions')

%%
load ../data/prepro_data.mat

%%

uni_group = unique(dat.group);

theta = [];
fval = nan(length(uni_group),1);
parfor i=1:length(uni_group) % 0 is all subjects

    isuj = uni_group(i);
    v = dat.v(:,isuj);
    I = ismember(dat.group,isuj);
    trials = dat.trials(I,:);

    choices = dat.choices(I);
    rt = dat.rt(I);
    values = dat.values(I,:);


    tl   = [.5  , .1 , 0.04, 0.1 , 0.4, 0.1];
    th   = [100 , 1.5, 0.04 , 20, 1.6, 0.5];
    tg   = [30  , 0.4, 0.04 , 4, 0.7, 0.3];


    only_choice = false;
    if only_choice
        tg  = tg(1:4);
        tl  = tl(1:4);
        th  = th(1:4);
    end
    seed = 12419 + i;
    plotflag = 0;

    fn_fit = @(theta) (wrapper_dtb_pink_evidence(theta,v,values,trials,choices,rt,seed,plotflag,isuj,only_choice));

    ptl = tl;
    pth = th;
    [theta(i,:), fval(i), exitflag, output] = bads(@(theta) fn_fit(theta),tg,tl,th,ptl,pth);

end

save from_fits theta fval

