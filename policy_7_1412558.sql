-- Trưởng dự án chỉ được phép đọc, ghi thông tin chi tiêu của dự án mình quản lý (VPD). (**MSSV**)
CREATE OR REPLACE VIEW V_CHITIEU_OF_TRUONGDA AS SELECT * FROM HCMUS.CHITIEU;
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

grant select,update on HCMUS.V_CHITIEU_OF_TRUONGDA TO NV003,NV008;

-- trưởng dự án DA001,DA002 là NV003
-- trưởng dự án DA003,DA004,DA005 là NV008
-- DO CHƯA GÁN NHÃN ĐÚNG NÊN ĐỂ TEST VPD, GÁN NHÃN CHO USER VỚI NHÃN CAO NHẤT
EXEC SA_USER_ADMIN.SET_GROUPS('OLS_DUAN','NV003','TCT','','','');
EXEC SA_USER_ADMIN.SET_COMPARTMENTS('OLS_DUAN','NV003','PNS,PKT,PKH','','','');
EXEC SA_USER_ADMIN.SET_LEVELS ('OLS_DUAN', 'NV003', 'BMC', 'TT', 'BMC', 'BMC');

EXEC SA_USER_ADMIN.SET_GROUPS('OLS_DUAN','NV003','TCT','','','');
EXEC SA_USER_ADMIN.SET_COMPARTMENTS('OLS_DUAN','NV003','PNS,PKT,PKH','','','');
EXEC SA_USER_ADMIN.SET_LEVELS ('OLS_DUAN', 'NV003', 'BMC', 'TT', 'BMC', 'BMC');

SELECT * from HCMUS.V_CHITIEU_OF_TRUONGDA;
SELECT * FROM HCMUS.DUAN;
update hcmus.V_CHITIEU_OF_TRUONGDA set SOTIEN = 1000 WHERE DUAN='DA001';

update hcmus.V_CHITIEU_OF_TRUONGDA set SOTIEN = 1000 WHERE DUAN='DA004';
