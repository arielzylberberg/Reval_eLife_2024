str = {'for_plotting_dynamic_reeval','for_plotting_explicit'};

aux = load('../data/prepro_data.mat');
dat = aux.dat;

uni_group = nanunique(dat.group);

for i=1:length(str)
    v = load(fullfile('../DDM_fit/out',str{i}));

    %%

    rt_res = nan(size(dat.rt));

    I = dat.choices==0;
    rt_res(I) = dat.rt(I) - v.mean_t_model_lo(I)';

    I = dat.choices==1;
    rt_res(I) = dat.rt(I) - v.mean_t_model_up(I)';

    var_explained(i) = 100 * (1-var(rt_res)./var(dat.rt));

    % per suj
    for j=1:length(uni_group)
        J = dat.group==uni_group(j);
        var_explained_per_suj(j,i) =  100 * (1-var(rt_res(J))./var(dat.rt(J)));
    end
    
end

%%
p = publish_plot(1,1);
plot(var_explained_per_suj(:,1),var_explained_per_suj(:,2),'k','Marker','o','MarkerFaceColor',0.7*[1,1,1],'LineStyle','none');
same_xylim(gca);
h  = refline(1,0);
set(h,'color','k');

xlabel({'RT variance explained [%] ','with Revaluated values'});
ylabel({'RT variance explained [%] ','with Explicit values'});
axis square
p.format('MarkerSize',10,'FontSize',20);
same_xytick(p.h_ax);
p.append_to_pdf('fig_RT_var_explained',1,1);