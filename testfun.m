clear;
clc;
path = "MainData.xlsx";
col = "Doanh_thu";
data = readtable(path,"Sheet", "Doanh_thu");
cols = data.Properties.VariableNames;
res = struct();

fMonth = char(data{1,1});
lMonth = char(data{height(data),1});
fYear = str2double(fMonth(1:4));
lYear = str2double(lMonth(1:4));
for i = fYear:lYear
    res.("y"+i) = [];
end


colNumber = find(ismember( cols, col ));

for i = 1:height(data)
    key = "y" + extractBetween(data{i,1},1,4);
    res.(key) = [res.(key); {data{i,1},data{i,colNumber}}];
end

fn = fieldnames(res);
resFinal = [];
for i = 1:height(fn)
    if height(res.(fn{i})) > 0
        startMonth = extractBetween(string(res.(fn{i}){1}),6,7);
        endMonth = extractBetween(string(res.(fn{i}){height(res.(fn{i}))}),6,7);
        resFinal = [resFinal; [zeros(1,str2double(startMonth) - 1),cell2mat(res.(fn{i})(:,2)'),zeros(1,12 - str2double(endMonth))]];
    end
end
%startMonth = extractBetween(string(res{1}),6,7);
%startMonth = extractBetween(string(res{1}),6,7);
%resFinal = [zeros(1,str2double(startMonth) - 1),cell2mat(res(:,2)')];