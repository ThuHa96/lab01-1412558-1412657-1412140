/** [X] Chỉ trưởng phòng, trưởng chi nhánh được cấp quyền thực thi stored procedure cập nhật thông tin phòng ban của mình (DAC)*/
/*tạo procedure */
 CREATE OR REPLACE PROCEDURE sp_Update_PHONGBAN
( p_MAPHONG IN NUMBER, p_TENPHONG IN NVARCHAR2, p_TRUONGPHONG IN NUMBER
    , p_NGAYNHANCHUC IN DATE, p_SONHANVIEN IN NUMBER, p_CHINHANH IN NUMBER) 
IS
BEGIN
  if p_TENPHONG!= null then update PHONGBAN SET TENPHONG = p_TENPHONG where MAPHONG = p_MAPHONG;
  end if;
  if p_TRUONGPHONG!= null then update PHONGBAN SET  TRUONGPHONG =  p_TRUONGPHONG where MAPHONG = p_MAPHONG;
  end if;
  if p_NGAYNHANCHUC!= null then update PHONGBAN SET NGAYNHANCHUC = p_NGAYNHANCHUC where MAPHONG = p_MAPHONG;
  end if;
  if p_SONHANVIEN!= null then update PHONGBAN SET SONHANVIEN = p_SONHANVIEN where MAPHONG = p_MAPHONG;
  end if;
  if p_CHINHANH!= null then update PHONGBAN SET CHINHANH = p_CHINHANH where MAPHONG = p_MAPHONG;
  end if;
  EXCEPTION
  WHEN OTHERS THEN
     raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END sp_Update_PHONGBAN;