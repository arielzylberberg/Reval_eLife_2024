Ms = load('../DDM_fit/out/dat_plot_alltogether_explicit.mat');
Md = load('../DDM_fit/out/dat_plot_alltogether_dynamic_reeval.mat');



%%
p = publish_plot(2,1);

p.displace_ax(1,-0.08,2);
p.displace_ax(1:2,0.1,2);
set(gcf,'Position',[751  142  336  635])


colors = movshon_colors(3);
cs = 'r';
cd = 'k';

p.next();

plot(Ms.choice.model.ucoh,Ms.choice.model.pup,'color',cs,'linewidth',2,'LineStyle','-');
hold all
plot(Md.choice.model.ucoh,Md.choice.model.pup,'color',cd,'linewidth',2);

h(1) = terrorbar(Ms.choice.data.tt,Ms.choice.data.xx,Ms.choice.data.ss,'color',cs,'marker','o','linestyle','none','markersize',10,'linewidth',1.5,'markerfacecolor',cs);
h(2) = terrorbar(Md.choice.data.tt,Md.choice.data.xx,Md.choice.data.ss,'color',cd,'marker','o','linestyle','none','markersize',10,'linewidth',1.5,'markerfacecolor',cd);

ylabel('Proportion rightward choices')

hl = legend('static','dynamic');
set(hl,'location','best');

p.next();

plot(Ms.rt.model.ucoh,Ms.rt.model.pup,'color',cs,'linewidth',2,'LineStyle','-');
hold all
plot(Md.rt.model.ucoh,Md.rt.model.pup,'color',cd,'linewidth',2);

terrorbar(Ms.rt.data.tt,Ms.rt.data.xx,Ms.rt.data.ss,'color',cs,'marker','o','linestyle','none','markersize',10,'linewidth',1.5,'markerfacecolor',cs);
terrorbar(Md.rt.data.tt,Md.rt.data.xx,Md.rt.data.ss,'color',cd,'marker','o','linestyle','none','markersize',10,'linewidth',1.5,'markerfacecolor',cd);


xlabel({'Value difference', '(\Delta v_s or \Delta v_d)','(right - left)'})
ylabel('Response time (s)')


xli = 3;
set(p.h_ax,'xlim',[-xli,xli]);
set(p.h_ax(2),'ylim',[0.9,1.5]);

set(p.h_ax(1),'xticklabel','');
p.format('FontSize',18,'MarkerSize',5,'LineWidthPlot',1.0,'LineWidthAxes',0.5);

p.append_to_pdf('./out/fig_for_paper_both_models_altogether');