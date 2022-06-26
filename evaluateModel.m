function accuracy = evaluateModel()
    ProductModel = loadLearnerForCoder('ProductModel.mat');
    testdt = readtable("TestData.xlsx",'VariableNamingRule','preserve');
    tb = table2array(testdt(:,1:7));
    originalClass = table2array(testdt(:,8));
    [label,~,~] = predict(ProductModel,tb);
    accuracy = sum(string(label(:,1)) == string(originalClass)) / numel(string(label(:,1)));
    accuracy = accuracy*100;
end

