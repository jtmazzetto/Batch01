--RMS 1074  31206 ACTIVE  apprms  prd-mom-db01  ordupd@prd-mom-db01 (TNS V1-V3) ordupd  Thread 1  26/01/2022 04:10:33 1 0000000FB8F43868  43171911  0000000FA8D2B168  123 3 2147483644  0000000F9CAC9FA0    DEDICATED 123 RMS 73989 37304   USER  0000000F11670B78  2620037321  4rtkjzyf2p669 0 26/01/2022 04:50:37 16777248  0000000606852648  3877627537  fyksdhzmjztnj 0 26/01/2022 04:50:37 16777247          253870289 1847618474    360771693 216796  102 1276149 0 78  20  NO  NONE  NONE  NO  OTHER_GROUPS  DISABLED  ENABLED ENABLED 0   UNKNOWN     UNKNOWN     9575  215 direct path write temp  file number 208 00000000000000D0  first dba 4076191 00000000003E329F  block cnt 31  000000000000001F  1740759767  8 User I/O  0 0 WAITING 0 -1  0 MOM DISABLED  FALSE FALSE FIRST EXEC  133 0000000FA8D2B168  42    0 53601280  0 
--sql_id 4rtkjzyf2p669

WITH phist AS
 (SELECT /*+ MATERIALIZE +*/
   item, unit_retail, loc, action_date
    FROM price_hist ph
   WHERE loc = TO_NUMBER(:b0)
     AND tran_type IN (4, 8, 11)
     AND ph . action_date = TO_DATE(:b1, 'YYYYMMDD'))
SELECT DISTINCT C_TYPE,
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
  FROM (SELECT distinct TO_CHAR(oh . otb_eow_date, 'YYYYMMDD') otb_eow_date,
                        oh . order_no,
                        oh . currency_code,
                        oh . order_type,
                        oh . status,
                        olph . C_TYPE,
                        olph . PACK_NO,
                        olph . unit_retail_diff,
                        olph . qty_diff,
                        olph . item,
                        olph . loc_type,
                        olph . location,
                        olph . pack_qty,
                        olph . unit_retail,
                        olph . ol_rowid
          FROM (SELECT 'S' C_TYPE,
                       '0' pack_no,
                       NVL(ph . unit_retail, 0) - NVL(ol . unit_retail, 0) unit_retail_diff,
                       NVL(ol . qty_ordered, 0) - NVL(ol . qty_received, 0) qty_diff,
                       ph . item,
                       ol . loc_type,
                       ol . location,
                       0 pack_qty,
                       NVL(ph . unit_retail, 0) unit_retail,
                       ol . order_no,
                       ROWIDTOCHAR(ol . rowid) ol_rowid
                  FROM phist ph, ordloc ol
                 WHERE ph . item = ol . item
                   AND ol . location = TO_NUMBER(:b0)
                   and ph . loc = ol . location
                UNION ALL
                SELECT 'P',
                       vpq . pack_no,
                       NVL(ol . unit_retail, 0),
                       vpq . qty * (NVL(ol . qty_ordered, 0) - NVL(ol . qty_received, 0)),
                       ph . item,
                       ol . loc_type,
                       ol . location,
                       vpq . qty pack_qty,
                       NVL(ph . unit_retail, 0),
                       ol . order_no,
                       ROWIDTOCHAR(ol . rowid) ol_rowid
                  FROM phist ph, v_packsku_qty vpq, ordloc ol
                 WHERE ol . item = vpq . pack_no
                   AND ph . item = vpq . item
                   AND ol . location = TO_NUMBER(:b0)
                   and ph . loc = ol . location
                UNION ALL
                SELECT 'S',
                       '0' pack_no,
                       NVL(eph . unit_retail, 0) - NVL(ol . unit_retail, 0),
                       NVL(ol . qty_ordered, 0) - NVL(ol . qty_received, 0),
                       eph . item,
                       ol . loc_type,
                       ol . location,
                       0 pack_qty,
                       NVL(eph . unit_retail, 0),
                       ol . order_no,
                       ROWIDTOCHAR(ol . rowid) ol_rowid
                  FROM emer_price_hist eph, ordloc ol
                 WHERE eph . item = ol . item
                   AND eph . loc = ol . location
                   AND ol . location = TO_NUMBER(:b0)
                   AND eph . tran_type in (4, 8, 11)
                   AND eph . action_date = TO_DATE(:b1, 'YYYYMMDD') - 1
                   AND NOT EXISTS
                 (SELECT 'X'
                          FROM phist ph
                         WHERE eph . item = ph . item
                           AND eph . loc = ph . loc
                           AND eph . action_date = ph . action_date - 1)
                UNION ALL
                SELECT 'P',
                       vpq . pack_no,
                       NVL(ol . unit_retail, 0),
                       vpq . qty * (NVL(ol . qty_ordered, 0) - NVL(ol . qty_received, 0)),
                       eph . item,
                       ol . loc_type,
                       ol . location,
                       vpq . qty pack_qty,
                       NVL(eph . unit_retail, 0),
                       ol . order_no,
                       ROWIDTOCHAR(ol . rowid) ol_rowid
                  FROM emer_price_hist eph, v_packsku_qty vpq, ordloc ol
                 WHERE ol . item = vpq . pack_no
                   AND eph . item = vpq . item
                   AND eph . loc = ol . location
                   AND ol . location = TO_NUMBER(:b0)
                   AND eph . tran_type in (4, 8, 11)
                   AND eph . action_date = TO_DATE(:b1, 'YYYYMMDD') - 1
                   AND NOT EXISTS
                 (SELECT 'X'
                          FROM phist ph
                         WHERE eph . item = ph . item
                           AND eph . loc = ph . loc
                           AND eph . action_date = ph . action_date - 1)) olph,
               ordhead oh
         WHERE oh . order_no = olph . order_no
           AND oh . status in ('W', 'S', 'A')
         ORDER BY ol_rowid);
         
