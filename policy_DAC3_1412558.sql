-- [X] Chỉ trưởng phòng, trưởng chi nhánh được cấp quyền thực thi stored procedure cập nhật thông tin phòng ban của mình (DAC)
-- tạo procedure

CREATE OR REPLACE PROCEDURE sp_Update_PHONGBAN
(p_MAPHONG IN NUMBER, p_TENPHONG IN VARCHAR2, p_TRUONGPHONG IN NUMBER,
 p_NGAYNHANCHUC IN DATE, p_SONHANVIEN IN NUMBER, p_CHINHANH IN NUMBER) 
IS
BEGIN
  if p_TENPHONG!= null then update HCMUS.PHONGBAN SET HCMUS.PHONGBAN.TENPHONG = p_TENPHONG where HCMUS.PHONGBAN.MAPHONG = p_MAPHONG;
  end if;
  if p_TRUONGPHONG!= null then update HCMUS.PHONGBAN SET  HCMUS.PHONGBAN.TRUONGPHONG =  p_TRUONGPHONG where HCMUS.PHONGBAN.MAPHONG = p_MAPHONG;
  end if;
  if p_NGAYNHANCHUC!= null then update HCMUS.PHONGBAN SETHCMUS.PHONGBAN.NGAYNHANCHUC = p_NGAYNHANCHUC where HCMUS.PHONGBAN.MAPHONG = p_MAPHONG;
  end if;
  if p_SONHANVIEN!= null then update HCMUS.PHONGBAN SET HCMUS.PHONGBAN.SONHANVIEN = p_SONHANVIEN where HCMUS.PHONGBAN.MAPHONG = p_MAPHONG;
  end if;
  if p_CHINHANH!= null then update HCMUS.PHONGBAN SET HCMUS.PHONGBAN.CHINHANH = p_CHINHANH where HCMUS.PHONGBAN.MAPHONG = p_MAPHONG;
  end if;
  EXCEPTION
  WHEN OTHERS THEN
     raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END sp_Update_PHONGBAN;

grant execute HCMUS.sp_Update_PHONGBAN to r_truongphong;

-- trưởng chi nhánh được gọi sp cập nhập chi nhánh
 CREATE OR REPLACE PROCEDURE sp_Update_CHINHANH
(p_MACN IN NUMBER, p_TENCN IN VARCHAR2, p_TRUONGCN IN NUMBER) 
IS
BEGIN
  if p_TENCN!= null then update HCMUS.CHINHANH SET HCMUS.CHINHANH.TENCN = p_TENCN where HCMUS.CHINHANH.MACN = p_MACN;
  end if;
  if p_TRUONGCN!= null then update HCMUS.CHINHANH SET  HCMUS.CHINHANH.TRUONGCHINHANH =  p_TRUONGCN where HCMUS.CHINHANH.MACN = p_MACN;
  end if;
  EXCEPTION
  WHEN OTHERS THEN
     raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END sp_Update_CHINHANH;

grant execute HCMUS.sp_Update_CHINHANH to r_truongchinhanh;