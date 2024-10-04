function eval_best(valuessource_flag)

% valuessource_flag = 'explicit';
% valuessource_flag = 'dynamic_reeval';

if nargin==0
    eval_best('explicit');
    eval_best('dynamic_reeval');
    return;
end

%%
% addpath('/Volumes/Data/1 - LAB/15 - code/22-DTB_1D/')
addpath('../functions/');

%% prep data
re_eval_dyn = load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');

%% preliminaries

values_new_dyn = re_eval_dyn.values_re_opt;

load ../data/prepro_data.mat
struct2vars(dat);


%%

load(fullfile('./out',valuessource_flag),'vTheta','vFval','coh','pars');


do_recalc = 1;
if do_recalc
    
    %%
    nsujs = length(nanunique(group));
    LRT = nan(nsujs,1);
    LCHOICE = nan(nsujs,1);
    LCOMBINED = nan(nsujs,1);

    uni_coh = -10:0.2:10;
    ncoh = length(uni_coh);
    choice_function = nan(nsujs, ncoh);
    RT_function = nan(nsujs, ncoh);
    
    for i=1:nsujs
        
        filt = group == i;
        
        plot_flag = 0;
        %%
        
        theta = vTheta{i};
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
        
        
        % calc likelihood of RT
        dt = P.t(2)-P.t(1);
        ch = choices(filt);
        rt_samp = round(rt(filt)/dt);
        
        pup_pdf_norm = bsxfun(@times,P.up.pdf_t,1./nansum(P.up.pdf_t,2));
        plo_pdf_norm = bsxfun(@times,P.lo.pdf_t,1./nansum(P.lo.pdf_t,2));
        
        LCOMBINED(i) = -err;
        
        Paux = P;
        Paux.up.pdf_t = pup_pdf_norm;
        Paux.lo.pdf_t = plo_pdf_norm;
        [logl,pPred] = logl_choiceRT_1d(Paux,choices(filt),rt(filt),coh(filt),ndt_m,ndt_s);
        LRT(i) = -logl;
        
        pchoice = p_up_model(filt)'.*ch + (1-p_up_model(filt)').*(1-ch);
        pchoice(pchoice==0) = eps;
        LCHOICE(i) = sum(log(pchoice));

        % calc in finer grid
        [err,P] =  wrapper_dtb_parametricbound_rt_plaw(theta,nan(size(uni_coh)),uni_coh,nan(size(uni_coh)),[],pars,plot_flag);
        
        choice_function(i,:) = P.up.p;
        RT_function(i,:) = P.up.p.*P.up.mean_t + (1-P.up.p).*P.lo.mean_t + ndt_m;
        
    end
    save(['./out/for_plotting_',valuessource_flag],'p_up_model','mean_t_model_up','mean_t_model_lo',...
        'LRT','LCHOICE','LCOMBINED','uni_coh','choice_function','RT_function');

end


%%

