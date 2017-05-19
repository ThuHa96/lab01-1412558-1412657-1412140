/* ROLE CƠ BẢN */
alter session set "_ORACLE_SCRIPT"=true;
create role r_giamdoc;
create role r_truongphong;
create role r_truongchinhanh;
create role r_truongduan;
create role r_nhanvien;

-- gán quyền cho r_nhanvien
-- được quyền connect (login db), truy xuất bảng nhân viên qua V_NHANVIEN
grant connect to r_nhanvien;
grant select on HCMUS.V_NHANVIEN to r_nhanvien;
-- gán r_nhanvien cho mọi user trong hệ thống
grant r_nhanvien to public;
