function string_to_eval = fields_to_vars(var_name,stru)

f = fields(stru);
string_to_eval = [];

for i=1:length(f)
    str = [f{i},' = ',var_name,'.',f{i},';'];
    string_to_eval = [string_to_eval str];
end