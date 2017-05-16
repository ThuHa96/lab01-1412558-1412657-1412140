/* sample policy 1*/
/* role: chỉ trưởng phòng mới được cập nhật và thêm thông tin vào dự án DAC*/
create role truongphong_role;
grant insert, update on DUAN to truongphong_role;

/* role: Giám đốc được phép xem thông tin dự án gồm (mã dự án, tên dự án, kinh phí,
 tên phòng chủ trì, tên chi nhánh chủ trì, tên trưởng dự án và tổng chi) (DAC)*/
 /* TẠO VIEW CHO ROLE */
 CREATE VIEW V1_CHITIET_DUAN 
    AS SELECT DUAN.MADA, DUAN.TENDA, DUAN.KINHPHI, PHONGBAN.TENPHONG, CHINHANH.TENCN, NHANVIEN.HOTEN AS TENTRUONGDA
        FROM PHONGBAN, DUAN, CHINHANH, NHANVIEN 
        WHERE PHONGBAN.MAPHONG = DUAN.PHONGCHUTRI 
            AND PHONGBAN.CHINHANH = CHINHANH.MACN
            AND DUAN.TRUONGDA = NHANVIEN.MANV;
 CREATE ROLE GIAMDOC_ROLE;
 GRANT SELECT ON V1_CHITIET_DUAN TO GIAMDOC_ROLE;
 
 

CREATE OR REPLACE FUNCTION SEC_FUNCTION(p_schema varchar2, p_obj varchar2)
RETURN VARCHAR2
AS
USER VARCHAR2(20);
BEGIN
   /* IF (SYS_CONTEXT('USERENV', 'ISDBA')) THEN RETURN '';
    ELSE*/
    USER := SYS_CONTEXT('USERENV', 'SESSION_USER');
    RETURN 'MANV LIKE ' || '''' || USER || '''';
    /* users can only access their own data*/
   /* END IF;*/
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
select * from system.nhanvien where manv = 'NV01';
select * from system.nhanvien;
grant select on system.nhanvien to PUBLIC;

select 'MANV=' || '''' || (SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') from dual)|| '''' FROM DUAL;


