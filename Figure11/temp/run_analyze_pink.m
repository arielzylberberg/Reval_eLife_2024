
f = '../ceDDM_fit';
mdat = load(fullfile(f,'sim_data.mat'));
mmany = load(fullfile(f,'sim_data_many_trials.mat'));
str = 'pink_ev';
m = load('../reval_calc/output_data/delta_vals_optim_pink_ev.mat');


%%

p = publish_plot(1,3);


p.next();
edges = linspace(-0.8,0.8,31);
edges2 = [edges,inf];
y = histc(m.delta_v_opt,edges2);
y = y(1:end-1);
dedges = edges(2)-edges(1);
x = edges + dedges/2;
h = bar(x,y);
set(h,'facecolor',0.7*[1,1,1],'edgecolor','k','BarWidth',1);
set(gca,'xtick',-0.8:0.4:0.8);
xtl = get(gca,'xticklabel');
% xtl(end) = {'>0.5'};
set(gca,'xticklabel',xtl,'tickdir','out');
hold all
plot([0,0],ylim,'k--');
xlabel('\delta [$]');
ylabel('# of participants');

p.next();

plot(m.dev_opt, m.dev_opt_bwards,'o','markerfacecolor',0.7*[1,1,1],'markeredgecolor','k','LineStyle','none');
axis square
same_xylim(gca);
hold all
xli = xlim;
plot(xli,xli,'k--');
borde_en_axis('color','k');
xlabel('Deviance (Forward Reval)');
ylabel('Deviance (Backwards Reval)');

[h,pval] = ttest(m.dev_opt - m.dev_opt_bwards);

p.text_draw(p.current_ax(),['p = ',num2str(pval)]);
p.shrink(1,1,0.9);

p.next();

dv_re = diff(m.values_re_opt,[],2);
dv = diff(mdat.values,[],2);

idx = index_prctile_by_group(abs(dv),[0,50,100],mdat.group);
idx_re = index_prctile_by_group(abs(dv_re),[0,50,100],mdat.group);

[~,drt] = curva_media_hierarch(mdat.rt,idx,mdat.group,[],0);
[~,drt_re] = curva_media_hierarch(mdat.rt,idx_re,mdat.group,~isnan(idx_re),0);

p.shrink(3,0.6,.9);

diff_drt = -1* diff(drt);
diff_drt_re = -1* diff(drt_re);
plot([1,2],[diff_drt',diff_drt_re'],'.-','color',0.4*[1,1,1],'linewidth',2,'markersize',10);
axis tight
ylabel('RT_{difficult} - RT_{easy} [s]')
set(gca,'xtick',[1,2],'xticklabel',{'Explicit','Reval'});

[~,pval] = ttest(diff_drt,diff_drt_re,'tail','left');

p.offset_axes(3);

p.bracket_on_top(3,['p=',num2str(pval,2)],'font_size',10);

p.text_draw_fig(str);


p.format('FontSize',10,'LineWidthPlot',0.5);


p.append_to_pdf('fig_pink_sim',1);

%%
load ../data/prepro_data.mat

dv = diff(mdat.values,[],2);
xvals = get_xvals_for_plot(dv);

p = publish_plot(2,1);
p.displace_ax(2,0.1,2);
set(gcf,'Position',[556  375  216  437]);
p.next();

av_over_subj_flag = 0;

if av_over_subj_flag
    [tt,xx] = curva_media_hierarch(nanmean(mmany.choices,2),xvals,mmany.group,[],0);
    ss = stderror(xx,2);
    xx = nanmean(xx,2);
else
    [tt,xx,ss] = curva_media(nanmean(mmany.choices,2), xvals,[],0);
end
niceBars2(tt,xx,ss,'r',0.3);

hold all
if av_over_subj_flag
    [tt,xx] = curva_media_hierarch(dat.choices, xvals,dat.group,[],0);
    ss = stderror(xx,2);
    xx = nanmean(xx,2);
else
    [tt,xx,ss] = curva_media(dat.choices, xvals,[],0);
end
terrorbar(tt,xx,ss,'color',0.6*[1,1,1],'marker','o','LineStyle','none','markerfacecolor',0.6*[1,1,1,]);


ylabel('Proportion rightward choices');

p.next();


if av_over_subj_flag
    [tt,xx] = curva_media_hierarch(nanmean(mmany.rt,2),xvals,mmany.group,[],0);
    ss = stderror(xx,2);
    xx = nanmean(xx,2);
else
    [tt,xx,ss] = curva_media(nanmean(mmany.rt,2), xvals,[],0);
end
niceBars2(tt,xx,ss,'r',0.3);
hold all

if av_over_subj_flag
    [tt,xx] = curva_media_hierarch(dat.rt, xvals,dat.group,[],0);
    ss = stderror(xx,2);
    xx = nanmean(xx,2);
else
    [tt,xx,ss] = curva_media(dat.rt, xvals,[],0);
end
terrorbar(tt,xx,ss,'color',0.6*[1,1,1],'marker','o','LineStyle','none','markerfacecolor',0.6*[1,1,1,]);


p.unlabel_center_plots();
ylabel('Response time [s]');
xlabel({'Value difference','(right - left)'});
p.format('FontSize',10);

