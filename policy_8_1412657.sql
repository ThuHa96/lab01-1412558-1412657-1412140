/* TRưởng phòng chỉ được phép đọc thông tin chi tiêu của dự án trong phòng ban mình quản lí.
Với những dự án không thuộc phòng ban của mình, các trưởng phòng được phép xem thông tin chi tiêu (VPD)
 */
create view V_TRUONGPHONG_OF_CHITIEU as select * from CHITIEU;
 
create or replace function FUNCTION_TRUONGPB_CHITIEU_ALL_SELECT(object_schema in varchar2, object_name in varchar2)
return varchar2
as
begin
    if (sys_context('userenv', 'session_user') = 'HCMUS') then return ''; end if;
    if sys_context('NHANVIEN_CTX', 'ISTRUONGPB') = 'TRUE' then RETURN ''; END IF;
    RETURN '1=0';
end;

create or replace function FUNCTION_TRUONGPB_CHITIEU_SOTIEN_SELECT(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  USERNAME varchar2(5);
  PHONGBAN VARCHAR2(5);
  TEMP varchar2(500);
  SL NUMBER;
  IJ NUMBER;
begin
    if (sys_context('userenv', 'session_user') = 'HCMUS') then return ''; end if;
    if sys_context('NHANVIEN_CTX', 'ISTRUONGPB') = 'TRUE' then
        USERNAME := sys_context('userenv', 'session_user');
        PHONGBAN := sys_context('NHANVIEN_CTX', 'PHONGBAN');
        TEMP :='';
        IJ :=0;
        begin
            select COUNT(*) INTO SL from HCMUS.DUAN WHERE PHONGCHUTRI=PHONGBAN;
            for DUAN_LIST in (select MADA from HCMUS.DUAN WHERE PHONGCHUTRI=PHONGBAN)
            loop
                IJ:=IJ+1;
                IF(IJ=SL) THEN
                TEMP := TEMP || '''' ||DUAN_LIST.MADA || '''';
                ELSE TEMP := TEMP || '''' ||DUAN_LIST.MADA || ''',';
                END IF;
            end loop;
        end;
        return 'DUAN IN (' ||TEMP || ')';
    end if;
    return '1=0';
end;

begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'V_CHITIEU_OF_TRUONGPB',
	policy_name => 'POLICY_TRUONGPB_CHITIEU_SOTIEN_SELECT',
	function_schema => 'HCMUS',
	policy_function => 'FUNCTION_TRUONGPB_CHITIEU_SOTIEN_SELECT',
	statement_types => 'SELECT',
	sec_relevant_cols => 'SOTIEN',
	sec_relevant_cols_opt => dbms_rls.All_ROWS);
end;

begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'V_CHITIEU_OF_TRUONGPB',
	policy_name => 'POLICY_TRUONGPB_CHITIEU_ALL_SELECT',
	function_schema => 'HCMUS',
	policy_function => 'FUNCTION_TRUONGPB_CHITIEU_ALL_SELECT',
	statement_types => 'SELECT');
end;


/*
begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
	object_name => 'V_CHITIEU_OF_TRUONGPB',
	policy_name => 'POLICY_TRUONGPB_CHITIEU'); 
end;
*/

grant select on HCMUS.V_CHITIEU_OF_TRUONGPB TO public;
SELECT * from HCMUS.V_CHITIEU_OF_TRUONGPB;


