load from_fits

s = RandStream('mt19937ar','Seed',123);

nsamples = 26;
nchains = 100000;

nsuj = 30;
rho = nan(nsuj,nsamples);
for i = 1:nsuj

    [tconst,B0,dt,kappa,ndt_m,ndt_s] = deal_as_python(theta(i,:));

    std_sampling = sqrt(dt)/tconst;
    proprnd = @(x) x + randn(s,nchains,1)*std_sampling;

    

    t = [1:nsamples]-1;
    t = t * dt;

    v = [0,0]';
    xini = repmat(v,1,nchains)*kappa*dt;

    pdf_left  = @(x) normpdf(x,v(1)*kappa*dt,sqrt(dt));
    pdf_right = @(x) normpdf(x,v(2)*kappa*dt,sqrt(dt));

    xleft  = squeeze(mhsample(xini(1,:)',nsamples,'pdf',pdf_left,'proprnd',proprnd,'symmetric',1,'nchain',nchains))';
    xright = squeeze(mhsample(xini(2,:)',nsamples,'pdf',pdf_right,'proprnd',proprnd,'symmetric',1,'nchain',nchains))';

    x = xright - xleft;

    for j=1:nsamples
        rho(i,j) = corr(x(:,1),x(:,j));
    end
    
end

%%
p = publish_plot(1,1);
set(gcf,'Position',[584  559  346  326]);
plot(t,rho,'color',0.7*[1,1,1]);
hold all
p.format('LineWidthPlot',0.5);
ylabel('\rho');
xlabel('Time [s]');
p.append_to_pdf('fig_rho',1);

[mean(rho(:,end)), stderror(mean(rho(:,end)))]
