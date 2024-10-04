addpath('../functions')

%%
load ../../data/prepro_data.mat
aux = load('from_fits');
%%

uni_group = unique(dat.group);


for i=1:length(uni_group)
    
    isuj = uni_group(i);
    v = dat.v(:,isuj);
    I = ismember(dat.group,isuj);
    trials = dat.trials(I,:);
    
    choices = dat.choices(I);
    rt = dat.rt(I);
    values = dat.values(I,:);
    
    
    seed = 2213213 + 1;
    theta = aux.theta(i,:);
    isuj = 1;
    only_choice = 0;
    plotflag = 1;
    nchains = 1;
    [logl,out] = wrapper_dtb_pink_evidence(theta,v,values,trials,choices,rt,seed,plotflag,isuj,only_choice,nchains);
    
    if i==1
        model.choices = out.choice;
        model.rt = out.RT;
    else
        model.choices = [model.choices; out.choice];
        model.rt = [model.rt; out.RT];
    end
end
model.trials = dat.trials;
model.group = dat.group;
model.values = dat.values;
model.v = dat.v;

save('sim_data','-struct','model');


