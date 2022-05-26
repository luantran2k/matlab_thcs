function copySampleTrainData(path)
    data = readtable("SampleTrainData.xlsx","Sheet",1,'VariableNamingRule','preserve');
    writetable(data,path,"Sheet","Train_data");
end