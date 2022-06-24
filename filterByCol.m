function res = filterByCol(app, col, value, type)
    res = [];
    cols = app.UITable.ColumnName';
    data = app.UITable.Data;
    %Find column
    for i = 1:width(cols)
        if strcmp(strtrim(cols{1,i}), col)
            numCol = i;
        end
    end
    switch type
        case '='
            for i = 1:height(data)
                if isa(data{i, numCol}, 'double')
                    if data{i, numCol} == str2double(value)
                        row = data(i, [1:end]);
                        res = [res; row];
                    end 
                else
                    if contains(string(data{i, numCol}), string(value))
                        row = data(i, [1:end]);
                        res = [res; row];
                    end
                end
            end
        case '>'
            for i = 1:height(data)
                if data{i, numCol} > str2double(value)
                    row = data(i, [1:end]);
                    res = [res; row];
                end
            end
        case '<'
            for i = 1:height(data)
                if data{i, numCol} < str2double(value)
                    row = data(i, [1:end]);
                    res = [res; row];
                end
            end
        otherwise
            disp('other value')
    end
end