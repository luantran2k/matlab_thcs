function [label,score,cost,testdt] = trainModelKnn(app,path);
data = readtable(path,"Sheet","Train_data",'VariableNamingRule','preserve');
if height(data) < 30
    uialert(app.UIFigure,'Train data cần ít nhất 20 mẫu, chép mẫu có sẵn hoặc gán nhãn thủ công','Lỗi');
    label = [];
    score = [];  
    cost = [];
    testdt = [];
    return;
end
X2 = data(:,(1:7));
Y2 = data(:,(8));
X2 = X2{:,:};
Y2 = Y2{:,:};
mdl2 = fitcknn(X2,Y2,'NumNeighbors',5,'Standardize',1);
testdt = readtable(path,"Sheet", "San_pham",'VariableNamingRule','preserve');
tb = table2array(testdt(:,3:end));
[label,score,cost] = predict(mdl2,tb);
end
