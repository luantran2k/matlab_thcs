x = readtable("MainData.xlsx","Sheet", "Revenue expenditures");
d = x.Properties.VariableDescriptions;
years = 2019;
res = [];
for i = 1:height(x)
    if contains(x{i,1},string(years))
        res = [res; x{i,2}];
    end
end
bar(res);