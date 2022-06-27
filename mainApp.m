classdef main < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        TabGroup                 matlab.ui.container.TabGroup
        HomeTab                  matlab.ui.container.Tab
        DatePanel                matlab.ui.container.Panel
        DateFilterButton         matlab.ui.control.Button
        toDatePicker             matlab.ui.control.DatePicker
        toLabel                  matlab.ui.control.Label
        FromDatePicker           matlab.ui.control.DatePicker
        FromLabel                matlab.ui.control.Label
        DropDownCompare          matlab.ui.control.DropDown
        GetProductDataButton     matlab.ui.control.Button
        MakePatternFileButton    matlab.ui.control.Button
        FilterButton             matlab.ui.control.Button
        ResetButton_2            matlab.ui.control.Button
        ExportTableButton        matlab.ui.control.Button
        ValueEditField           matlab.ui.control.EditField
        ValueLabel               matlab.ui.control.Label
        ColumnDropDown_2         matlab.ui.control.DropDown
        ColumnLabel              matlab.ui.control.Label
        RownumberEditField       matlab.ui.control.NumericEditField
        RownumberLabel           matlab.ui.control.Label
        DeleterowButton          matlab.ui.control.Button
        SheetDropDownLabel       matlab.ui.control.Label
        SheetDropDown            matlab.ui.control.DropDown
        PathEditFieldLabel       matlab.ui.control.Label
        PathEditField            matlab.ui.control.EditField
        AddRowButton             matlab.ui.control.Button
        SaveDataButton           matlab.ui.control.Button
        ReadDataButton           matlab.ui.control.Button
        ChoosefileButton         matlab.ui.control.Button
        UITable                  matlab.ui.control.Table
        VisualizationTab         matlab.ui.container.Tab
        FigureSwitch             matlab.ui.control.Switch
        FigureSwitchLabel        matlab.ui.control.Label
        TypeChartDropDown        matlab.ui.control.DropDown
        TypeDropDownLabel        matlab.ui.control.Label
        YearEditField            matlab.ui.control.EditField
        YearEditFieldLabel       matlab.ui.control.Label
        ResetButton              matlab.ui.control.Button
        VisualizeButton          matlab.ui.control.Button
        ColumnDropDown           matlab.ui.control.DropDown
        ColumnDropDownLabel      matlab.ui.control.Label
        UIAxes                   matlab.ui.control.UIAxes
        AnalysisTab              matlab.ui.container.Tab
        Accuracy                 matlab.ui.control.Label
        TrainModelButton         matlab.ui.control.Button
        ExportTableButton_2      matlab.ui.control.Button
        SavetoTrain_dataButton   matlab.ui.control.Button
        AssignLabelButton        matlab.ui.control.Button
        PredictNewProductButton  matlab.ui.control.Button
        AnalyzeButton            matlab.ui.control.Button
        UITable2                 matlab.ui.control.Table
    end

    properties (Access = public)
        tempTable % Description
    end

    methods (Access = private)

        function [newPath, isFileExist] = checkFile(app,path)
            newPath = strrep(path,'\','/');
            isFileExist = true;
            if ~contains(newPath,'.xlsx')
                newPath = string(newPath) + '.xlsx';
            end
            if isempty(path)
                isFileExist = false;
                uialert(app.UIFigure,'Không được bỏ trống','Lỗi');
                %if file does'nt exist.
            elseif ~isfile(newPath)
                isFileExist = false;
                uialert(app.UIFigure,'File không hợp lệ','Lỗi');
            end
        end

        function readData(app, path)
            %Tab home
            sheet = app.SheetDropDown.Value;
            data = readtable(path,"Sheet", sheet,'PreserveVariableNames',true);
            app.UITable.ColumnName = data.Properties.VariableNames;
            app.UITable.Data = data;
            app.UITable.RowName= 'numbered';
            setEditable(app);
            app.tempTable = app.UITable.Data;

            %Tab visualizaiton
            data_doanh_thu = readtable(path,"Sheet", "Doanh_thu");
            cols_doanh_thu = data_doanh_thu.Properties.VariableNames;
            cols_doanh_thu = cols_doanh_thu(2:end);
            app.ColumnDropDown.Items = cols_doanh_thu';
        end

        function saveData(app)
            path = app.PathEditField.Value;
            sheet = app.SheetDropDown.Value;
            [newPath, isFileExist] = checkFile(app,path);
            if ~isFileExist
                uialert(app.UIFigure,'Lỗi','Không được bỏ trống');
            else
                %clearExcelSheet(app, path, sheet);
                data = app.UITable.Data;
                writetable(data,newPath,"Sheet",sheet,'WriteMode',"overwritesheet");
                uialert(app.UIFigure,'Lưu thành công','Thông báo',"Icon",'success');
            end
        end

        function displayData(app)
            path = app.PathEditField.Value;
            [newPath, isFileExist] = checkFile(app,path);
            if isFileExist
                [~,sheets] = xlsfinfo(newPath);
                app.SheetDropDown.Items = sheets;
                readData(app, newPath);
                app.ColumnDropDown_2.Items = app.UITable.ColumnName';
                setCompare(app,app.ColumnDropDown_2.Value);
                setDatePanel(app);
            end
        end

        function setEditable(app)
            % Set Editable
            ncols = size(app.UITable.Data,2);
            app.UITable.ColumnEditable = true(1,ncols);%all columns editable
        end

        function clearExcelSheet(~,path,sheet)
            [~, ~, Raw]=xlsread(path, sheet);
            [Raw{:, :}]=deal(NaN);
            xlswrite(path, Raw, sheet);
        end


        %{
        function path = getDesktopPath(app)
            [~, userdir] = system('echo %USERPROFILE%');
            path = userdir + '\Desktop';
        end
        %}

        function setCompare(app,value)
            isColNumber = ["So_luong_ban" "Khoang_cach_giao(km)" "Thoi_gian_giao(ngay)" "So_luong_hoan" "So_luong_loi"...
                "Luong_ban" "Khoang_cach_tb(km)" "Thoi_gian_giao_tb(ngay)" "So_don_hang" "Gia_tien_1_sp"...
                "Gia_1_sp"...
                "So_luong_don" "Doanh_thu" "Tong_chi" "Loi_nhuan"];
            if ismember(value,isColNumber)
                app.DropDownCompare.Items = ["=" ">" "<"];
            else
                app.DropDownCompare.Items = ("=");
            end
        end

        function setDatePanel(app)
            DateCol = ["Ngay_dat" "Ngay_giao"];
            if ismember(app.ColumnDropDown_2.Value,DateCol)
                app.DatePanel.Visible = 'on';
            else
                app.DatePanel.Visible = 'off';
            end
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %app.PathEditField.Value = 'D:\Code\Mathlab\MainApp\MainData.xlsx';
        end

        % Callback function: ReadDataButton, SheetDropDown
        function ReadDataButtonPushed(app, event)
            displayData(app);
        end

        % Value changed function: PathEditField
        function PathEditFieldValueChanged(app, event)
            displayData(app);
        end

        % Button pushed function: SaveDataButton
        function SaveDataButtonPushed(app, event)
            saveData(app);
        end

        % Callback function
        function AddColumnButtonPushed(app, event)
            data = app.UITable.Data;
            colName = app.ColNameEditField.Value;
            if strcmp(colName, "")
                uialert(app.UIFigure,'Chưa có tên cột','Lỗi');
                return;
            end
            app.UITable.Data = [data num2cell(zeros(1,height(data))')];
            app.UITable.ColumnName{width(data) + 1} = colName;
            setEditable(app);
        end

        % Button pushed function: ChoosefileButton
        function ChoosefileButtonPushed(app, event)
            [file,path] = uigetfile('*.xlsx');
            figure(app.UIFigure);
            if file ~= 0
                app.PathEditField.Value = append(path, file);
                displayData(app);
            end
        end

        % Button pushed function: AddRowButton
        function AddRowButtonPushed(app, event)
            data = app.UITable.Data;
            t = cell(1, width(app.UITable.Data));
            for i = 1:width(app.UITable.Data)
                t{i} = "";
            end
            app.UITable.Data = [data; t];
        end

        % Button pushed function: DeleterowButton
        function DeleterowButtonPushed(app, event)
            numberRow = app.RownumberEditField.Value;
            if numberRow > 0
                app.UITable.Data(numberRow,:) = [];
            end
        end

        % Callback function: FigureSwitch, VisualizeButton
        function VisualizeButtonPushed(app, event)
            visualizeData(app);
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            y = zeros(1,12);
            bar(y,'Parent',app.UIAxes,"FaceColor",'flat');
        end

        % Button pushed function: ExportTableButton
        function ExportTableButtonPushed(app, event)
            [filename, path] = uiputfile('.xlsx');
            figure(app.UIFigure);
            if filename ~= 0
                data = app.UITable.Data;
                writetable(data,path + "/" +filename,'Sheet',1);
            end
        end

        % Button pushed function: ResetButton_2
        function ResetButton_2Pushed(app, event)
            app.UITable.Data = app.tempTable;
        end

        % Button pushed function: FilterButton
        function FilterButtonPushed(app, event)
            value = app.ValueEditField.Value;
            col = app.ColumnDropDown_2.Value;
            type = app.DropDownCompare.Value;
            if strcmp(value,"")
                uialert(app.UIFigure,'Giá trị không được bỏ trống','Lỗi');
                return;
            end
            app.UITable.Data = filterByCol(app, col,value,type);
        end

        % Button pushed function: MakePatternFileButton
        function MakePatternFileButtonPushed(app, event)
            [filename, path] = uiputfile('.xlsx');
            if (filename ~= 0)
                figure(app.UIFigure);
                makePatternFile(path+"/"+filename);
            end
        end

        % Button pushed function: AnalyzeButton
        function AnalyzeButtonPushed(app, event)
            path = app.PathEditField.Value;
            [label,~,~,testData] = predictLabel(app,path);
            if ~isempty(label)
                app.UITable2.Data = table2cell([testData label]);
                app.UITable2.ColumnName = testData.Properties.VariableNames';
                app.UITable2.ColumnName{10} = "Danh_gia";
                app.UITable2.ColumnEditable(10) = true;
                app.UITable2.ColumnFormat{10} = {'Tot' 'Kha' 'Te'};
                app.Accuracy.Text = "Accuracy: " + num2str(evaluateModel()) + "%";
            end
        end

        % Button pushed function: GetProductDataButton
        function GetProductDataButtonPushed(app, event)
            path = app.PathEditField.Value;
            if isempty(path)
                uialert(app.UIFigure,'Đường dẫn trống','Lỗi');
            else
                getProductData(path);
                uialert(app.UIFigure,'Lấy thành công dữ liệu','Thông báo',"Icon",'success');
                displayData(app);
            end
        end

        % Button pushed function: PredictNewProductButton
        function PredictNewProductButtonPushed(app, event)
            prompt = {'Luong_ban','Khoang_cach_tb(km)','Thoi_gian_giao_tb(ngay)','So_luong_hoan','So_luong_loi','So_don_hang','Gia_1_sp(vnd)'};
            dlgtitle = 'Dự đoán đơn hàng';
            dims = [1 35;1 35;1 35;1 35;1 35;1 35;1 35];
            definput = {'10','100','3','0','0','8','100000'};
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            if isfile('ProductModel.mat')
                ProductModel = loadLearnerForCoder('ProductModel.mat');
                try
                    [label,~,~] = predict(ProductModel,str2double(answer)');
                    msgbox('Sản phẩm này được đánh giá: ' + string(label),'Kết quả');
                catch ME

                end
            else
                uialert(app.UIFigure,'Chưa có file model, hãy huấn luyện trước','Lỗi');
                return;
            end
        end

        % Button pushed function: SavetoTrain_dataButton
        function SavetoTrain_dataButtonPushed(app, event)
            T = app.UITable2.Data;
            columnName = get(app.UITable2,'columnname');
            res = cell2table(T,"VariableNames",columnName');
            path = app.PathEditField.Value;
            if width(res) == 10
                data = res(:,3:10);
            else
                data = res;
                if any(strcmp(table2cell(data(:,8)),'Choose'))
                    uialert(app.UIFigure,'Cần gán nhãn tất cả dữ liệu','Lỗi');
                    return;
                end
            end
            writetable(data,path,"Sheet","Train_data","WriteMode","Append");
            uialert(app.UIFigure,'Lưu thành công','Thông báo',"Icon",'success');
        end

        % Button pushed function: AssignLabelButton
        function AssignLabelButtonPushed(app, event)
            path = app.PathEditField.Value;
            data = readtable(path,"Sheet", "San_pham",'PreserveVariableNames',true);
            res = cell2table(cell(20:1));
            for i = 1:20
                randomNum = randi([1 height(data)],1,7);
                row = [data(randomNum(1),3),data(randomNum(2),4),data(randomNum(3),5),data(randomNum(4),6),data(randomNum(5),7),data(randomNum(6),8),data(randomNum(7),9)];
                res(i,:) = row;
            end
            newcol = repmat({'Choose'},height(res),1);
            app.UITable2.Data = table2cell([res newcol]);
            app.UITable2.ColumnName = res.Properties.VariableNames';
            app.UITable2.ColumnName{8} = "Danh_gia";
            app.UITable2.ColumnEditable(8) = true;
            app.UITable2.ColumnFormat{8} = {'Tot' 'Kha' 'Te'};
        end

        % Button pushed function: ExportTableButton_2
        function ExportTableButton_2Pushed(app, event)
            [filename, path] = uiputfile('.xlsx');
            figure(app.UIFigure);
            if filename ~= 0
                T = app.UITable2.Data;
                columnName = get(app.UITable2,'columnname');
                data = cell2table(T,"VariableNames",columnName');
                writetable(data,path + "/" +filename,'Sheet',1);
            end
        end

        % Value changed function: ColumnDropDown_2
        function ColumnDropDown_2ValueChanged(app, event)
            value = app.ColumnDropDown_2.Value;
            setCompare(app,value);
            setDatePanel(app)
        end

        % Button pushed function: DateFilterButton
        function DateFilterButtonPushed(app, event)
            res = [];
            col = app.ColumnDropDown_2.Value;
            cols = app.UITable.ColumnName';
            data = app.UITable.Data;
            fromDate = app.FromDatePicker.Value;
            toDate = app.toDatePicker.Value;
            if toDate < fromDate
                uialert(app.UIFigure,'Ngày bắt đầu phải lớn hơn ngày kết thúc','Lỗi');
                return;
            end

            %Find column
            for i = 1:width(cols)
                if strcmp(strtrim(cols{1,i}), col)
                    numCol = i;
                end
            end
            for i = 1:height(data)
                if data{i, numCol} >= fromDate && data{i, numCol} <= toDate
                    row = data(i, :);
                    res = [res; row];
                end
            end
            app.UITable.Data = res;
        end

        % Value changed function: TypeChartDropDown
        function TypeChartDropDownValueChanged(app, event)
            visualizeData(app);
        end

        % Button pushed function: TrainModelButton
        function TrainModelButtonPushed(app, event)
            path = app.PathEditField.Value;
            data = readtable(path,"Sheet","Train_data",'VariableNamingRule','preserve');
            if height(data) < 20
                answer = questdlg('Train data cần ít nhất 20 mẫu, chép mẫu có sẵn hoặc gán nhãn thủ công. Bạn có muốn sử dụng dữ liệu mẫu không','Lỗi','Yes','No','No');
                % Handle response
                try
                    if strcmp(answer,'Yes')
                        copySampleTrainData(app.PathEditField.Value);
                        uialert(app.UIFigure,'Lấy thành công dữ liệu','Thông báo',"Icon",'success');
                    end
                catch
                    uialert(app.UIFigure,'Lấy không thành công dữ liệu, đóng các ứng dụng đang sử dụng file dữ liệu'...
                        ,'Lỗi');
                end
                return;
            end
            X = data(:,(1:7));
            Y = data(:,(8));
            X = X{:,:};
            Y = Y{:,:};
            ProductModel = fitcknn(X,Y,'NumNeighbors',5,'Standardize',1);
            saveLearnerForCoder(ProductModel,'ProductModel');
            uialert(app.UIFigure,'Huấn luyện thành công','Thông báo',"Icon",'success');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9412 0.9412 0.9412];
            app.UIFigure.Position = [100 100 792 624];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [0 1 792 624];

            % Create HomeTab
            app.HomeTab = uitab(app.TabGroup);
            app.HomeTab.Title = 'Home';
            app.HomeTab.BackgroundColor = [0.9098 0.9608 1];
            app.HomeTab.ForegroundColor = [0.0902 0.3882 0.6706];

            % Create UITable
            app.UITable = uitable(app.HomeTab);
            app.UITable.BackgroundColor = [1 1 1;0.9412 0.9412 0.9412];
            app.UITable.ColumnName = '';
            app.UITable.RowName = {'1'};
            app.UITable.ForegroundColor = [0.2 0.2 0.2];
            app.UITable.Position = [61 171 658 331];

            % Create ChoosefileButton
            app.ChoosefileButton = uibutton(app.HomeTab, 'push');
            app.ChoosefileButton.ButtonPushedFcn = createCallbackFcn(app, @ChoosefileButtonPushed, true);
            app.ChoosefileButton.BackgroundColor = [0.0902 0.3882 0.6706];
            app.ChoosefileButton.FontWeight = 'bold';
            app.ChoosefileButton.FontColor = [1 1 1];
            app.ChoosefileButton.Position = [618 542 100 22];
            app.ChoosefileButton.Text = 'Choose file';

            % Create ReadDataButton
            app.ReadDataButton = uibutton(app.HomeTab, 'push');
            app.ReadDataButton.ButtonPushedFcn = createCallbackFcn(app, @ReadDataButtonPushed, true);
            app.ReadDataButton.IconAlignment = 'center';
            app.ReadDataButton.BackgroundColor = [1 1 1];
            app.ReadDataButton.FontWeight = 'bold';
            app.ReadDataButton.FontColor = [0.0902 0.3882 0.6706];
            app.ReadDataButton.Position = [395 510 100 22];
            app.ReadDataButton.Text = 'Read Data';

            % Create SaveDataButton
            app.SaveDataButton = uibutton(app.HomeTab, 'push');
            app.SaveDataButton.ButtonPushedFcn = createCallbackFcn(app, @SaveDataButtonPushed, true);
            app.SaveDataButton.BackgroundColor = [1 1 1];
            app.SaveDataButton.FontWeight = 'bold';
            app.SaveDataButton.FontColor = [0.0902 0.3882 0.6706];
            app.SaveDataButton.Position = [503 510 108 22];
            app.SaveDataButton.Text = 'Save Data';

            % Create AddRowButton
            app.AddRowButton = uibutton(app.HomeTab, 'push');
            app.AddRowButton.ButtonPushedFcn = createCallbackFcn(app, @AddRowButtonPushed, true);
            app.AddRowButton.IconAlignment = 'center';
            app.AddRowButton.BackgroundColor = [1 1 1];
            app.AddRowButton.FontWeight = 'bold';
            app.AddRowButton.FontColor = [0.0902 0.3882 0.6706];
            app.AddRowButton.Position = [378 135 100 22];
            app.AddRowButton.Text = 'Add Row';

            % Create PathEditField
            app.PathEditField = uieditfield(app.HomeTab, 'text');
            app.PathEditField.ValueChangedFcn = createCallbackFcn(app, @PathEditFieldValueChanged, true);
            app.PathEditField.FontColor = [0.0902 0.3882 0.6706];
            app.PathEditField.Position = [119 542 376 22];

            % Create PathEditFieldLabel
            app.PathEditFieldLabel = uilabel(app.HomeTab);
            app.PathEditFieldLabel.HorizontalAlignment = 'right';
            app.PathEditFieldLabel.FontWeight = 'bold';
            app.PathEditFieldLabel.FontColor = [0.0902 0.3882 0.6706];
            app.PathEditFieldLabel.Position = [63 542 35 22];
            app.PathEditFieldLabel.Text = 'Path:';

            % Create SheetDropDown
            app.SheetDropDown = uidropdown(app.HomeTab);
            app.SheetDropDown.Items = {};
            app.SheetDropDown.ValueChangedFcn = createCallbackFcn(app, @ReadDataButtonPushed, true);
            app.SheetDropDown.FontColor = [0.0902 0.3882 0.6706];
            app.SheetDropDown.BackgroundColor = [1 1 1];
            app.SheetDropDown.Position = [120 510 268 22];
            app.SheetDropDown.Value = {};

            % Create SheetDropDownLabel
            app.SheetDropDownLabel = uilabel(app.HomeTab);
            app.SheetDropDownLabel.HorizontalAlignment = 'right';
            app.SheetDropDownLabel.FontWeight = 'bold';
            app.SheetDropDownLabel.FontColor = [0.0902 0.3882 0.6706];
            app.SheetDropDownLabel.Position = [63 510 42 22];
            app.SheetDropDownLabel.Text = 'Sheet:';

            % Create DeleterowButton
            app.DeleterowButton = uibutton(app.HomeTab, 'push');
            app.DeleterowButton.ButtonPushedFcn = createCallbackFcn(app, @DeleterowButtonPushed, true);
            app.DeleterowButton.BackgroundColor = [1 1 1];
            app.DeleterowButton.FontWeight = 'bold';
            app.DeleterowButton.FontColor = [0.0902 0.3882 0.6706];
            app.DeleterowButton.Position = [267 135 100 22];
            app.DeleterowButton.Text = 'Delete row';

            % Create RownumberLabel
            app.RownumberLabel = uilabel(app.HomeTab);
            app.RownumberLabel.HorizontalAlignment = 'right';
            app.RownumberLabel.FontWeight = 'bold';
            app.RownumberLabel.FontColor = [0.0902 0.3882 0.6706];
            app.RownumberLabel.Position = [61 135 82 22];
            app.RownumberLabel.Text = 'Row number:';

            % Create RownumberEditField
            app.RownumberEditField = uieditfield(app.HomeTab, 'numeric');
            app.RownumberEditField.FontColor = [0.0902 0.3882 0.6706];
            app.RownumberEditField.Position = [151 135 100 22];
            app.RownumberEditField.Value = 1;

            % Create ColumnLabel
            app.ColumnLabel = uilabel(app.HomeTab);
            app.ColumnLabel.HorizontalAlignment = 'right';
            app.ColumnLabel.FontWeight = 'bold';
            app.ColumnLabel.FontColor = [0.0902 0.3882 0.6706];
            app.ColumnLabel.Position = [61 88 54 22];
            app.ColumnLabel.Text = 'Column:';

            % Create ColumnDropDown_2
            app.ColumnDropDown_2 = uidropdown(app.HomeTab);
            app.ColumnDropDown_2.Items = {};
            app.ColumnDropDown_2.ValueChangedFcn = createCallbackFcn(app, @ColumnDropDown_2ValueChanged, true);
            app.ColumnDropDown_2.FontColor = [0.0902 0.3882 0.6706];
            app.ColumnDropDown_2.BackgroundColor = [1 1 1];
            app.ColumnDropDown_2.Position = [119 88 131 22];
            app.ColumnDropDown_2.Value = {};

            % Create ValueLabel
            app.ValueLabel = uilabel(app.HomeTab);
            app.ValueLabel.HorizontalAlignment = 'right';
            app.ValueLabel.FontWeight = 'bold';
            app.ValueLabel.FontColor = [0.0902 0.3882 0.6706];
            app.ValueLabel.Position = [261 88 41 22];
            app.ValueLabel.Text = 'Value:';

            % Create ValueEditField
            app.ValueEditField = uieditfield(app.HomeTab, 'text');
            app.ValueEditField.FontColor = [0.0902 0.3882 0.6706];
            app.ValueEditField.Position = [305 88 173 22];

            % Create ExportTableButton
            app.ExportTableButton = uibutton(app.HomeTab, 'push');
            app.ExportTableButton.ButtonPushedFcn = createCallbackFcn(app, @ExportTableButtonPushed, true);
            app.ExportTableButton.BackgroundColor = [1 1 1];
            app.ExportTableButton.FontWeight = 'bold';
            app.ExportTableButton.FontColor = [0.0902 0.3882 0.6706];
            app.ExportTableButton.Position = [618 510 99 22];
            app.ExportTableButton.Text = 'Export Table';

            % Create ResetButton_2
            app.ResetButton_2 = uibutton(app.HomeTab, 'push');
            app.ResetButton_2.ButtonPushedFcn = createCallbackFcn(app, @ResetButton_2Pushed, true);
            app.ResetButton_2.BackgroundColor = [1 1 1];
            app.ResetButton_2.FontWeight = 'bold';
            app.ResetButton_2.FontColor = [0.0902 0.3882 0.6706];
            app.ResetButton_2.Position = [622 88 67 22];
            app.ResetButton_2.Text = 'Reset';

            % Create FilterButton
            app.FilterButton = uibutton(app.HomeTab, 'push');
            app.FilterButton.ButtonPushedFcn = createCallbackFcn(app, @FilterButtonPushed, true);
            app.FilterButton.BackgroundColor = [0.0902 0.3882 0.6706];
            app.FilterButton.FontWeight = 'bold';
            app.FilterButton.FontColor = [1 1 1];
            app.FilterButton.Position = [550 88 66 22];
            app.FilterButton.Text = 'Filter';

            % Create MakePatternFileButton
            app.MakePatternFileButton = uibutton(app.HomeTab, 'push');
            app.MakePatternFileButton.ButtonPushedFcn = createCallbackFcn(app, @MakePatternFileButtonPushed, true);
            app.MakePatternFileButton.BackgroundColor = [1 1 1];
            app.MakePatternFileButton.FontWeight = 'bold';
            app.MakePatternFileButton.FontColor = [0.0902 0.3882 0.6706];
            app.MakePatternFileButton.Position = [503 542 108 22];
            app.MakePatternFileButton.Text = 'MakePatternFile';

            % Create GetProductDataButton
            app.GetProductDataButton = uibutton(app.HomeTab, 'push');
            app.GetProductDataButton.ButtonPushedFcn = createCallbackFcn(app, @GetProductDataButtonPushed, true);
            app.GetProductDataButton.BackgroundColor = [1 1 1];
            app.GetProductDataButton.FontWeight = 'bold';
            app.GetProductDataButton.FontColor = [0.0902 0.3882 0.6706];
            app.GetProductDataButton.Position = [490 135 107 22];
            app.GetProductDataButton.Text = 'GetProductData';

            % Create DropDownCompare
            app.DropDownCompare = uidropdown(app.HomeTab);
            app.DropDownCompare.Items = {};
            app.DropDownCompare.FontColor = [0.0902 0.3882 0.6706];
            app.DropDownCompare.BackgroundColor = [1 1 1];
            app.DropDownCompare.Position = [490 88 50 22];
            app.DropDownCompare.Value = {};

            % Create DatePanel
            app.DatePanel = uipanel(app.HomeTab);
            app.DatePanel.BorderType = 'none';
            app.DatePanel.Visible = 'off';
            app.DatePanel.BackgroundColor = [0.9098 0.9608 1];
            app.DatePanel.Position = [61 35 480 30];

            % Create FromLabel
            app.FromLabel = uilabel(app.DatePanel);
            app.FromLabel.HorizontalAlignment = 'right';
            app.FromLabel.FontWeight = 'bold';
            app.FromLabel.FontColor = [0.0902 0.3882 0.6706];
            app.FromLabel.Position = [-1 5 39 22];
            app.FromLabel.Text = 'From:';

            % Create FromDatePicker
            app.FromDatePicker = uidatepicker(app.DatePanel);
            app.FromDatePicker.FontColor = [0.0902 0.3882 0.6706];
            app.FromDatePicker.Position = [53 5 121 22];

            % Create toLabel
            app.toLabel = uilabel(app.DatePanel);
            app.toLabel.HorizontalAlignment = 'right';
            app.toLabel.FontWeight = 'bold';
            app.toLabel.FontColor = [0.0902 0.3882 0.6706];
            app.toLabel.Position = [185 4 25 22];
            app.toLabel.Text = 'to';

            % Create toDatePicker
            app.toDatePicker = uidatepicker(app.DatePanel);
            app.toDatePicker.FontColor = [0.0902 0.3882 0.6706];
            app.toDatePicker.Position = [225 4 126 22];

            % Create DateFilterButton
            app.DateFilterButton = uibutton(app.DatePanel, 'push');
            app.DateFilterButton.ButtonPushedFcn = createCallbackFcn(app, @DateFilterButtonPushed, true);
            app.DateFilterButton.BackgroundColor = [1 1 1];
            app.DateFilterButton.FontWeight = 'bold';
            app.DateFilterButton.FontColor = [0.0902 0.3882 0.6706];
            app.DateFilterButton.Position = [373 5 100 22];
            app.DateFilterButton.Text = 'DateFilter';

            % Create VisualizationTab
            app.VisualizationTab = uitab(app.TabGroup);
            app.VisualizationTab.Title = 'Visualization';
            app.VisualizationTab.BackgroundColor = [0.9098 0.9608 1];
            app.VisualizationTab.ForegroundColor = [0.0902 0.3882 0.6706];

            % Create UIAxes
            app.UIAxes = uiaxes(app.VisualizationTab);
            title(app.UIAxes, 'Year')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XColor = [0.0902 0.3882 0.6706];
            app.UIAxes.YColor = [0.0902 0.3882 0.6706];
            app.UIAxes.ZColor = [0.0902 0.3882 0.6706];
            app.UIAxes.Position = [61 184 675 374];

            % Create ColumnDropDownLabel
            app.ColumnDropDownLabel = uilabel(app.VisualizationTab);
            app.ColumnDropDownLabel.HorizontalAlignment = 'right';
            app.ColumnDropDownLabel.FontWeight = 'bold';
            app.ColumnDropDownLabel.FontColor = [0.0902 0.3882 0.6706];
            app.ColumnDropDownLabel.Position = [213 135 50 22];
            app.ColumnDropDownLabel.Text = 'Column';

            % Create ColumnDropDown
            app.ColumnDropDown = uidropdown(app.VisualizationTab);
            app.ColumnDropDown.Items = {};
            app.ColumnDropDown.FontColor = [0.0902 0.3882 0.6706];
            app.ColumnDropDown.BackgroundColor = [1 1 1];
            app.ColumnDropDown.Position = [276 135 100 22];
            app.ColumnDropDown.Value = {};

            % Create VisualizeButton
            app.VisualizeButton = uibutton(app.VisualizationTab, 'push');
            app.VisualizeButton.ButtonPushedFcn = createCallbackFcn(app, @VisualizeButtonPushed, true);
            app.VisualizeButton.BackgroundColor = [0.0902 0.3882 0.6706];
            app.VisualizeButton.FontWeight = 'bold';
            app.VisualizeButton.FontColor = [1 1 1];
            app.VisualizeButton.Position = [421 135 100 22];
            app.VisualizeButton.Text = 'Visualize';

            % Create ResetButton
            app.ResetButton = uibutton(app.VisualizationTab, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.BackgroundColor = [1 1 1];
            app.ResetButton.FontWeight = 'bold';
            app.ResetButton.FontColor = [0.0902 0.3882 0.6706];
            app.ResetButton.Position = [420 78 100 22];
            app.ResetButton.Text = 'Reset';

            % Create YearEditFieldLabel
            app.YearEditFieldLabel = uilabel(app.VisualizationTab);
            app.YearEditFieldLabel.HorizontalAlignment = 'right';
            app.YearEditFieldLabel.FontWeight = 'bold';
            app.YearEditFieldLabel.FontColor = [0.0902 0.3882 0.6706];
            app.YearEditFieldLabel.Position = [54 135 31 22];
            app.YearEditFieldLabel.Text = 'Year';

            % Create YearEditField
            app.YearEditField = uieditfield(app.VisualizationTab, 'text');
            app.YearEditField.FontColor = [0.0902 0.3882 0.6706];
            app.YearEditField.Position = [100 135 100 22];

            % Create TypeDropDownLabel
            app.TypeDropDownLabel = uilabel(app.VisualizationTab);
            app.TypeDropDownLabel.HorizontalAlignment = 'right';
            app.TypeDropDownLabel.FontWeight = 'bold';
            app.TypeDropDownLabel.FontColor = [0.0902 0.3882 0.6706];
            app.TypeDropDownLabel.Position = [60 79 32 22];
            app.TypeDropDownLabel.Text = 'Type';

            % Create TypeChartDropDown
            app.TypeChartDropDown = uidropdown(app.VisualizationTab);
            app.TypeChartDropDown.Items = {'bar_1', 'bar_2', 'barh_1', 'barh_2', 'line'};
            app.TypeChartDropDown.ValueChangedFcn = createCallbackFcn(app, @TypeChartDropDownValueChanged, true);
            app.TypeChartDropDown.FontColor = [0.0902 0.3882 0.6706];
            app.TypeChartDropDown.BackgroundColor = [1 1 1];
            app.TypeChartDropDown.Position = [101 79 99 22];
            app.TypeChartDropDown.Value = 'bar_1';

            % Create FigureSwitchLabel
            app.FigureSwitchLabel = uilabel(app.VisualizationTab);
            app.FigureSwitchLabel.HorizontalAlignment = 'center';
            app.FigureSwitchLabel.FontWeight = 'bold';
            app.FigureSwitchLabel.FontColor = [0.0902 0.3882 0.6706];
            app.FigureSwitchLabel.Position = [213 78 42 22];
            app.FigureSwitchLabel.Text = 'Figure';

            % Create FigureSwitch
            app.FigureSwitch = uiswitch(app.VisualizationTab, 'slider');
            app.FigureSwitch.ValueChangedFcn = createCallbackFcn(app, @VisualizeButtonPushed, true);
            app.FigureSwitch.FontWeight = 'bold';
            app.FigureSwitch.FontColor = [0.0902 0.3882 0.6706];
            app.FigureSwitch.Position = [289 79 45 20];

            % Create AnalysisTab
            app.AnalysisTab = uitab(app.TabGroup);
            app.AnalysisTab.Title = 'Analysis';
            app.AnalysisTab.BackgroundColor = [0.9098 0.9608 1];
            app.AnalysisTab.ForegroundColor = [0.0902 0.3882 0.6706];

            % Create UITable2
            app.UITable2 = uitable(app.AnalysisTab);
            app.UITable2.BackgroundColor = [1 1 1;0.9412 0.9412 0.9412];
            app.UITable2.ColumnName = '';
            app.UITable2.RowName = {};
            app.UITable2.ForegroundColor = [0.2 0.2 0.2];
            app.UITable2.Position = [45 132 701 411];

            % Create AnalyzeButton
            app.AnalyzeButton = uibutton(app.AnalysisTab, 'push');
            app.AnalyzeButton.ButtonPushedFcn = createCallbackFcn(app, @AnalyzeButtonPushed, true);
            app.AnalyzeButton.IconAlignment = 'center';
            app.AnalyzeButton.BackgroundColor = [0.0902 0.3882 0.6706];
            app.AnalyzeButton.FontWeight = 'bold';
            app.AnalyzeButton.FontColor = [1 1 1];
            app.AnalyzeButton.Position = [55 79 122 22];
            app.AnalyzeButton.Text = 'Analyze';

            % Create PredictNewProductButton
            app.PredictNewProductButton = uibutton(app.AnalysisTab, 'push');
            app.PredictNewProductButton.ButtonPushedFcn = createCallbackFcn(app, @PredictNewProductButtonPushed, true);
            app.PredictNewProductButton.IconAlignment = 'center';
            app.PredictNewProductButton.BackgroundColor = [1 1 1];
            app.PredictNewProductButton.FontWeight = 'bold';
            app.PredictNewProductButton.FontColor = [0.0902 0.3882 0.6706];
            app.PredictNewProductButton.Position = [205 79 123 22];
            app.PredictNewProductButton.Text = 'PredictNewProduct';

            % Create AssignLabelButton
            app.AssignLabelButton = uibutton(app.AnalysisTab, 'push');
            app.AssignLabelButton.ButtonPushedFcn = createCallbackFcn(app, @AssignLabelButtonPushed, true);
            app.AssignLabelButton.IconAlignment = 'center';
            app.AssignLabelButton.BackgroundColor = [1 1 1];
            app.AssignLabelButton.FontWeight = 'bold';
            app.AssignLabelButton.FontColor = [0.0902 0.3882 0.6706];
            app.AssignLabelButton.Position = [350 79 122 22];
            app.AssignLabelButton.Text = 'Assign Label';

            % Create SavetoTrain_dataButton
            app.SavetoTrain_dataButton = uibutton(app.AnalysisTab, 'push');
            app.SavetoTrain_dataButton.ButtonPushedFcn = createCallbackFcn(app, @SavetoTrain_dataButtonPushed, true);
            app.SavetoTrain_dataButton.IconAlignment = 'center';
            app.SavetoTrain_dataButton.BackgroundColor = [1 1 1];
            app.SavetoTrain_dataButton.FontWeight = 'bold';
            app.SavetoTrain_dataButton.FontColor = [0.0902 0.3882 0.6706];
            app.SavetoTrain_dataButton.Position = [205 43 122 22];
            app.SavetoTrain_dataButton.Text = 'Save to Train_data';

            % Create ExportTableButton_2
            app.ExportTableButton_2 = uibutton(app.AnalysisTab, 'push');
            app.ExportTableButton_2.ButtonPushedFcn = createCallbackFcn(app, @ExportTableButton_2Pushed, true);
            app.ExportTableButton_2.IconAlignment = 'center';
            app.ExportTableButton_2.BackgroundColor = [1 1 1];
            app.ExportTableButton_2.FontWeight = 'bold';
            app.ExportTableButton_2.FontColor = [0.0902 0.3882 0.6706];
            app.ExportTableButton_2.Position = [350 41 122 22];
            app.ExportTableButton_2.Text = 'Export Table';

            % Create TrainModelButton
            app.TrainModelButton = uibutton(app.AnalysisTab, 'push');
            app.TrainModelButton.ButtonPushedFcn = createCallbackFcn(app, @TrainModelButtonPushed, true);
            app.TrainModelButton.IconAlignment = 'center';
            app.TrainModelButton.BackgroundColor = [1 1 1];
            app.TrainModelButton.FontWeight = 'bold';
            app.TrainModelButton.FontColor = [0.0902 0.3882 0.6706];
            app.TrainModelButton.Position = [54 41 123 22];
            app.TrainModelButton.Text = 'TrainModel';

            % Create Accuracy
            app.Accuracy = uilabel(app.AnalysisTab);
            app.Accuracy.FontSize = 14;
            app.Accuracy.FontWeight = 'bold';
            app.Accuracy.FontColor = [0.0902 0.3882 0.6706];
            app.Accuracy.Position = [562 88 184 22];
            app.Accuracy.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end