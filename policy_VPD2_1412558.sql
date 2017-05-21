-- Trưởng dự án chỉ được phép đọc, ghi thông tin chi tiêu của dự án mình quản lý (VPD). (**MSSV**)
create or replace function FUNCTION_TRUONGDA_CHITIEU(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  USERNAME varchar2(5);
  TEMP varchar2(100);
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
    
    -- CÁC TRƯỜNG HỌP CÒN LẠI KO CHO XEM
    return '1=0';
end;

begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'CHITIEU',
    policy_name => 'POLICY_TRUONGDA_CHITIEU_SELECT',
    function_schema => 'HCMUS',
    policy_function => 'FUNCTION_TRUONGDA_CHITIEU',
	statement_types => 'SELECT, UPDATE, INSERT',
    update_check => 'TRUE');
end;

begin dbms_rls.add_policy(
	object_schema => 'HCMUS',
	object_name => 'CHITIEU',
    policy_name => 'POLICY_TRUONGDA_CHITIEU_UPDATE',
    function_schema => 'HCMUS',
    policy_function => 'FUNCTION_TRUONGDA_CHITIEU',
	statement_types => 'UPDATE');
end;

--drop POLICY_TRUONGDA_DUAN policy
/*
begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
	object_name => 'DUAN',
	policy_name => 'POLICY_TRUONGDA_CHITIEU_SELECT'); 
end;

begin dbms_rls.drop_policy(
	object_schema => 'HCMUS',
	object_name => 'DUAN',
	policy_name => 'POLICY_TRUONGDA_CHITIEU_UPDATE'); 
end;
*/

grant select,update on HCMUS.CHITIEU TO public;

SELECT * from hcmus.chitieu;
UPDATE hcmus.chitieu set sotien=3000 where MACHITIEU='CT001';
