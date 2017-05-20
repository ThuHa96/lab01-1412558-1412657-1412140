-- Chỉ trưởng phòng được phép cập nhật và thêm thông tin vào dự án (DAC).
grant insert, update on DUAN to R_TRUONGPHONG;

begin
for TRUONGPB_LIST in (select TRUONGPHONG from HCMUS.PHONGBAN)
loop
  execute immediate 'grant R_TRUONGPHONG to ' || TRUONGPB_LIST.TRUONGPHONG; 
end loop;
end;