
load ../data/prepro_data.mat


LL_explicit = load(fullfile('../DDM_fit/out/for_plotting_explicit.mat'));
LL_reval = load(fullfile('../DDM_fit/out/for_plotting_dynamic_reeval.mat'));

%%
numParamDTB = 7;
numParamReval = 1;

unigroup = unique(dat.group);

for i = 1:length(unigroup)

    I = dat.group==unigroup(i);
    numObs = sum(I);
    logl(i) = LL_explicit.LCOMBINED(i); 
    [aic(i),bic(i)] = aicbic(logl(i),numParamDTB,numObs);
    
    logl_re(i) = LL_reval.LCOMBINED(i); 
    [aic_reval(i),bic_reval(i)] = aicbic(logl_re(i),numParamDTB + numParamReval,numObs);
    
end

delta_BIC = diff([bic',bic_reval'],[],2);
delta_AIC = diff([aic',aic_reval'],[],2);

%%
p = publish_plot(1,2);
set(gcf,'Position',[304  266  785  325])

p.next();
h(1) = barh(delta_BIC);
hold on
plot([0,0],ylim,'r');
xlabel('\DeltaBIC');

ylabel('Subject');


p.next();
h(2) = barh(delta_AIC);
hold on
plot([0,0],ylim,'r');
xlabel('\DeltaAIC');

ylabel('Subject');

symmetric_x(p.h_ax);

set(h,'FaceColor',0.7*[1,1,1],'EdgeColor','w');

set(p.h_ax(2),'ycolor','none');
p.offset_axes();
p.format();
p.append_to_pdf('fig_bic_aic',1,1);



