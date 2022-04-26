select restart_name, r.thread_val, r.program_status, r.restart_flag from restart_program_status r where restart_name = 'nb_discontinued_items';
select * from restart_bookmark where restart_name = 'nb_discontinued_items';

select * from sit_head h, sit_detail d
 where h.itemloc_link_id = d.itemloc_link_id
   --and d.itemloc_link_id = 2105014
   and d.status_update_date = trunc(sysdate) ;

select * from rms.skulist_detail d where d.item = '102100069';--3504396
select * from rms.skulist_detail d where d.item = '102100069';--3504396
select count(*), skulist 
  from sit_explode s 
 where 1=1
   and skulist in(3204406,3324395,3324397,3324398,3324399,3329395,3329398,3329399,3329401,3329402,3329403,3329404,3329405,3424395,3469396,3504395,3504396,3504400) 
   and not exists (select 1 from item_loc i where i.loc = s.location and i.item = s.item) group by skulist;
select * from sit_explode s where skulist = 3489397 and not exists (select 1 from item_loc i where i.loc = s.location and i.item = s.item);
select sysdate from dual;
select rms.get_vdate from dual; 
select * from period;
select r.*, r.commit_max_ctr * r.num_commits as count_lines from restart_program_history r where restart_name = 'rilmaint' and r.start_time > '27-Mar-2022' and r.thread_val = 1;
update restart_program_status r set r.program_status = 'ready for start' where program_status = 'completed' and r.restart_name = 'reclsdly' ;
update restart_program_status r set r.program_status = 'aborted in process', r.restart_flag = 'Y' where program_status = 'started' and r.restart_name = 'saexpsim' ;
update restart_program_status r set r.restart_flag = 'Y' where r.restart_name = 'reclsdly' and r.thread_val = 2 ;
update restart_program_status r set r.program_status = 'completed' where program_status = 'ready for start' and r.restart_name = 'fcexec' and r.thread_val not in(1,19,20,15,13);
commit;

select r.restart_name, r.thread_val, r.start_time, r.restart_time, r.program_status, r.restart_flag, rr.bookmark_string, rr.num_commits, rr.avg_time_btwn_commits
  from restart_program_status r, restart_bookmark rr 
 where r.restart_name = 'nb_discontinued_items' 
   and r.restart_name = rr.restart_name 
   and r.thread_val = rr.thread_val; --352 11 44028

select r.restart_name, r.thread_val, r.program_status, r.restart_flag, rr.bookmark_string
  from restart_program_status r, restart_bookmark rr 
 where r.restart_name = 'reclsdly' 
   and r.restart_name = rr.restart_name 
   and r.thread_val = rr.thread_val;

select *
  from rms.restart_program_history r
 where r.restart_name = 'rplatupd'
   and r.start_time > '01-Feb-2022';
select *
  from rms.restart_control r --100
 where 1=1
   and r.program_name like 'rplbld%'
   and r.driver_name = 'STORE_WH';

--Antes de relançar o fcexec 
select count(*) from cost_event_result c where c.status = 'E' and trunc(c.create_datetime) >= trunc(sysdate) - 4;
select * from cost_event_result c where c.status = 'E' and trunc(c.create_datetime) >= trunc(sysdate) - 1;
update restart_program_status r set r.restart_flag = 'Y' where restart_name = 'rilmaint' and r.program_status = 'aborted in process';
update cost_event_result c set c.status = 'N' where c.status = 'E' and trunc(c.create_datetime) >= trunc(sysdate) - 4;
commit;
 
select ct.thread_id, cr.status, count(*)
  from cost_event ce, cost_event_thread ct, cost_event_result cr
 where ce.cost_event_process_id = ct.cost_event_process_id(+)
   and ce.cost_event_process_id = cr.cost_event_process_id(+)
   and ct.thread_id = cr.thread_id
   --and to_char(ce.create_datetime,'DD/MM/YYYY') = '16/02/2022'
   and cr.status in('N','E')
 group by ct.thread_id, cr.status
 order by 3;

