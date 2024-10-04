function [logl,out] = wrapper_dtb_pink_evidence(theta,v,values,trials,choices,rt,seed,plotflag,isuj,only_choice, nchains)

% rng(seed,'twister');

if isempty(seed) || isnan(seed)
    seed = rand*intmax;
    s = RandStream('mt19937ar','Seed',seed);
else
    s = RandStream('mt19937ar','Seed',seed);
end
RandStream.setGlobalStream(s);


if nargin<11 || isempty(nchains)
    nchains = 1000;
end


vini = repmat(v,[1,nchains]);

tconst = theta(1);
B0 = theta(2);
dt = theta(3);
kappa = theta(4);
if ~only_choice
    ndt_m = theta(5);
    ndt_s = theta(6);
end
nsamples = round(7/dt); %max 7 seconds

ntr = length(choices);
ch_model = nan(ntr,1);
rt_model = nan(ntr,1);

std_sampling = sqrt(dt)/tconst;
proprnd = @(x) x + randn(s,nchains,1)*std_sampling;

w = nan(ntr,1);
for itr = 1:ntr
    
    tr = trials(itr,:);
    xini = vini(tr,:)*kappa*dt;
    
    pdf_left  = @(x) normpdf(x,v(tr(1))*kappa*dt,sqrt(dt));
    pdf_right = @(x) normpdf(x,v(tr(2))*kappa*dt,sqrt(dt));
    
    xleft  = squeeze(mhsample(xini(1,:)',nsamples,'pdf',pdf_left,'proprnd',proprnd,'symmetric',1,'nchain',nchains))';
    xright = squeeze(mhsample(xini(2,:)',nsamples,'pdf',pdf_right,'proprnd',proprnd,'symmetric',1,'nchain',nchains))';
    
    x = xright - xleft;
    
    %     plot(x(1,:));
    %     pause
    %     clf
    
    Bup = ones(1,nsamples)*B0;
    % collpase at the end
    Bup(end) = 1*10-8;
    Blo = -1*Bup;
    [choice_model,dec_sample_model] = boundcross(x,Bup,Blo);
    
    dec_sample_model(isnan(dec_sample_model)) = nsamples-1;  %hack for now; just a large value
    dec_time_model = dec_sample_model*dt;
    
    if ~only_choice
        pp = double(choice_model==choices(itr)).*normpdf(rt(itr),dec_time_model + ndt_m, ndt_s);
    else
        pp = double(choice_model==choices(itr));
    end
    w(itr) = nanmean(pp);
    pp(pp==0) = eps;
    
    
    r = randsample(s,1:nchains,nchains,true,pp);
    
    K = sub2ind(size(xleft),1:nchains,ceil(dec_sample_model)');
    
    vini(tr,:) = [xleft(K(r)); xright(K(r))]/(kappa*dt);
    
    ch_model(itr) = nanmean(choice_model);
    if ~only_choice
        rt_model(itr) = nanmean(dec_time_model(choice_model==choices(itr))) + ndt_m;
    end
end

w(w==0) = eps;
logl = -sum(log(w));


%%
out.choice = ch_model;
out.RT = rt_model;


%% print
if only_choice
    fprintf('err=%.3f, tconst=%.2f, B0=%.2f,  dt=%.2f, kappa=%.2f \n',...
        logl , theta(1), theta(2), theta(3), theta(4));
else
    fprintf('err=%.3f, tconst=%.2f, B0=%.2f,  dt=%.2f, kappa=%.2f, ndt_m=%.2f, mdt_s=%.2f \n',...
        logl , theta(1), theta(2), theta(3), theta(4), theta(5), theta(6));
end
%%
if (plotflag)
    [~,~,~,vi] = index_prctile(diff(values,[],2)+randn(s,ntr,1)*0.00001,[0:10:100]);
    figure(1)
    clf
    if only_choice
        curva_media(choices,vi,[],1);
        hold all
        curva_media(ch_model,vi,[],1);
        
    else
        subplot(1,2,1)
        curva_media(choices,vi,[],1);
        hold all
        curva_media(ch_model,vi,[],1);
        
        subplot(1,2,2)
        curva_media(rt,vi,[],1);
        hold all
        curva_media(rt_model,vi,[],1);
    end
    drawnow
    saveas(gcf,['fig_' num2str(isuj) '.jpg']);
end

end




