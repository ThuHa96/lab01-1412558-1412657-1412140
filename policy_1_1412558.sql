/* role: chỉ trưởng phòng mới được cập nhật và thêm thông tin vào dự án DAC*/
create role truongphong_role;
grant insert, update on DUAN to truongphong_role;