select * from item_master where item = '1000037927';
select * from repl_item_loc where item = '100247633';
select * from repl_day where item = '100247633' and weekday = 2;
select * from item_loc where item = '100247633' and loc = 2133;
select get_vdate from dual;

update restart_control
set num_threads = 1
where program_name = 'fah_repl_ext';

select * from restart_control where program_name = 'fah_repl_ext';
select * from restart_program_status where restart_name = 'fah_repl_ext';

FAH.FAH_REPL_EXT_SQL.MAIN

create table cms_repl_item_loc as
select ril.item, ril.status, ril.activate_date, ril.deactivate_date, il.status as status_il, il.loc
  from repl_item_loc ril, repl_day rd, item_loc il
 where ril.status = 'A'
   and ril.item = rd.item
   and ril.location = rd.location
   and rd.weekday = 2
   and ril.item = il.item
   and ril.location = il.loc
   and il.status <> 'A';

select distinct status, deactivate_date --ril.item, ril.status, ril.activate_date, ril.deactivate_date 
  from repl_item_loc ril 
 where 1=1
  --and item = '100247633' and 
  and exists (select 'x' from cms_repl_item_loc t where t.item = ril.item and t.loc = ril.location);
  
select * from cms_repl_item_loc;
select * from fah_repl_min_max_upd;
repl_attribute_maintenance_sql;
select * from rtk_errors where rtk_text like '%tabla o%';


declare
   cursor C_drive is
      select ril.item, ril.status, ril.activate_date, ril.deactivate_date, il.loc
        from repl_item_loc ril, repl_day rd, item_loc il
       where ril.status = 'A'
         and ril.item = rd.item
         and ril.location = rd.location
         and rd.weekday = 2
         and ril.item = il.item
         and ril.location = il.loc
         and il.status <> 'A'
         --and ril.item = '100247633'
         ;
begin
   for C_rec in C_drive loop
      update repl_item_loc r set r.status = 'W', r.deactivate_date = trunc(sysdate) - 1
       where r.item = C_rec.item
         and r.location = C_rec.loc
         and r.status = 'A';
   end loop;
end;
/

GRANT SELECT ON rms.REPL_DAY TO fah;
GRANT SELECT ON rms.REPL_ATTR_UPDATE_EXCLUDE TO fah;
GRANT EXECUTE ON rms.GET_USER TO fah;
GRANT select ON rms.replenishment_id_seq TO fah;

create table CMS_MASTER_REPL_ATTR AS
select * from MASTER_REPL_ATTR where item = '1000037927';
DELETE FROM MASTER_REPL_ATTR where item = '1000037927';

insert into CMS_MASTER_REPL_ATTR select * from MASTER_REPL_ATTR where item = '1000037927';
select * from CMS_MASTER_REPL_ATTR;


RMS.PK_MASTER_REPL_ATTR;

select * from restart_program_status where restart_name = 'rplatupd';
update restart_program_status r set r.restart_flag = 'Y' where restart_name = 'rplatupd' and r.program_status = 'aborted in process';
select * from restart_bookmark; --;1033884;1000049615;126

--insert into CMS_MASTER_REPL_ATTR
select * from MASTER_REPL_ATTR i 
--delete from MASTER_REPL_ATTR i 
 where (i.location, i.item) in (
select distinct rau_loc.loc, vris.item from  v_restart_store_wh vrsw,
             v_rau_item_stage vris,
             repl_attr_update_loc rau_loc,
             repl_attr_update_head rau_head,
             period per
       WHERE rau_head.repl_attr_id = vris.repl_attr_id
         AND rau_loc.repl_attr_id = vris.repl_attr_id
         AND rau_head.scheduled_active_date = per.vdate
         and exists (select 1 from MASTER_REPL_ATTR m where m.location = rau_loc.loc and vris.item = m.item)
         AND NOT EXISTS (SELECT 'X'
                           FROM repl_attr_update_exclude rau_excl
                          WHERE rau_excl.repl_attr_id = rau_head.repl_attr_id
                            AND rau_excl.item = vris.item
                            AND rau_excl.location = rau_loc.loc
                            AND rau_excl.loc_type = rau_loc.loc_type
                            AND rownum = 1)
         AND EXISTS (SELECT 'x'
                       FROM item_loc il
                      WHERE il.item = vris.item
                        AND il.loc = rau_loc.loc
                        AND il.loc_type = rau_loc.loc_type
                        AND rownum = 1)
         AND vrsw.driver_name = 'STORE_WH'
         AND vrsw.num_threads  = 1
         AND vrsw.thread_val = 1
         AND vrsw.driver_value = rau_loc.loc
         )
        ;

select * from restart_control where program_name = 'dtesys';
select * from restart_program_status where restart_name = 'dtesys';
select * from restart_bookmark where restart_name = 'fah_repl_ext';


--01
DECLARE
   L_str_error_tst   VARCHAR2(1) := NULL;
   FUNCTION_ERROR    EXCEPTION;
   L_error_message   VARCHAR2(1001);
BEGIN
   if NOT FAH.FAH_REPL_EXT_SQL.MAIN(L_error_message,
                                    1,
                                    1,
                                    'fah_repl_ext',
                                    0) then
      dbms_output.put_line(L_error_message);
      raise FUNCTION_ERROR;
   end if;
   --commit;
EXCEPTION
   when FUNCTION_ERROR then
      dbms_output.put_line('FUNCTION_ERROR');
   when OTHERS then
      dbms_output.put_line('OTHERS');
END;
      
--02      
select distinct process_id from fah_repl_ext_hist where trunc(process_date) = trunc(sysdate);      

--03
select distinct r.order_no, 'ORDERS' as type
  from fah_repl_ext_hist r
 where trunc(process_date) = trunc(sysdate) and process_id = 2724 
   and NVL(order_no,0) <> 0 
 UNION ALL
select distinct r.tsf_no, 'TRANSFERS' as type
  from fah_repl_ext_hist r
 where trunc(process_date) = trunc(sysdate) and process_id = 2724 
   and NVL(r.TSF_NO,0) <> 0;        
