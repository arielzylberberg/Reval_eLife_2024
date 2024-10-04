function eval_best_alltogether(valuessource_flag)

% valuessource_flag = 'explicit';
% valuessource_flag = 'dynamic_reeval';
if nargin==0
    eval_best_alltogether('explicit');
    eval_best_alltogether('dynamic_reeval');
    return;
end

%%
% addpath('/Volumes/Data/1 - LAB/15 - code/22-DTB_1D/')
addpath('../functions');
%%


%% prep data
re_eval_dyn = load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');

%% preliminaries

values_new_dyn = re_eval_dyn.values_re_opt;

load ../data/prepro_data.mat
struct2vars(dat);


%%
% pars.t = 0:0.0005:10;


load(fullfile('./out',valuessource_flag),'coh','pars','theta_allsujs');

do_recalc = 1;
if do_recalc
    
    %%
    nsujs = length(nanunique(group));
    
    filt = true(size(group));
    
    plot_flag = 0;
    %%
    
    theta = theta_allsujs;
    [err,P] =  wrapper_dtb_parametricbound_rt_plaw(theta,rt(filt),coh(filt),choices(filt),[],pars,plot_flag);
    
    ndt_m = theta(2);
    ndt_s = theta(3);
    
    [uu,~,J] = unique(coh(filt));
    if length(uu)~=length(P.drift)
        error('sizes dont match')
    end
    
    p_up_model(filt) = P.up.p(J);
    mean_t_model_up(filt) = P.up.mean_t(J) + ndt_m;
    mean_t_model_lo(filt) = P.lo.mean_t(J) + ndt_m;
    
       
    ucoh = unique(coh);
    rtm = P.up.mean_t.*P.up.p+P.lo.mean_t.*(1-P.up.p) + ndt_m;
    
    save(['./out/for_plotting_all_',valuessource_flag],'p_up_model','mean_t_model_up','mean_t_model_lo','P','ndt_m','ucoh','rtm');
    
end

%% rapid plot

load(['./out/for_plotting_all_',valuessource_flag])

if isequal(valuessource_flag,'explicit')
    dv = diff(values,[],2);
else
    dv = diff(values_new_dyn,[],2);
end




%%
loc_flag = 1;
switch loc_flag
    case 1

        loc(dv<=-1.5) = -2;
        loc(dv<=-.75 & dv>-1.5) = -1;
        loc(dv<=-.375 & dv>-.75) = -.5;
        loc(dv<=-.1875 & dv>-.375) = -.25;
        loc(dv<=-.0625 & dv>-.1875) = -.125;
        loc(dv>-.0625 & dv<.0625) = 0;
        loc(dv>=.0625 & dv<.1875) = .125;
        loc(dv>=.1875 & dv<.375) = .25;
        loc(dv>=.375 & dv<.75) = .5;
        loc(dv>=.75 & dv<1.5) = 1;
        loc(dv>=1.5) = 2;
    case 2
        [uni_dvs,idx_dvs] = index_prctile(abs(dv),[0:20:100]);
        uni_dvs(1) = 0;
        loc = uni_dvs(idx_dvs)'.*sign(dv);
    case 3
        u = linspace(-100,100,12);
        u(u<0) = [];
        u = [0,u];
        
        [uni_dvs,idx_dvs] = index_prctile(abs(dv),u);
        uni_dvs(1) = 0;
        loc = uni_dvs(idx_dvs)'.*sign(dv);

end


[~,vals] = curva_media(dv,loc,[],0);

[~,~,idx] = unique(loc);
xvals = index_to_val(idx,vals);



[tt,xx,ss] = curva_media(choices,xvals,[],0);


% for replotting
M.choice.data.tt = tt;
M.choice.data.xx = xx;
M.choice.data.ss = ss;
M.choice.model.ucoh = ucoh;
M.choice.model.pup = P.up.p;



[tt,xx,ss] = curva_media(rt,xvals,[],0);


% for replotting
M.rt.data.tt = tt;
M.rt.data.xx = xx;
M.rt.data.ss = ss;
M.rt.model.ucoh = ucoh;
M.rt.model.pup = rtm;

save(['./out/dat_plot_alltogether_',valuessource_flag],'-struct','M');
