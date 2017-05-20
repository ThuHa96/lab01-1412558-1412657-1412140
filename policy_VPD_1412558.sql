--Tất cả nhân viên bình thường (trừ trưởng phòng, trưởng chi nhánh và các trưởng dự án) 
--chỉ được phép xem thông tin nhân viên trong phòng của mình, chỉ được xem lương của bản thân (VPD). (**MSSV**)ậ

--tạo context NHANVIEN_CTX
CREATE OR REPLACE CONTEXT NHANVIEN_CTX USING SET_NHANVIEN_CTX_PKG;

--tạo package SET_NHANVIEN_CTX_PKG
create or replace package SET_NHANVIEN_CTX_PKG
is
  procedure SET_THONGTIN_NHANVIEN;
end;

create or replace package body SET_NHANVIEN_CTX_PKG
is
  procedure SET_THONGTIN_NHANVIEN
  is
  PHONGBAN varchar2(5);
  ISTRUONGPB varchar2(5);
  ISTRUONGCN varchar2(5);
  ISTRUONGDA varchar2(5);
  begin
    --tìm phòng của nhân viên đang login
    select MAPHONG into PHONGBAN from HCMUS.NHANVIEN where MANV = sys_context('userenv', 'session_user');
    dbms_session.set_context('NHANVIEN_CTX', 'PHONGBAN', PHONGBAN);
    --kiểm tra nhân viên là trưởng phòng
    select 
      case 
        when exists(select MAPHONG  from HCMUS.PHONGBAN where TRUONGPHONG = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into ISTRUONGPB
    from dual;
    dbms_session.set_context('NHANVIEN_CTX', 'ISTRUONGPB', ISTRUONGPB);

    --kiểm tra nhân viên là trưởng chi nhánh
    select 
      case 
        when exists(select MACN  from HCMUS.CHINHANH where TRUONGCHINHANH = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into ISTRUONGCN
    from dual;
    dbms_session.set_context('NHANVIEN_CTX', 'ISTRUONGCN', ISTRUONGCN);

    --kiểm tra nhân viên là trưởng dự án
    select 
      case  
        when exists(select MADA  from HCMUS.DUAN where TRUONGDA = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into ISTRUONGDA
    from dual;
    dbms_session.set_context('NHANVIEN_CTX', 'ISTRUONGDA', ISTRUONGDA);

    --không làm trưởng 
    exception
      when no_data_found then null;
  end;
end;

--tạo logon trigger cho package
create or replace trigger set_NHANVIEN_CTX_TRIGGER after logon on database
begin
  HCMUS.SET_NHANVIEN_CTX_PKG.SET_THONGTIN_NHANVIEN;
end;

--Xem nhân viên chung phòng với nhân viên đã login
create or replace function FUNCTION_XEM_NHANVIEN_CHUNGPHONG(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  PHONGBAN varchar2(5);
  TEMP varchar2(100);
begin
  if sys_context('userenv', 'ISDBA') = 'TRUE' or sys_context('NHANVIEN_CTX', 'ISTRUONGPB') = 'TRUE' 
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
  if sys_context('userenv', 'ISDBA') = 'TRUE' or sys_context('NHANVIEN_CTX', 'ISTRUONGPB') = 'TRUE' 
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