/* 
9 N 100491
11  N 134122
16  N 149427
12  N 149674
17  N 171859
5 N 172096
4 N 173109
1 N 174101
3 N 178274
13  N 181427
6 N 195848
19  N 211572
2 N 245941
20  N 247287
15  N 262064
*/
   



 
select count(*), status from rpm_stage_item_loc group by status;


select count(*), status from rpm_nil_rollup_thread where trunc(start_date) = '27-Nov-2021' --and status <> 'C' 
 group by status;
select count(*) from (
select distinct thread_number 
  from rpm_nil_rollup_thread 
  where 1=1
    and trunc(start_date) = '27-Nov-2021' 
    --and status <> 'C'
    );

select * from rpm_nil_rollup_thread where trunc(start_date) = '27-Nov-2021' and thread_number = 2792 --and status <> 'C' 


select * from ordhead where order_no = '50097916';
select * from ordloc where order_no = '50097916';

update ordhead o set o.status = 'C' where order_no = '50097916';

-----PO_INDUCT
select * from rms_async_status where job_type = 'PO_INDUCT' and status = 'N';

--Salesprocess
select * from svc_posupld_status where status='N';
select count(*), trunc(process_date) as process_date from svc_posupld_load_arch 
 where trunc(process_date) >= '20-12-2021' 
 group by trunc(process_date) order by trunc(process_date) desc;
select count(*), trunc(s.last_update_datetime) as last_update_datetime, status 
  from svc_posupld_status s 
 where trunc(s.last_update_datetime) >= '20-12-2021' 
 group by trunc(s.last_update_datetime), status 
 order by trunc(s.last_update_datetime) desc;


