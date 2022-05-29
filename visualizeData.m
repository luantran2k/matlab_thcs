function visualizeData(app)
if isempty(app.YearEditField.Value)
    uialert(app.UIFigure,'Không được để trống năm','Lỗi');
    return;
end

path = app.PathEditField.Value;
col = app.ColumnDropDown.Value;
data = readtable(path,"Sheet", "Doanh_thu");
cols = data.Properties.VariableNames;
type = app.TypeChartDropDown.Value;
res = struct();
years = split(app.YearEditField.Value,',')';
for i = 1:width(years)
    res.("y"+years(i)) = [];
end


colNumber = find(ismember( cols, col ));

for i = 1:height(data)
    if find(ismember(years,extractBetween(data{i,1},1,4)))
        key = "y" + extractBetween(data{i,1},1,4);
        res.(key) = [res.(key); {data{i,1},data{i,colNumber}}];
    end
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
switch type
    case 'bar_1'
        b = bar(app.UIAxes,resFinal');
        xlabel(app.UIAxes, 'Thang');
        ylabel(app.UIAxes, replace(col,'_', ' '));
    case 'bar_2'
        b = bar(app.UIAxes,resFinal','stacked');
        xlabel(app.UIAxes, 'Thang');
        ylabel(app.UIAxes, replace(col,'_', ' '));
    case 'barh_1'
        b = barh(app.UIAxes,resFinal');
        ylabel(app.UIAxes, 'Thang');
        xlabel(app.UIAxes, replace(col,'_', ' '));
    case 'barh_2'
        b = barh(app.UIAxes,resFinal','stacked');
        ylabel(app.UIAxes, 'Thang');
        xlabel(app.UIAxes, replace(col,'_', ' '));
    case 'line'
        b = plot(app.UIAxes,resFinal');
        xlabel(app.UIAxes, 'Thang');
        ylabel(app.UIAxes, replace(col,'_', ' '));
        app.FigureSwitch.Value = 'Off';
    otherwise
        b = bar(app.UIAxes,resFinal');
        xlabel(app.UIAxes, 'Thang');
        ylabel(app.UIAxes, replace(col,'_', ' '));
end
title(app.UIAxes,replace(col,'_', ' ') + " Nam: " + app.YearEditField.Value);
%axis(app.UIAxes, 'padded');
legend(app.UIAxes,years);

if strcmp(app.FigureSwitch.Value,'On')
    if strcmp(type,'bar_1') || strcmp(type,'bar_2')
        for i = 1: width(years)
            xtips = b(i).XEndPoints;
            ytips= b(i).YEndPoints;
            labels = string(b(i).YData);
            text(app.UIAxes,xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
        end
    elseif strcmp(type,'barh_1') || strcmp(type,'barh_2')
        for i = 1: width(years)
            xtips = b(i).XEndPoints;
            ytips= b(i).YEndPoints;
            labels = string(b(i).YData);
            text(app.UIAxes,ytips,xtips,labels,'HorizontalAlignment','center','VerticalAlignment','middle')
        end
    end
end