/* sample policy 1*/
CREATE OR REPLACE FUNCTION SEC_FUNCTION_N1(p_schema in varchar2, p_obj in varchar2)
RETURN VARCHAR2 AS username varchar2(20); p_manv number; p_maphong number;
BEGIN
    username := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF(username='HCMUS') then return '';
    else
        p_manv := TO_NUMBER(username);
        select HCMUS.NHANVIEN.MAPHONG into p_maphong from HCMUS.NHANVIEN where HCMUS.NHANVIEN.MANV = p_manv;
        RETURN 'HCMUS.V_NHANVIEN.MAPHONG = '|| TO_CHAR(p_maphong);
    end if; 
END SEC_FUNCTION_N1;

BEGIN DBMS_RLS.ADD_POLICY (
    OBJECT_SCHEMA => 'HCMUS',
	OBJECT_NAME => 'V_NHANVIEN',
	POLICY_NAME => 'SELECT_V_NHANVIEN_VPD1',
	FUNCTION_SCHEMA => 'HCMUS',
	POLICY_FUNCTION => 'SEC_FUNCTION_N1',
    STATEMENT_TYPES => 'SELECT',
	SEC_RELEVANT_COLS => 'LUONG');
END;
/* XÓA CHÍNH SÁCH TRÊN V_NHANVIEN
begin dbms_rls.DROP_POLICY (
    object_schema => 'HCMUS',
	object_name => 'V_NHANVIEN',
	policy_name => 'SELECT_V_NHANVIEN_VPD1');
end;
*/


