function getProductData(path)
data = readtable(path,"Sheet", "Don_hang",'PreserveVariableNames',true);
thong_tin_sp = readtable(path,"Sheet", "Thong_tin_sp",'PreserveVariableNames',true);
Luong_ban = struct();
Khoang_cach = struct();
Thoi_gian_giao = struct();
So_luong_hoan = struct();
So_luong_loi = struct();
So_don_hang = struct();
Ten_sp = struct();
Gia_tien_1_sp = struct();

for i = 1:height(thong_tin_sp)
    Ten_sp.(string(thong_tin_sp{i,1})) = thong_tin_sp{i,2};
    Gia_tien_1_sp.(string(thong_tin_sp{i,1})) = thong_tin_sp{i,3};
end

for i = 1:height(data)
    if(isfield(Luong_ban,string(data{i,7})))
        Luong_ban.(string(data{i,7})) = Luong_ban.(string(data{i,7})) + data{i,8};
        Khoang_cach.(string(data{i,7})) = Khoang_cach.(string(data{i,7})) + data{i,9};
        Thoi_gian_giao.(string(data{i,7})) = Thoi_gian_giao.(string(data{i,7})) + data{i,10};
        So_luong_hoan.(string(data{i,7})) = So_luong_hoan.(string(data{i,7})) + data{i,11};
        So_luong_loi.(string(data{i,7})) = So_luong_loi.(string(data{i,7})) + data{i,12};
        So_don_hang.(string(data{i,7})) = So_don_hang.(string(data{i,7})) + 1;
    else
        Luong_ban.(string(data{i,7})) = data{i,8};
        Khoang_cach.(string(data{i,7})) = data{i,9};
        Thoi_gian_giao.(string(data{i,7})) = data{i,10};
        So_luong_hoan.(string(data{i,7})) = data{i,11};
        So_luong_loi.(string(data{i,7})) = data{i,12};
        So_don_hang.(string(data{i,7})) =  1;
    end
end

res = [];
%fn = fieldnames(Luong_ban);
for i = 1:height(fieldnames(Luong_ban))
    Ma_sp = string(thong_tin_sp{i,1});
    if isfield(Luong_ban,Ma_sp)
        res = [res;{Ma_sp,Ten_sp.(Ma_sp),Luong_ban.(Ma_sp),floor(Khoang_cach.(Ma_sp)/So_don_hang.(Ma_sp)),floor(Thoi_gian_giao.(Ma_sp)/So_don_hang.(Ma_sp)),So_luong_hoan.(Ma_sp),So_luong_loi.(Ma_sp),So_don_hang.(Ma_sp),Gia_tien_1_sp.(Ma_sp)}];
    end
end

tb = array2table(res,'VariableNames',["Ma_sp","Ten_sp","Luong_ban","Khoang_cach_tb(km)","Thoi_gian_giao_tb(ngay)","So_luong_hoan","So_luong_loi","So_don_hang","Gia_tien_1_sp"]);
[~, ~, Raw]=xlsread(path, "San_pham");
[Raw{:, :}]=deal(NaN);
xlswrite(path, Raw, "San_pham");
writetable(tb,path,"Sheet","San_pham");
end