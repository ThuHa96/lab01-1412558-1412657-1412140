--Tất cả nhân viên bình thường (trừ trưởng phòng, trưởng chi nhánh và các trưởng dự án) 
--chỉ được phép xem thông tin nhân viên trong phòng của mình, chỉ được xem lương của bản thân (VPD). (**MSSV**)
--Xem nhân viên chung phòng với nhân viên đã login
CREATE VIEW V_NHANVIEN_OF_USER AS SELECT * FROM HCMUS.NHANVIEN;
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
	object_name => 'V_NHANVIEN_OF_USER',
    policy_name => 'POLICY_XEM_NHANVIEN_CHUNGPHONG',
    function_schema => 'HCMUS',
    policy_function => 'FUNCTION_XEM_NHANVIEN_CHUNGPHONG',
	statement_types => 'select');
end;

--drop POLICY_XEM_NHANVIEN_CHUNGPHONG policy
/*
begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
	object_name => 'V_NHANVIEN_OF_USER',
	policy_name => 'POLICY_XEM_NHANVIEN_CHUNGPHONG'); 
end;
*/
                                            
--nhân viên chỉ xem được lương của chính mình
create or replace function FUNCTION_XEM_LUONG_NHANVIEN(object_schema in varchar2, object_name in varchar2)
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

--add POLICY_XEM_LUONG_NHANVIEN policy
begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'V_NHANVIEN_OF_USER',
	policy_name => 'POLICY_XEM_LUONG_NHANVIEN',
	function_schema => 'HCMUS',
	policy_function => 'FUNCTION_XEM_LUONG_NHANVIEN',
	statement_types => 'SELECT',
	sec_relevant_cols => 'LUONG',
	sec_relevant_cols_opt => dbms_rls.All_ROWS);
end;

--drop POLICY_XEM_LUONG_NHANVIEN policy
/*
begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
    object_name => 'NHANVIEN',
    policy_name => 'POLICY_XEM_LUONG_NHANVIEN');
end;
*/

-- test
grant select on HCMUS.V_NHANVIEN_OF_USER to public;
SELECT * FROM HCMUS.V_NHANVIEN_OF_USER;


