/* sample policy 1*/
CREATE OR REPLACE FUNCTION SEC_FUNCTION(p_schema varchar2, p_obj varchar2)
RETURN VARCHAR2
AS
USER VARCHAR2(20);
BEGIN
    IF (SYS_CONTEXT('USERENV', 'ISDBA'))
    THEN
        RETURN '';
    ELSE
        USER := SYS_CONTEXT('USERENV', 'SESSION_USER');
        RETURN 'MANV = ' || USER;
    /* users can only access their own data*/
    END IF;
END;
/* userenvis the pre-defined application context */

/* attach the policy function to table*/
BEGIN DBMS_RLS.ADD_POLICY (
    OBJECT_SCHEMA => 'SYSTEM',
	OBJECT_NAME => 'NHANVIEN',
	POLICY_NAME => 'SELECT_OWNER_NHANVIEN_VPD1',
	FUNCTION_SCHEMA => 'SYSTEM',
	POLICY_FUNCTION => 'SEC_FUNCTION',
    STATEMENT_TYPES => 'SELECT',
	SEC_RELEVANT_COLS => 'LUONG');
END;
/* XÓA CHÍNH SÁCH TRÊN BẢN*/
begin dbms_rls.DROP_POLICY (
    object_schema => 'SYSTEM',
	object_name => 'NHANVIEN',
	policy_name => 'SELECT_OWNER_NHANVIEN_VPD1');
end;
select * from system.nhanvien where MANV = (SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') FROM DUAL);
select * from system.nhanvien;
grant select on system.nhanvien to PUBLIC;

(select SYS_CONTEXT('USERENV', 'ISDBA') from dual);

BEGIN
    IF (SYS_CONTEXT('USERENV', 'ISDBA'))
    THEN
        select 'MANV = ' || USER from dual;
    ELSE
        USER := SYS_CONTEXT('USERENV', 'SESSION_USER');
        select 'MANV = ' || USER from dual;
    /* users can only access their own data*/
    end if;
END;


