function main()

addpath(genpath('../functions/'));

%% prep data
re_eval_dyn = load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');


%% preliminaries

values_new_dyn = re_eval_dyn.values_re_opt;

aux = load('../data/prepro_data.mat');
dat = aux.dat;

% initialize, for the cluster
values=[]; trials=[];rt=[];choices=[];v=[];group=[];tr_num=[];
num_app_item=[];num_app_pair=[];scanner=[];eye=[];task_order=[];run=[];runtrial=[];onsettime=[];iti=[];

struct2vars(dat);

%%
rng(234234,'twister');


%%
parpool(7);


%%
vValueSource = {'explicit','dynamic_reeval'};

vTheta = cell(1);
vFval = cell(1);

for l=1:2
    
    valuessource_flag = vValueSource{l};
    coh = nan(size(group));
    nsujs = length(nanunique(group));
    for i=1:nsujs
        filt = group == i;
        
        switch valuessource_flag
            case 'explicit'
                dv = diff(values(filt,:),[],2);
            case 'dynamic_reeval'
                dv = diff(values_new_dyn(filt,:),[],2);
                
        end
        
        discrete_dvs = -10:0.1:10;
        J = findclose(discrete_dvs,dv);
        
        coh(filt) = discrete_dvs(J);
        
    end
    
    %%
    pars.t = 0:0.0005:10;
    
    %%
    
    tl = [0.2,  0.3, .05 ,0.5  , 0, 0, -0.2,0, 1/20];
    th = [20,   1,   .05 ,4    , 3 ,5, 0.2, 0, 3];
    tg = [5,    0.5, .05 ,1.5  , 1 ,1, 0,   0, 1];
    ptl = tl;
    pth = th;
    
    parfor i=1:nsujs+1
        % for i=1:nsujs

        if i==1
            filt = true(size(group));
        else
            filt = group == i-1;
        end
        
        plot_flag = 0;
        %%
        fn_fit = @(theta) (wrapper_dtb_parametricbound_rt_plaw(theta,rt(filt),coh(filt),choices(filt),[],pars,plot_flag));

        options = optimset('Display','final','TolFun',1,'FunValCheck','on');
        [theta,fval,exitflag,output] = bads(@(theta) fn_fit(theta),tg,tl,th,ptl,pth,options);
        

        vTheta{i} = theta;
        vFval{i} = fval;

        
    end
    fval_allsujs = vFval{1};
    theta_allsujs = vTheta{1};
    vTheta(1) = [];
    vFval(1) = [];
    save(fullfile('./out',valuessource_flag),'vTheta','vFval','coh','pars','theta_allsujs','fval_allsujs');
    
end

end
