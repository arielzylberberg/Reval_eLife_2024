function run_optim_per_suj()

addpath(genpath('../generic_functions/'))
addpath(genpath('../functions/'))

%% get data

vDatasource = 1:6;


for id = 1:length(vDatasource)
% for id = 9    
    datasource = vDatasource(id);
    
    % datasource = 6;
    switch datasource
        case 1
            aa = load('../data/prepro_data.mat');
            dat = aa.dat;
            str = 'delta_vals_optim_per_suj';
            
        case 2 % sepulveda
            aux = load('../data/sepulveda2020_food');
            dat = aux.dat(1); % choose prefered
            str = 'delta_vals_optim_per_suj_sepulveda_PREF';

        case 3 % sepulveda
            aux = load('../data/sepulveda2020_food');
            dat = aux.dat(2); % choose NOT prefered
            dat.choices = 1-dat.choices;
            str = 'delta_vals_optim_per_suj_sepulveda_NPREF';
            
        case 4 % Folke
            aux = load('../data/folke_for_reval.mat');
            dat = aux.dat;
            str = 'delta_vals_optim_per_suj_folke';
            
             
        case 5 %sample logistic choices
            aa = load('../data/prepro_data.mat');
            dat = aa.dat;
            str = 'delta_vals_optim_per_suj_sampled_logistic';
            logit_seed = 2944;
            choices_fake = sample_choices_from_logistic(dat.choices, dat.group, dat.values,logit_seed);
            dat.choices = choices_fake;


        case 6 % pink noise
             f = '../ceDDM_fit';
             dat = load(fullfile(f,'sim_data.mat'));
             str = 'delta_vals_optim_pink_ev';


        otherwise
            return;


    end
    
    uni_group = unique(dat.group); % unique subjects
    
    nsuj = length(uni_group); % number of subjects
    
    
    %% initialize
    
    dosave_flag = 1; %overwrite results to mat file
    
    logit_seed = 767655; % seed for the simulation of choices from the logistic fits
    
    
    %% calculate the optimal delta_v if choices were sampled from a logistic
    % based on the original values
    
    choices_fake = sample_choices_from_logistic(dat.choices, dat.group, dat.values,logit_seed);
    
    %go
    [delta_v_opt_fake,dev_opt_fake,values_re_opt_fake] = do_optim(dat.v,choices_fake,dat.trials,dat.group);
    
    % calculate the deviance, with the auction values, for choices samples from logistic
    dev_noreev_persuj_fake = calc_dev(dat.values,choices_fake,dat.group);

    
    %% optimal delta_v, per subject
    [delta_v_opt,dev_opt,values_re_opt] = do_optim(dat.v,dat.choices,dat.trials,dat.group);
    
    %% calculate the deviance, with the auction values
    [dev_noreev_persuj, dev_noreev] = calc_dev(dat.values,dat.choices,dat.group);
    
    %% do the optim after shuffling the order of the trials
    
    
    %% fully backwards
    sI = [];
    for i=1:nsuj
        ff = find(dat.group == uni_group(i));
        sI = [sI; ff(end:-1:1)];
    end
    choices_backwards = dat.choices(sI);
    trials_backwards = dat.trials(sI,:);
    [~,dev_opt_bwards,values_re_opt_bwards] = do_optim(dat.v,choices_backwards,trials_backwards,dat.group);
    
    %% save
    
    if dosave_flag
        save(['./output_data/',str],'delta_v_opt','values_re_opt','dev_opt',...
            'delta_v_opt_fake','values_re_opt_fake','dev_opt_fake','dev_noreev','dev_noreev_persuj','dev_opt_bwards',...
            'values_re_opt_bwards','choices_fake','dev_noreev_persuj_fake');
    end
    

end

end

%%

