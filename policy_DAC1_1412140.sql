grant update,insert on  HCMUS.DUAN to R_TRUONGPHONG;


begin
for TRUONGPB_LIST in (select TRUONGPHONG from HCMUS.PHONGBAN)
loop
  execute immediate 'grant R_TRUONGPHONG to ' || TRUONGPB_LIST.TRUONGPHONG; 
end loop;
end;
