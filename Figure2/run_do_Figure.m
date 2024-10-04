addpath('../functions/');

clear
%%


do_save_fig = 1;


files = {'from_reg_crossvalid_simulated.mat','from_reg_crossvalid.mat'};
load ../data/prepro_data.mat
%remove repeats
I = dat.num_app_pair==1;
rt = dat.rt(I);
values = dat.values(I,:);
group = dat.group(I);
trials = dat.trials(I,:);
choices = dat.choices(I);



p = publish_plot(1,2);
set(gcf,'Position',[457  643  896  326])

% colores = [0,0,0; 1,0,0];
colores = [1,0,0; 0,0,0];

h = [];
for i=1:length(files)


    load(files{i});
    %     a = pright_cross_from_BDM(:).*choices+(1-pright_cross_from_BDM(:)).*(1-choices);
    %     b = pright_cross_from_choices(:).*choices+(1-pright_cross_from_choices(:)).*(1-choices);
    a = p_leftoutchoice_from_BDM;
    b = p_leftoutchoice_from_choices;

    p.next();
    % likelihood
    [~,bb] = curva_suma(log(b),group,[],0);
    [~,aa] = curva_suma(log(a),group,[],0);

    h(i) = plot(aa,bb,'o','markersize',8,'markerfacecolor',colores(i,:)*0.3+[1,1,1]*0.7,'markeredgecolor',colores(i,:),'markersize',10);
    hold all

    p.next();

    [~,bb] = curva_media(b,group,[],0);
    [~,aa] = curva_media(a,group,[],0);

    h(i) = plot(aa,bb,'o','markersize',8,'markerfacecolor',colores(i,:)*0.3+[1,1,1]*0.7,'markeredgecolor',colores(i,:),'markersize',10);
    hold all


end

same_xylim(p.h_ax)
for i=1:2
    p.current_ax(i);
    plot(xlim,xlim,'k--');

end

p.current_ax(2);
xlabel({'Prob. of cynosure choices','(from explicit values)'});
ylabel({'Prob. of cynosure choices','(from other choices)'});

p.current_ax(1);
xlabel({'Log-likelihood of cynosure choices','(from explicit values)'});
ylabel({'Log-likelihood of cynosure choices','(from other choices)'});
% hl = legend(h,'simulated choices','data');
% set(hl,'location','best','box','on');

p.format('FontSize',14,'LineWidthAxes',1,'MarkerSize',10);


if do_save_fig
    p.append_to_pdf('fig_crossvalid',1,1);
end
