function [ind_prctile, meanX_of_prctile] = index_prctile_by_group(X,p,group)

% unique of rows if group is not 1D
if ~isvector(group)
    if size(group,1)~=length(X)
        error('sizes dont match');
    end
    [~,~,group] = unique(group,'rows');
end


uni_group = nanunique(group);

n = length(uni_group);
ind_prctile = nan(size(X));
meanX_of_prctile = nan(size(X));
for i=1:n
    I = group==uni_group(i);
    [~, ind_prctile(I)] =  index_prctile(X(I),p);
end

J = ~isnan(ind_prctile);
[~,val] = curva_media(X,ind_prctile,J,0);
meanX_of_prctile = nan(size(ind_prctile));
meanX_of_prctile(J) = index_to_val(ind_prctile(J),val);

end