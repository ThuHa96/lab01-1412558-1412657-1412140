--Tất cả nhân viên bình thường (trừ trưởng phòng, trưởng chi nhánh và các trưởng dự án) 
--chỉ được phép xem thông tin nhân viên trong phòng của mình, chỉ được xem lương của bản thân (VPD). (**MSSV**)ậ
--tạo package SET_NHANVIEN_CTX_PKG

create or replace package SET_NHANVIEN_CTX_PKG
as
    procedure SET_PHONGBAN;
    procedure CHECK_TRUONGPHONG;
    procedure CHECK_TRUONGCHINHANH;
    procedure CHECK_TRUONGDUAN;
end;

--tạo context NHANVIEN_CTX
CREATE OR REPLACE CONTEXT NHANVIEN_CTX USING SET_NHANVIEN_CTX_PKG;
-- nội dung pkg

create or replace package body SET_NHANVIEN_CTX_PKG
as
  procedure SET_PHONGBAN
  as PHONGBAN varchar2(5);
  begin
    select MAPHONG into PHONGBAN from HCMUS.NHANVIEN where MANV = sys_context('userenv', 'session_user');
    dbms_session.set_context('NHANVIEN_CTX', 'PHONGBAN', PHONGBAN);
  end;
  
  procedure CHECK_TRUONGPHONG
  as ISTRUONGPB varchar2(5);
  begin
    select case 
        when exists(select MAPHONG  from HCMUS.PHONGBAN where TRUONGPHONG = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into ISTRUONGPB
    from dual;
    dbms_session.set_context('NHANVIEN_CTX', 'ISTRUONGPB', ISTRUONGPB);
  end;
  
  procedure CHECK_TRUONGCHINHANH
  as ISTRUONGCN varchar2(5);
  begin
    select case 
        when exists(select MACN  from HCMUS.CHINHANH where TRUONGCHINHANH = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into ISTRUONGCN
    from dual;
    dbms_session.set_context('NHANVIEN_CTX', 'ISTRUONGCN', ISTRUONGCN);
  end;
  
  procedure CHECK_TRUONGDUAN
  as ISTRUONGDA varchar2(5);
  begin
    select case 
        when exists(select MADA  from HCMUS.DUAN where TRUONGDA = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into ISTRUONGDA
    from dual;
    dbms_session.set_context('NHANVIEN_CTX', 'ISTRUONGDA', ISTRUONGDA);
  end;
end;

--tạo logon trigger cho package
create or replace trigger set_NHANVIEN_CTX_TRIGGER after logon on database
begin
    HCMUS.SET_NHANVIEN_CTX_PKG.SET_PHONGBAN;
    HCMUS.SET_NHANVIEN_CTX_PKG.CHECK_TRUONGPHONG;
    HCMUS.SET_NHANVIEN_CTX_PKG.CHECK_TRUONGCHINHANH;
    HCMUS.SET_NHANVIEN_CTX_PKG.CHECK_TRUONGDUAN;
end;

--Xem nhân viên chung phòng với nhân viên đã login
create or replace function FUNCTION_XEM_NHANVIEN_CHUNGPHONG(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  PHONGBAN varchar2(5);
  TEMP varchar2(100);
begin
  if sys_context('userenv', 'SESSION_USER') = 'HCMUS' or sys_context('userenv', 'ISDBA') = 'TRUE' or sys_context('NHANVIEN_CTX', 'ISTRUONGPB') = 'TRUE' 
  or sys_context('NHANVIEN_CTX', 'ISTRUONGCN') = 'TRUE' or sys_context('NHANVIEN_CTX', 'ISTRUONGDA') = 'TRUE' then
    return '';
  else
    PHONGBAN := sys_context('NHANVIEN_CTX', 'PHONGBAN');
        TEMP :=  'MAPHONG = ''' || PHONGBAN || '''';
    return TEMP;
  end if;
end;


begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'NHANVIEN',
    policy_name => 'POLICY_XEM_NHANVIEN_CHUNGPHONG',
    function_schema => 'HCMUS',
    policy_function => 'FUNCTION_XEM_NHANVIEN_CHUNGPHONG',
	statement_types => 'select');
end;

--drop POLICY_XEM_NHANVIEN_CHUNGPHONG policy
/*
begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
	object_name => 'NHANVIEN',
	policy_name => 'POLICY_XEM_NHANVIEN_CHUNGPHONG'); 
end;
*/
                                            
--nhân viên chỉ xem được lương của chính mình
create or replace function FUNCTION_XEM_LUONG_NHANVIEN_ITSELF(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  USERNAME varchar2(10);
  TEMP varchar2(100);
begin
  if sys_context('userenv', 'SESSION_USER') = 'HCMUS' or sys_context('userenv', 'ISDBA') = 'TRUE' or sys_context('NHANVIEN_CTX', 'ISTRUONGPB') = 'TRUE' 
  or sys_context('NHANVIEN_CTX', 'ISTRUONGCN') = 'TRUE' or sys_context('NHANVIEN_CTX', 'ISTRUONGDA') = 'TRUE' then
    return '';
  else
    USERNAME := sys_context('userenv', 'session_user');
    TEMP :=  'MANV = ''' || USERNAME || '''';
    return TEMP;
  end if;
end;

--add POLICY_XEM_LUONG_NHANVIEN_ITSELF policy
begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'NHANVIEN',
	policy_name => 'POLICY_XEM_LUONG_NHANVIEN_ITSELF',
	function_schema => 'HCMUS',
	policy_function => 'FUNCTION_XEM_LUONG_NHANVIEN_ITSELF',
	statement_types => 'SELECT',
	sec_relevant_cols => 'LUONG',
	sec_relevant_cols_opt => dbms_rls.All_ROWS);
end;

--drop POLICY_XEM_LUONG_NHANVIEN_ITSELF policy
/*
begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
    object_name => 'NHANVIEN',
    policy_name => 'POLICY_XEM_LUONG_NHANVIEN_ITSELF');
end;
*/

-- test
grant select on HCMUS.NHANVIEN to public;

/*
SELECT * FROM HCMUS.NHANVIEN;
SELECT sys_context('NHANVIEN_CTX', 'ISTRUONGPB') FROM DUAL;
SELECT sys_context('NHANVIEN_CTX', 'ISTRUONGCN') FROM DUAL;
SELECT sys_context('NHANVIEN_CTX', 'ISTRUONGDA') FROM DUAL;
SELECT sys_context('NHANVIEN_CTX', 'PHONGBAN') FROM DUAL;
*/

