    
/*task 3 */
CREATE OR REPLACE TRIGGER del 
before delete on PRODUCT for each row
begin 
if  user <> 'admin' then 
  raise_application_error(-20003, 'Нет удаления!');
end if;
end del;


DELETE FROM PRODUCT WHERE PRODUCT_ID = 3;