--ordupd tata
      SELECT rv.driver_value
        FROM v_restart_all_locations rv
       WHERE rv.driver_name   = 'ALL_LOCATIONS'
         AND rv.num_threads   = 1 --TO_NUMBER(:ps_num_threads)
         AND rv.thread_val    = 1 --TO_NUMBER(:ps_thread_val)
         AND rv.driver_value  > 332 --TO_NUMBER(NVL(:ps_restart_location,'-1'))
    ORDER BY rv.driver_value;

    EXEC SQL DECLARE c_affected_orders CURSOR FOR
       WITH phist AS
              (SELECT /*+ MATERIALIZE */ item, unit_retail, loc, action_date
                 FROM price_hist ph
                WHERE loc > 412 --= TO_NUMBER(:ps_drive_location)
                  AND tran_type IN (4, 8, 11)
                  AND ph.action_date = get_vdate /*TO_DATE(:ps_tomorrow, 'YYYYMMDD')*/)
       SELECT DISTINCT
              C_TYPE,
              ORDER_NO,
              CURRENCY_CODE,
              PACK_NO,
              otb_eow_date,
              order_type,
              status,
              unit_retail_diff,
              qty_diff,
              item,
              loc_type,
              location,
              pack_qty,
              unit_retail,
              ol_rowid
            FROM (
          SELECT  distinct TO_CHAR(oh.otb_eow_date,'YYYYMMDD')otb_eow_date,
              oh.order_no,
              oh.currency_code,
              oh.order_type,
              oh.status,

              olph.C_TYPE,
              olph.PACK_NO,
              olph.unit_retail_diff,
              olph.qty_diff,
              olph.item,
              olph.loc_type,
              olph.location,
              olph.pack_qty,
              olph.unit_retail,
              olph.ol_rowid
              FROM
     (           SELECT  'S' C_TYPE,
              '0' pack_no,
              NVL(ph.unit_retail,0) - NVL(ol.unit_retail, 0) unit_retail_diff,
              NVL(ol.qty_ordered, 0) - NVL(ol.qty_received, 0) qty_diff,
              ph.item,
              ol.loc_type,
              ol.location,
              0 pack_qty,
              NVL(ph.unit_retail, 0) unit_retail,
              ol.order_no,
              ROWIDTOCHAR(ol.rowid) ol_rowid
         FROM
              phist ph,
              ordloc ol
        WHERE
          ph.item        = ol.item
          AND ol.location    > 412 --= TO_NUMBER(:ps_drive_location)
          and ph.loc = ol.location
       UNION ALL
       SELECT  'P',
              vpq.pack_no,
              NVL(ol.unit_retail, 0),
              vpq.qty * (NVL(ol.qty_ordered, 0) - NVL(ol.qty_received, 0)),
              ph.item,
              ol.loc_type,
              ol.location,
              vpq.qty pack_qty,
              NVL(ph.unit_retail, 0),
              ol.order_no,
              ROWIDTOCHAR(ol.rowid) ol_rowid
         FROM
              phist    ph,
              v_packsku_qty vpq,
              ordloc        ol
        WHERE ol.item         = vpq.pack_no
         AND ph.item         = vpq.item
          AND ol.location     > 412 --= TO_NUMBER(:ps_drive_location)
          and ph.loc = ol.location
        UNION ALL
        SELECT  'S',
               '0' pack_no,
               NVL(eph.unit_retail,0) - NVL(ol.unit_retail, 0),
               NVL(ol.qty_ordered, 0) - NVL(ol.qty_received, 0),
               eph.item,
               ol.loc_type,
               ol.location,
               0 pack_qty,
               NVL(eph.unit_retail, 0),
               ol.order_no,
               ROWIDTOCHAR(ol.rowid) ol_rowid
          FROM
               emer_price_hist eph,
               ordloc ol

         WHERE
           eph.item        = ol.item
           AND eph.loc         = ol.location
           AND ol.location    > 412 --= TO_NUMBER(:ps_drive_location)
           AND eph.tran_type   in (4, 8, 11)
           AND eph.action_date = get_vdate --TO_DATE(:ps_tomorrow  , 'YYYYMMDD')- 1
           AND NOT EXISTS(SELECT 'X'
                            FROM phist ph
                           WHERE eph.item = ph.item
                             AND eph.loc = ph.loc
                             AND eph.action_date = ph.action_date - 1)
        UNION ALL
        SELECT  'P',
               vpq.pack_no,
               NVL(ol.unit_retail, 0),
               vpq.qty * (NVL(ol.qty_ordered, 0) - NVL(ol.qty_received, 0)),
               eph.item,
               ol.loc_type,
               ol.location,
               vpq.qty pack_qty,
               NVL(eph.unit_retail, 0),
               ol.order_no,
               ROWIDTOCHAR(ol.rowid) ol_rowid
          FROM
               emer_price_hist    eph,
               v_packsku_qty vpq,
               ordloc        ol
         WHERE ol.item         = vpq.pack_no
           AND eph.item         = vpq.item
           AND eph.loc          = ol.location
           AND ol.location     > 412 --= TO_NUMBER(:ps_drive_location)
           AND eph.tran_type    in (4, 8, 11)
           AND eph.action_date  = get_vdate --TO_DATE(:ps_tomorrow, 'YYYYMMDD') - 1
           AND NOT EXISTS(SELECT 'X'
                            FROM phist ph
                           WHERE eph.item = ph.item
                             AND eph.loc = ph.loc
                             AND eph.action_date = ph.action_date - 1)
                             ) olph,
                             ordhead oh
        WHERE oh.order_no     = olph.order_no
       AND oh.status       in ('W', 'S', 'A')
         ORDER BY ol_rowid);

--Upload replenishment
select * from repl_attr_update_head h where h.create_date = trunc(sysdate);
select * from master_repl_attr h where trunc(h.create_datetime) = trunc(sysdate);
select * from repl_item_loc ril where ril.item = '100300895'  ;

