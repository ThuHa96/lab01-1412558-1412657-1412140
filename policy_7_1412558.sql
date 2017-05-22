-- Trưởng dự án chỉ được phép đọc, ghi thông tin chi tiêu của dự án mình quản lý (VPD). (**MSSV**)
CREATE VIEW V_CHITIEU_OF_TRUONGDA AS SELECT * FROM HCMUS.CHITIEU;

create or replace function FUNCTION_TRUONGDA_CHITIEU(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  USERNAME varchar2(5);
  TEMP varchar2(500);
  PHONGBAN VARCHAR2(5);
  SL NUMBER;
  IJ NUMBER;
begin
    if (sys_context('userenv', 'session_user') = 'HCMUS') then return ''; end if;
    if sys_context('NHANVIEN_CTX', 'ISTRUONGDA') = 'TRUE' then
        USERNAME := sys_context('userenv', 'session_user');
        TEMP :='';
        IJ :=0;
        begin
            select COUNT(*) INTO SL from HCMUS.DUAN WHERE TRUONGDA=USERNAME;
            for DUAN_LIST in (select MADA from HCMUS.DUAN WHERE TRUONGDA=USERNAME)
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
	object_name => 'V_CHITIEU_OF_TRUONGDA',
    policy_name => 'POLICY_TRUONGDA_CHITIEU_SELECT',
    function_schema => 'HCMUS',
    policy_function => 'FUNCTION_TRUONGDA_CHITIEU',
	statement_types => 'SELECT');
end;

begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'V_CHITIEU_OF_TRUONGDA',
    policy_name => 'POLICY_TRUONGDA_CHITIEU_UPDATE',
    function_schema => 'HCMUS',
    policy_function => 'FUNCTION_TRUONGDA_CHITIEU',
	statement_types => 'UPDATE');
end;

--drop POLICY_TRUONGDA_DUAN policy
/*
begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
	object_name => 'V_CHITIEU_OF_TRUONGDA',
	policy_name => 'POLICY_TRUONGDA_CHITIEU_SELECT'); 
end;

begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
	object_name => 'V_CHITIEU_OF_TRUONGDA',
	policy_name => 'POLICY_TRUONGDA_CHITIEU_UPDATE'); 
end;
*/

grant select,update on HCMUS.V_CHITIEU_OF_TRUONGDA TO PUBLIC;
SELECT * from HCMUS.V_CHITIEU_OF_TRUONGDA;
UPDATE HCMUS.V_CHITIEU_OF_TRUONGDA set sotien=3500 where MACHITIEU='CT001';
