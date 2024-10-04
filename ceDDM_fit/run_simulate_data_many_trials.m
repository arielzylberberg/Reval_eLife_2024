addpath('../functions')

%%
load ../../data_from_akram/prepro_data.mat
aux = load('from_fits');

%%

uni_group = unique(dat.group);

ntrials = length(dat.group);
nsim = 100;

m_choice = nan(ntrials,nsim);
m_rt = nan(ntrials,nsim);

for j=1:nsim
    for i=1:length(uni_group)

        isuj = uni_group(i);
        v = dat.v(:,isuj);
        I = ismember(dat.group,isuj);
        trials = dat.trials(I,:);

        choices = dat.choices(I);
        rt = dat.rt(I);
        values = dat.values(I,:);

        seed = [];
        theta = aux.theta(i,:);
        only_choice = 0;
        plotflag = 0;
        nchains = 1;
        [logl,out] = wrapper_dtb_pink_evidence(theta,v,values,trials,choices,rt,seed,plotflag,isuj,only_choice,nchains);

        m_choice(I,j) = out.choice;
        m_rt(I,j) = out.RT;

    end
end
model.trials = dat.trials;
model.group = dat.group;
model.values = dat.values;
model.v = dat.v;
model.choices = m_choice;
model.rt = m_rt;

save('sim_data_many_trials','-struct','model');