select * from RMS_ASYNC_STATUS;

SELECT * FROM SVC_PROCESS_TRACKER WHERE trunc(action_date) = trunc(sysdate) and template_key = 'NB_REPL_ATTR_DATA';-- and PROCESS_SOURCE <> 'EXT' AND STATUS NOT IN ('PS', 'PW', 'PE') ORDER BY PROCESS_ID;
SELECT * FROM S9T_FOLDER where file_id = '3196119';

select * from svc_process_items where process_id = '4402965';
select * from svc_process_tracker where process_id = '4391285';
RMS_COL_SPT_STATUS_AUR;
select * from RAF_NOTIFICATION where trunc(create_date) = trunc(sysdate) and notification_desc like '%4402965%';
select * from rms.wh where wh in(600001,800001);
--sql_lib.get_message_text message:El almacén de origen no existe o no está activo para este artículo.
--sql_lib.get_message_text message:El siguiente campo es necesario: Límite de Escalado.
SELECT *
FROM LOGGER_LOGS
where time_stamp between
TO_date('16-feb-2022 000000', 'DD-MON-YYYY HH24MIss') and
TO_date('16-feb-2022 221300', 'DD-MON-YYYY HH24MIss')
and unit_name like '%FAH.FAH_CORESVC_REPL_ATTR%'
and text not like '%RPM_%'
and text not like '%RESA_OI%';

select /*+parallel(8)*/
       *
  from logger_logs
 where 1=1
  and upper(unit_name) like '%ATTR%' --585938407
   --and client_identifier='REIM_BATCH'
 order by time_stamp desc;



SELECT * FROM RMS_ASYNC_STATUS WHERE rms_async_id = '3196085' STATUS NOT IN ('E', 'S');
select * from dba_tables where table_name like '%QTAB%';

SELECT COUNT(1) AS msgs_count, 'ITEM_INDUCT_QTAB' AS qtab_name FROM ITEM_INDUCT_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'PO_INDUCT_QTAB' AS qtab_name FROM PO_INDUCT_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'NEW_ITEM_LOC_QTAB' AS qtab_name FROM NEW_ITEM_LOC_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'UPDATE_ITEM_LOC_QTAB' AS qtab_name FROM UPDATE_ITEM_LOC_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'COST_EVENT_QTAB' AS qtab_name FROM COST_EVENT_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'COST_EVENT_THREAD_QTAB' AS qtab_name FROM COST_EVENT_THREAD_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'STKLGR_INSERT_QTAB' AS qtab_name FROM STKLGR_INSERT_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'TAX_EVENT_QTAB' AS qtab_name FROM TAX_EVENT_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'STORE_ADD_QTAB' AS qtab_name FROM STORE_ADD_QTAB UNION 
SELECT COUNT(1) AS msgs_count, 'WH_ADD_QTAB' AS qtab_name FROM WH_ADD_QTAB;

drop table asm_itens_aux;
create table asm_itens_aux as select item from item_master where 1=2;

select * from asm_itens_aux a where not exists (select 1 from item_loc il where il.item = a.item and loc = 800001);


---------RPLATUPD
--Extrair o bookmark_string
select r.restart_name, r.thread_val, r.start_time, r.restart_time, r.program_status, 
       r.restart_flag, rr.bookmark_string, rr.num_commits, rr.avg_time_btwn_commits
  from restart_program_status r, restart_bookmark rr 
 where r.restart_name = 'rplatupd'
   and r.restart_name = rr.restart_name 
   and r.thread_val = rr.thread_val;

select (3164 - 2500) * 100 from dual;

update rms.restart_control r set r.num_threads = 01 where r.program_name = 'rplatupd';
select * from rms.restart_program_status where restart_name = 'rplatupd';

