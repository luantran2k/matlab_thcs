clear;clc;
prompt = {'Luong_ban','Khoang_cach_tb(km)','Thoi_gian_giao_tb(ngay)','So_luong_hoan','So_luong_loi','So_don_hang','Gia_1_sp(vnd)'};
dlgtitle = 'Dự đoán đơn hàng';
dims = [1 35;1 35;1 35;1 35;1 35;1 35;1 35];
definput = {'10','100','3','0','0','8','100000'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
if isfile('ProductModel.mat')
    ProductModel = loadLearnerForCoder('ProductModel.mat');
    [label,score,cost] = predict(ProductModel,str2double(answer)');
else
    uialert(app.UIFigure,'Chưa có file model, hãy huấn luyện trước','Lỗi');
    return;
end