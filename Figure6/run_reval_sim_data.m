

R = load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');
NR = load('../reval_calc/output_data/delta_vals_optim_per_suj_sampled_logistic.mat');


%% 
p = publish_plot(1,2);
set(gcf,'Position',[314  490  804  263]);


p.next();
a = R.delta_v_opt;
b =  R.delta_v_opt_fake;

h(1) = histogram(a);
hold on
h(2) = histogram(b);
set(h,'binwidth',0.02);

set(h(1),'FaceColor',0.8*[1,1,1],'edgecolor','k','LineWidth',0.5);
set(h(2),'FaceColor',[250,208,208]/255,'edgecolor','r','LineWidth',0.5);

ylabel('# of participants');
xlabel('Best \delta [$]');

xlim([-0.5,0.5]);
set(gca,'xtick',-0.5:0.25:0.5);


p.next();
a = R.dev_opt;
b =  R.dev_noreev_persuj';
plot(a,b,'ko','markerfacecolor',0.8*[1,1,1]);

hold on

a = NR.dev_opt;
b =  NR.dev_noreev_persuj';
plot(a,b,'o','color','r','markerfacecolor',[250,208,208]/255);
same_xylim(gca);
axis square

h = refline(1,0);
set(h,'color',0.7*[1,1,1]);
hold on
plot(xlim,[0,0],'k--');
plot([0,0],ylim,'k--');
xlabel('Deviance (Reval)')
ylabel('Deviance (No Reval)');
axis square


p.format('FontSize',15,'LineWidthPlot',0.5); 