insert into rms.restart_program_status  
select restart_name, 2 as thread_val, 
       null start_time, program_name, 'ready for start' program_status, null as restart_flag, null as restart_time, null as finish_time, null as current_pid,
       null as current_operator_id, null as err_message, null as current_oracle_sid, null as current_shadow_pid from rms.restart_program_status 
 where restart_name = 'rplatupd' and r.thread_val = 1;
insert into rms.restart_program_status  
select restart_name, 14, null start_time, program_name, 'ready for start' program_status, null as restart_flag, null as restart_time, null as finish_time, null as current_pid,
       null as current_operator_id, null as err_message, null as current_oracle_sid, null as current_shadow_pid from rms.restart_program_status r where restart_name = 'rplatupd' and r.thread_val = 1;

update restart_program_status r set r.program_status = 'aborted in process', r.restart_flag = 'Y' where program_status = 'started' and r.restart_name = 'rplatupd' and r.thread_val = 1 ;


--Jogar os dados na query abaixo para extrair a quantidade de registros que ainda faltam processar
      SELECT /*+ leading(vrsw, rau_loc) */ count(*)--, rau_loc.loc --316370 rows
        FROM v_restart_store_wh vrsw,
             v_rau_item_stage vris,
             repl_attr_update_loc rau_loc,
             repl_attr_update_head rau_head,
             period per
       WHERE rau_head.repl_attr_id = vris.repl_attr_id
         AND rau_loc.repl_attr_id = vris.repl_attr_id
         AND rau_head.scheduled_active_date = per.vdate
         AND NOT EXISTS (SELECT 'X'
                           FROM repl_attr_update_exclude rau_excl
                          WHERE rau_excl.repl_attr_id = rau_head.repl_attr_id
                            AND rau_excl.item = vris.item
                            AND rau_excl.location = rau_loc.loc
                            AND rau_excl.loc_type = rau_loc.loc_type
                            AND rownum = 1)
         AND EXISTS (SELECT /*+ index(il, PK_ITEM_LOC) */ 'x'
                       FROM item_loc il
                      WHERE il.item = vris.item
                        AND il.loc = rau_loc.loc
                        AND il.loc_type = rau_loc.loc_type
                        AND rownum = 1)
         AND vrsw.driver_name = 'STORE_WH'--:ps_restart_driver_name
         AND vrsw.num_threads  = 1--TO_NUMBER(:ps_restart_num_threads)
         AND vrsw.thread_val = 1--TO_NUMBER(:ps_restart_thread_val)
         AND vrsw.driver_value = rau_loc.loc
         AND ( vris.repl_attr_id > '8490009' --NVL(:ps_restart_repl_attr_id, -999)
               OR
               ( vris.repl_attr_id = '8490009'--:ps_restart_repl_attr_id
                 AND
                 ( vris.item > '100025005'--:ps_restart_item
                   OR
                   ( vris.item = '100025005'/*:ps_restart_item*/ AND (rau_loc.loc > '2425'/*:ps_restart_loc*/))
                 )
               )
             )
       --ORDER BY vris.repl_attr_id,
       --         vris.item,
       --         rau_loc.loc
       --group by rau_loc.loc
                ;
select 316370 / 100 from dual;

--rilmaint
select r.restart_name, r.thread_val, r.start_time, r.restart_time, r.program_status, 
       r.restart_flag, rr.bookmark_string, rr.num_commits, rr.avg_time_btwn_commits
  from restart_program_status r, restart_bookmark rr 
 where r.restart_name = 'rilmaint'
   and r.restart_name = rr.restart_name 
   and r.thread_val = rr.thread_val;
   
