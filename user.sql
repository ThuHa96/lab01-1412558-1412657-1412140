alter session set "_ORACLE_SCRIPT"=true;
CREATE USER HCMUS IDENTIFIED BY HCMUS;
GRANT DBA, RESOURCE TO HCMUS WITH ADMIN OPTION;
GRANT CREATE SESSION TO HCMUS;
GRANT ALL PRIVILEGES TO HCMUS;
GRANT EXEMPT ACCESS POLICY TO HCMUS;

-- LOGIN AS HCMUS
--Tạo user từ mã nhân viên
declare
  TEMP varchar2(200);
begin
for MANV in (select MANV from NHANVIEN)
loop
  TEMP := 'create user ' || MANV.MANV || ' identified by ' || MANV.MANV || ' default tablespace users temporary tablespace temp';
  execute immediate TEMP;
end loop;
end;     

-- Cấp quyền đăng nhập và tọa session
declare
  TEMP varchar2(500);
begin
for USERNAME in (select MANV from NHANVIEN)
loop
  TEMP := 'grant create session to ' || USERNAME.MANV;
  execute immediate TEMP;
end loop;
end;

-- xóa tất cả nhân viên
/*
declare
  TEMP varchar2(200);
begin
for USERNAME in (select MANV from NHANVIEN)
loop
  temp := 'drop user ' || USERNAME.MANV;
  execute immediate TEMP;
end loop;
end; 
*/
/* tạo các role cơ bản*/
create role R_GIAMDOC;
create role R_TRUONGPHONG;
create role R_TRUONGCHINHANH;
create role R_TRUONGDUAN;
create role R_NHANVIEN;