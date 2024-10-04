function [y, ind_prctile, ybin, meanX_of_prctile] =  index_prctile(X,p)
%parecido a prctile, pero devuelve tambien el indice del percentil al que
%pertence cada observacion
%ej: [y, ind_prctile, ybin, meanX_of_prctile] =  index_prctile(x,[0:10:100])
%incluir el 0 y el 100
%ybin remplaza inds for el valor medio del y en el bin

y = prctile(X,p);

ind_prctile = nan(size(X));
ybin        = nan(size(X));
ny = length(y);
for i=2:ny
    ind = X<=y(i) & X>=y(i-1) & isnan(ind_prctile);% before may2017
    ind_prctile(ind) = i-1;
    ybin(ind) = nanmean(X(ind));
end

% sanity check
if length(nanunique(ind_prctile))<(length(p)-1)
    error('too many percentiles for the data; cannot assign unique values')
end

% promedio los valores de X en las categories de ind_prctile
J = ~isnan(ind_prctile);
[~,val] = curva_media(X,ind_prctile,J,0);
meanX_of_prctile = nan(size(ind_prctile));
meanX_of_prctile(J) = index_to_val(ind_prctile(J),val);

