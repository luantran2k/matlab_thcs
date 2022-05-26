function makePatternFile(path)
Don_hang = ["Ma_don","Ngay_dat","Ngay_giao","Ten_kh","Dia_chi","So_dien_thoai","Ma_sp","So_luong_ban","Khoang_cach_giao(km)","Thoi_gian _giao(ngay)","So_luong_hoan","So_luong_loi"];
San_pham = ["Ma_sp","Ten_sp","Luong_ban","Khoang_cach_tb(km)","Thoi_gian_giao_tb(ngay)","So_luong_hoan","So_luong_loi","So_don_hang","Gia_1_sp"];
Thong_tin_sp = ["Ma_sp","Ten sp","Gia_1_sp"];
Doanh_thu = ["Thang","So_luong_don","Doanh_thu","Tong_chi","Loi_nhuan"];
Train_data = ["Luong_ban","Khoang_cach_tb(km)","Thoi_gian_giao_tb(ngay)","So_luong_hoan","So_luong_loi","So_don_hang","Gia_1_sp","Danhgia"];
writematrix(Don_hang,path,"Sheet","Don_hang");
writematrix(San_pham,path,"Sheet","San_pham");
writematrix(Thong_tin_sp,path,"Sheet","Thong_tin_sp");
writematrix(Doanh_thu,path,"Sheet","Doanh_thu");
writematrix(Train_data,path,"Sheet","Train_data");
end