function res = findByCol(app, col, value)
res = [];
cols = app.UITable.ColumnName';
data = app.UITable.Data;
%Find column
for i = 1:width(cols)
    if strcmp(strtrim(cols{1,i}), col)
        numCol = i;
    end
end
for i = 1:height(data)
    if contains(string(data{i, numCol}), string(value))
        row = data(i, [1:end]);
        res = [res; row];
    end
end
end