--tạo package SET_NHANVIEN_CTX_PKG

create or replace package SET_NHANVIEN_CTX_PKG
as
    procedure SET_PHONGBAN;
    procedure CHECK_TRUONGPHONG;
    procedure CHECK_TRUONGCHINHANH;
    procedure CHECK_TRUONGDUAN;
	procedure CHECK_GIAMDOC;
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
  
  procedure CHECK_GIAMDOC
  as ISGIAMDOC varchar2(5);
  begin
    select case 
        when exists(select MANV  from HCMUS.NHANVIEN where CHUCVU = 1)
        then 'TRUE'
        else 'FALSE'
      end into ISGIAMDOC
    from dual;
    dbms_session.set_context('NHANVIEN_CTX', 'ISGIAMDOC', ISGIAMDOC);
  end;
end;

--tạo logon trigger cho package
create or replace trigger set_NHANVIEN_CTX_TRIGGER after logon on database
begin
    HCMUS.SET_NHANVIEN_CTX_PKG.SET_PHONGBAN;
    HCMUS.SET_NHANVIEN_CTX_PKG.CHECK_TRUONGPHONG;
    HCMUS.SET_NHANVIEN_CTX_PKG.CHECK_TRUONGCHINHANH;
    HCMUS.SET_NHANVIEN_CTX_PKG.CHECK_TRUONGDUAN;
	HCMUS.SET_NHANVIEN_CTX_PKG.CHECK_GIAMDOC;
end;