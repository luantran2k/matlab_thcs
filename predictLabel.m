function [label,score,cost,testdt] = predictLabel(app,path)
label = [];
score = [];
cost = [];
testdt = [];
if isfile('ProductModel.mat')
    ProductModel = loadLearnerForCoder('ProductModel.mat');
    testdt = readtable(path,"Sheet", "San_pham",'VariableNamingRule','preserve');
    tb = table2array(testdt(:,3:end));
    [label,score,cost] = predict(ProductModel,tb);
else
    uialert(app.UIFigure,'Chưa có file model, hãy huấn luyện trước','Lỗi');
    return;
end
end
