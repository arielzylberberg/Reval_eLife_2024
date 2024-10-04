load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');
load('../data/prepro_data.mat');

%%

p = publish_plot(1,1);
set(gcf,'Position',[429  284  520  342]);

v_image_num = [23,25,20];

colores = movshon_colors(3);
for i=1:length(v_image_num)
    I = [dat.group==1,dat.group==1] & dat.trials==v_image_num(i);
    
    n = dat.num_app_item(I);
    v = values_re_opt(I);
    
    [~,idx] = sort(n);
    
    x = n(idx);
    y = v(idx);
    x = [x;x(end)+1] - 0.5;
    y = [y;y(end)];
    hold all
    stairs(x,y,'LineWidth',2,'color',colores(i,:));
end
set(gca,'xtick',1:7);

xlabel('Presentation number');
ylabel('Reval value');


p.format('LineWidthAxes',1);

%%
v_delta = linspace(0,0.7,200);
isuj = 1;
v = dat.v(:,isuj);
I = dat.group==isuj;
for i=1:length(v_delta)
    delta = v_delta(i);
    dev(i) = fn_reval(delta, v,dat.choices(I),dat.trials(I,:),dat.group(I));
end
[~,idx] = min(dev);
x = v_delta(idx);

p = publish_plot(1,1);
plot(v_delta,dev,'LineWidth',4);
hold on
yli = ylim;
start = [x, yli(1)+diff(yli)*0.1];
stop = [x, yli(1)];
h = arrow(start,stop);
set(h,'LineWidth',2);

string = ['$',num2str(redondear(x,2))];
text(x + 0.01,yli(1)+diff(yli)*0.02,string,'VerticalAlignment','bottom','HorizontalAlignment','left');

xlabel('\delta [$]');
ylabel('Deviance');
p.format('FontSize',22,'LineWidthAxes',1)
xlim([min(v_delta),max(v_delta)]);




