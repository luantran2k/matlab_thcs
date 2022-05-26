function saveToTrain(app,path)
    data = app.UITable2.Data;
    writetable(data,path,"Sheet","Train_data","WriteMode","Append");
end