-- [X] Chỉ trưởng phòng, trưởng chi nhánh được cấp quyền thực thi stored procedure cập nhật thông tin phòng ban của mình (DAC)
-- tạo procedure
alter session set "_ORACLE_SCRIPT"=true;


CREATE OR REPLACE PROCEDURE SP_UPDATE_PHONGBAN
(p_TENPHONG IN VARCHAR2, p_TRUONGPHONG IN VARCHAR2,
 p_NGAYNHANCHUC IN DATE, p_SONHANVIEN IN NUMBER, p_CHINHANH IN VARCHAR2) 
IS USERNAME VARCHAR2(5); PHONG VARCHAR2(5);
BEGIN
	-- LẤY MÃ NHÂN VIÊN ĐANG LOGIN
	USERNAME :=sys_context('userenv', 'session_user');
	-- LẤY MÃ PHÒNG NHÂN NHIÊN ĐANG Ở
	PHONG := sys_context('NHANVIEN_CTX', 'PHONGBAN');
	if(sys_context('NHANVIEN_CTX', 'ISTRUONGPB') = 'TRUE' OR sys_context('NHANVIEN_CTX', 'ISTRUONGCN') = 'TRUE') THEN -- PHÒNG CẬP NHẬT PHẢI LÀ PHÒNG NHÂN VIÊN ĐANG Ở  
        update HCMUS.PHONGBAN SET
                            HCMUS.PHONGBAN.TENPHONG = p_TENPHONG,
                            HCMUS.PHONGBAN.TRUONGPHONG =  p_TRUONGPHONG,
							HCMUS.PHONGBAN.NGAYNHANCHUC = p_NGAYNHANCHUC,
							HCMUS.PHONGBAN.SONHANVIEN = p_SONHANVIEN,
							HCMUS.PHONGBAN.CHINHANH = p_CHINHANH
                            where HCMUS.PHONGBAN.MAPHONG = PHONG;
    end if;
END SP_UPDATE_PHONGBAN;

grant execute ON HCMUS.sp_Update_PHONGBAN to R_TRUONGPHONG;
grant execute ON HCMUS.sp_Update_PHONGBAN to R_TRUONGCHINHANH;

begin
for TRUONGPB_LIST in (select TRUONGPHONG from HCMUS.PHONGBAN)
loop
  execute immediate 'grant R_TRUONGPHONG to ' || TRUONGPB_LIST.TRUONGPHONG; 
end loop;
end;

begin
for TRUONGCN_LIST in (select TRUONGCHINHANH from HCMUS.CHINHANH)
loop
  execute immediate 'grant R_TRUONGCHINHANH to ' || TRUONGCN_LIST.TRUONGCHINHANH; 
end loop;
end;