select * from rms.restart_control r where r.program_name = 'rilmaint';    --1000
select (10270 / 1000) * 6 from dual; 

   --EXEC SQL DECLARE c_driver CURSOR FOR
      SELECT --rilu.item,
             --NVL(rilu.supplier, -1),
             --NVL(rilu.origin_country_id, '-1'),
             --NVL(rilu.location, -1),
             --NVL(rilu.loc_type, '-1'),
             --DECODE(rilu.change_type, 'ILST', 'ZZZZ', rilu.change_type) /* Change type ILST should be processed last */
             count(*)
        FROM repl_item_loc_updates rilu,
             repl_item_loc ril
       WHERE rilu.change_type != 'LKITEM'
         AND ril.item (+) = rilu.item
         AND ril.location(+) = rilu.location
         AND (rilu.item > '101985090'--NVL(:ps_restart_item, ' ')
             OR ( rilu.item = '101985090'--NVL(:ps_restart_item, ' ')
                AND ( DECODE(rilu.change_type,'ILST','ZZZZ',rilu.change_type) > 'RILRC' --NVL(:ps_restart_chg_type, ' ')
                   OR (DECODE(rilu.change_type,'ILST','ZZZZ',rilu.change_type) = 'RILRC' --NVL(:ps_restart_chg_type, ' ')
                      AND NVL( rilu.location,-1) > 2280/*NVL(:ps_restart_loc,-1)*/))))
         AND NVL(ril.source_wh,rilu.location)  IN (SELECT driver_value
                                                     FROM v_restart_store_wh vsw
                                                    WHERE vsw.num_threads = 14/*:ps_restart_num_threads*/
                                                      AND vsw.thread_val = 2 /*:ps_restart_thread_val*/)
   UNION ALL
      SELECT --rilu.item,
             -- -1,
             --'-1',
             --ril.location,
             --ril.loc_type,
             --'RIL'
             count(*)
        FROM repl_item_loc_updates rilu,
             repl_item_loc ril,
             v_restart_store_wh vsw
       WHERE rilu.change_type = 'LKITEM'
         AND rilu.item        = ril.item
         AND rilu.location    = ril.location
         AND ( rilu.item  > '101985090'--NVL(:ps_restart_item, ' ')
             OR ( rilu.item = '101985090'--NVL(:ps_restart_item, ' ')
                AND ( DECODE(rilu.change_type,'LKITEM','RIL',rilu.change_type) > 'RILRC' --NVL(:ps_restart_chg_type, ' ')
                   OR ( DECODE(rilu.change_type,'LKITEM','RIL',rilu.change_type) = 'RILRC' --NVL(:ps_restart_chg_type, ' ')
                      AND NVL( ril.location,-1) > 2280 /*NVL(:ps_restart_loc,-1 )*/))))
         AND vsw.driver_value = NVL(ril.source_wh,ril.location)
         AND vsw.num_threads = 14 --:ps_restart_num_threads
         AND vsw.thread_val = 2 --:ps_restart_thread_val
    /* item, change_type, location, supplier, cntry */
    --ORDER BY 1, 6, 4, 2, 3
    ;


select * from reclass_head where reclass_no in(4861,4862) for update;
select * from reclass_item where reclass_no in(4861,4862);
select * from reclass_item where reclass_no in(4861,4862);
select * from reclass_item_temp where reclass_date >= trunc(sysdate) - 2
select * from reclass_error_log where reclass_date >= trunc(sysdate) - 2;

RECLASS_SQL.ITEM_PROCESS;

update item_master set dept = 54, class = 212, subclass = 304 where item in('197352','197352_BKS','197352_GNS','197352_WTS','5608348110723','5608348110730','5608348110747');
update item_master set dept = 62, class = 201, subclass = 306 where item in('197362','197362_CAL','5608348110884');

select * from stake_sku_loc where item in('197352','197352_BKS','197352_GNS','197352_WTS','5608348110723','5608348110730','5608348110747','197362','197362_CAL','5608348110884');

delete from reclass_item where reclass_no = 4862;
delete from reclass_head where reclass_no = 4862;
delete from reclass_item where reclass_no = 4861;
delete from reclass_head where reclass_no = 4861;



SELECT * FROM RMS.aq$COST_EVENT_QTAB ;