PRF_WF_RECALC_SQL.AUTO_RECALC_15MIN;

select * from dba_objects where object_name = 'PRF_WF_UPLD_SEQ';
select * from dba_sequences where sequence_name = 'PRF_WF_UPLD_SEQ';

SELECT WAC.UPLOAD_ID, CPL.ITEM, WAC.TO_LOC, WAC.TO_LOC_TYPE, CPL.WF_PRC_PRICING_COST, CPL.WF_PRC_PRICING_COST_CURR
      FROM PRF_LOG_MISSING_WAC_PROC_INFO WAC, PRF_WF_CUST_PRICE_LIST CPL
     WHERE WAC.PROCESSED_IND = 'Y'
       --AND WAC.UPLOAD_ID = '58562' --O_UPLOAD_ID
       AND CPL.WF_PRICE_LIST_VERSION_ID = WAC.UPLOAD_ID
       AND CPL.ITEM                     = WAC.ITEM
       AND CPL.WF_CUSTOMER_ID           = WAC.CUSTOMER;


select * from tsfhead 
 where tsf_no in('3004268968','3004269135','3004269277',
                 '3004269109','3004269205','3004269276','3004269108',
                 '3004269236','3004269068','3004268098',
                 '3004269075','3004269243',
                 '3004269180'
                 );
select * from tsfdetail 
 where tsf_no in(--'3004268968','3004269135','3004269277','3004269109','3004269205','3004269276','3004269108',
                 --'3004269236','3004269068','3004268098',
                 '3004269075','3004269243'
                 );
                 

select * from item_loc_soh ils where ils.loc in('1200','800051') and ils.item = '100130023';

declare 
   cursor C_drive is 
      select * from tsfhead 
       where 1=1
         --and status = 'C'
         and tsf_no in(--'3004268968','3004269135','3004269277',
                       --'3004269109','3004269205','3004269276','3004269108',
                       --'3004269236','3004269068','3004268098',
                       --'3004269075','3004269243'
                       '3004269180');
begin
   for C_rec in C_drive loop
      update tsfhead th 
         set status = 'A', 
             th.close_date = null,
             th.not_after_date = to_date('14022022','DDMMYYYY')
       where 1=1
         --and status = 'C'
         and tsf_no = C_rec.tsf_no;
      for C_rec2 in(select * from tsfdetail 
                     where tsf_no = C_rec.tsf_no
                       and cancelled_qty <> 0) loop
         update tsfdetail td 
            set td.tsf_qty = C_rec2.cancelled_qty, td.cancelled_qty = 0
          where tsf_no = C_rec2.tsf_no
            and item = C_rec2.item;
         update item_loc_soh ils 
            set ils.tsf_expected_qty = ils.tsf_expected_qty + C_rec2.cancelled_qty
          where loc = C_rec.to_loc
            and item = C_rec2.item;
         update item_loc_soh ils 
            set ils.tsf_reserved_qty = ils.tsf_reserved_qty + C_rec2.cancelled_qty
          where loc = C_rec.from_loc
            and item = C_rec2.item;
      end loop;
   end loop;
end;
/

select * from tsf@prodmom_to_simprod 
 where external_id in(--'3004268968','3004269135','3004269277',
                      --'3004269109','3004269205','3004269276','3004269108',
                      --'3004269236','3004269068','3004268098',
                      --'3004269075','3004269243'
                      '3004269180'
                      );
select * from all_tables@prodmom_to_simprod where table_name like '%TSF%';
select * from TSF_LINE_ITEM@prodmom_to_simprod 
 where tsf_id in('134880','134708');

update tsf@prodmom_to_simprod 
   set not_after_date = to_date('14022022','DDMMYYYY'),
       status = 7
 where external_id in(--'3004268968','3004269135','3004269277',
                      --'3004269109','3004269205','3004269276','3004269108',
                      --'3004269236','3004269068','3004268098',
                      --'3004269075','3004269243'
                      '3004269180');
