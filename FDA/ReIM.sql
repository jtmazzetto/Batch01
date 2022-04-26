select /*+parallel(8)*/
       *
  from logger_logs_5_min
 where 1=1
  and upper(text) like '%REIM_AUTO_MATCH_SQL%' --585938407
   --and client_identifier='REIM_BATCH'
 order by time_stamp desc;

--REIM_AUTO_MATCH_SQL.END_MATCH-59455~TIMING~0~0~.223001~223
--sql_lib.create_msg message:@0PACKAGE_ERROR@1ORA-00001: unique constraint (RMS.PK_IM_RECEIVER_COST_ADJUST) violated@2REIM_AUTO_MATCH_SQL.PERSIST_SKU_LVL_DETL_MATCH

--REIM_AUTO_MATCH_SQL.PERSIST_SKU_LVL_DETL_MATCH I_workspace_id: 79745 I_match_luw_id: 1

--IM_RECEIVER_COST_ADJUST
select * from IM_RECEIVER_COST_ADJUST;

--drop table asm_0039161
--create table asm_0039161 as 
   select ol.ORDER_NO, ol.ITEM, ol.LOCATION, sh.SHIPMENT
     from im_resolution_action_ws ra,
          im_match_group_head_ws gh,
          im_match_group_rcpt_ws gr,
          im_reason_codes irc,
          --
          (select wh loc, physical_wh phy_loc, 'W' loc_type from wh where physical_wh != wh
           union all
           select store loc, store phy_loc, 'S' loc_type from store) loc,
          --
          shipment sh,
          ordhead oh,
          ordloc ol
    where ra.workspace_id      = 59455 --I_workspace_id
      --and ra.match_luw_id      = 742256 --I_match_luw_id
      and ra.workspace_id      = gh.workspace_id
      and ra.match_group_id    = gh.match_group_id
      and ra.match_luw_id      = gh.match_luw_id
      and gh.workspace_id      = gr.workspace_id
      and gh.rcpt_group_id     = gr.rcpt_group_id
      and gh.match_luw_id      = gr.match_luw_id
      --
      and ra.reason_code_id    = irc.reason_code_id
      and irc.reason_code_type = 'C'
      and irc.action           in ('RCA', 'RCAS','RCAMR','RCAMRS')
      --
      and gr.shipment          = sh.shipment
      and oh.order_no          = sh.order_no
      and sh.to_loc            = loc.phy_loc
      and loc.loc              = ol.location
      and ol.order_no          = oh.order_no
      and ol.item              = gh.item
      --
      and exists (SELECT 1 FROM tran_data t where t.ref_no_1 = ol.order_no and t.ITEM = ol.item and t.ADJ_CODE = 'C')
      and exists (select 1 from im_receiver_cost_adjust i 
                   where i.ORDER_NO = ol.ORDER_NO 
                     and i.item = ol.ITEM 
                     and i.location = ol.LOCATION 
                     and i.shipment = sh.SHIPMENT);
                     
select * from cost_susp_sup_head where active_date > sysdate - 2;

select * from im_receiver_cost_adjust where creation_date >= sysdate - 1;


SELECT * FROM tran_data where ref_no_1 = 3140064;

select * from im_resolution_action i
 where action = 'R';



select /*+parallel(8)*/
*
from logger_logs--_5_min
where 1=1
  --and upper(text) like '%RPM%' --585938407
  and upper(unit_name) like '%KICK%' --MERCH_EXTRACT_KICKOFF_BATCH 
  --and client_identifier not in('REIM_BATCH','ANONYMOUS','RESA_ADMIN')
order by time_stamp desc;


select sysdate from dual;




select table_name, stale_stats, last_analyzed
from dba_tab_statistics
where table_name like UPPER('%IM%') and stale_stats='YES';

--------------
--REIM_AUTO_MATCH_SQL.END_MATCH-79734~TIMING~0~0~.057698~58
--sql_lib.create_msg message:@0PACKAGE_ERROR@1ORA-01400: cannot insert NULL into ("RMS"."IM_MATCH_GROUP_RCPT_WS"."RCPT_GROUP_ID")@2REIM_AUTO_MATCH_SQL.PERFORM_SKU_LVL_DETL_MATCH
rms.REIM_AUTO_MATCH_SQL.PERFORM_SKU_LVL_DETL_MATCH;

--sql_lib.create_msg message:@0PACKAGE_ERROR@1ORA-01400: cannot insert NULL into ("RMS"."IM_MATCH_GROUP_RCPT_WS"."RCPT_GROUP_ID")@2REIM_AUTO_MATCH_SQL.PERFORM_SKU_LVL_DETL_MATCH

   /*insert into im_match_group_rcpt_ws(rcpt_group_id,
                                      shipment,
                                      workspace_id,
                                      match_stgy_id,
                                      match_stgy_dtl_id,
                                      chunk_num,
                                      match_luw_id,
                                      match_key_id)*/
   select /*+ INDEX(MR IM_MATCH_RCPT_DETL_WS_I3) */ distinct gtt.rcpt_group_id,
                   mr.shipment,
                   --I_workspace_id,
                   -1 match_stgy_id,
                   --I_match_stgy_dtl_id,
                   --I_chunk_num,
                   --I_match_luw_id,
                   gtt.match_key_id
     from (select distinct match_key_id,
                           rcpt_group_id,
                           item
             from im_match_detail_ids_gtt) gtt,
          im_match_rcpt_detl_ws mr
    where mr.workspace_id      = 79736 --I_workspace_id
      --and mr.match_luw_id      = 1 --I_match_luw_id
      --and mr.chunk_num         = I_chunk_num
      and mr.match_key_id      = gtt.match_key_id
      and mr.item              = gtt.item
      and mr.invc_match_status = 'U'--REIM_CONSTANTS.SSKU_IM_STATUS_UNMTCH
      ;


select * from im_match_rcpt_detl_ws mr
    where 1=1
      and mr.workspace_id      = 79736; 
      

select distinct invc_match_status from im_match_rcpt_detl_ws mr ;
create table im_match_rcpt_detl_ws_20220326 as 
select * from im_match_rcpt_detl_ws mr where mr.match_key_id is null;

update im_match_rcpt_detl_ws t set t.invc_match_status = 'U'
 where exists (select 'x' from im_match_rcpt_detl_ws_20220326 tt 
                where tt.workspace_id = t.workspace_id 
                  and tt.shipment = t.shipment 
                  and tt.item = t.item 
                  and tt.invc_match_status = 'U' 
                  and tt.match_key_id is null);

update /*+parallel(8)*/  im_doc_head SET status ='WKSHT' where doc_id ;


select * from im_doc_head_bkp ;


--01A 
create table temp_1 as                  
select i.match_key_id,
                  i.doc_id,
                  i.item,
                  --i.item_ctr,
                  gtt.rcpt_group_id,
                  gtt.unit_cost_nc
             from (select /*+ FULL(IW) INDEX(MIW IM_MATCH_INVC_WS_I22 */
                          iw.match_key_id,
                          iw.doc_id,
                          iw.item,
                          miw.due_date,
                          iw.unit_cost,
                          iw.ordloc_unit_cost--,
                     from im_match_invc_detl_ws iw,
                          im_match_invc_ws miw
                    where iw.workspace_id      = 79737 --I_workspace_id
                      --and iw.match_luw_id      = I_match_luw_id
                      --and iw.chunk_num         = I_chunk_num
                      and iw.status            = 'UNMTCH' --REIM_CONSTANTS.DOC_ITEM_STATUS_UNMTCH
                      and iw.workspace_id      = miw.workspace_id
                      and iw.doc_id            = miw.doc_id
                      and (   miw.detail_mtch_elig = 'Y'
                           or /*L_delay_detl_match*/'Y'   = 'N') ) i,
                  im_match_detail_rcpt_gtt gtt
            where i.match_key_id     = gtt.match_key_id(+)
              and i.item             = gtt.item(+)
              and i.ordloc_unit_cost = gtt.unit_cost_nc(+)
            order by i.item, i.due_date, gtt.unit_cost_nc;
            
--02A
create table im_doc_head_bkp as
select * from im_doc_head where doc_id in(select doc_id from temp_1);

--03A
update im_doc_head i set i.status = 'POSTED' where doc_id in(select distinct doc_id from temp_1);
select * from im_doc_head i where doc_id in(select doc_id from temp_1);

declare 
   cursor C_drive is
      select * from im_doc_head_bkp ;
begin 
   for C_rec in C_drive loop
      update im_doc_head i set i.status = C_rec.status 
       where i.doc_id = C_rec.doc_id 
         and i.type = C_rec.type
         and i.order_no = C_rec.order_no
         and i.status <> C_rec.status;
   end loop;
end;
/
            

         

select* from shipment where shipment = '2011055';

   select /*+ INDEX(MR IM_MATCH_RCPT_DETL_WS_I3) */ distinct gtt.rcpt_group_id,
                   mr.shipment--,
                   --I_workspace_id,
                   ---1 match_stgy_id,
                   --I_match_stgy_dtl_id,
                   --I_chunk_num,
                   --I_match_luw_id,
                   --gtt.match_key_id
     from (select distinct match_key_id,
                           rcpt_group_id,
                           item
             from (select i.match_key_id,
                  i.doc_id,
                  i.item,
                  --i.item_ctr,
                  gtt.rcpt_group_id,
                  gtt.unit_cost_nc
             from (select /*+ FULL(IW) INDEX(MIW IM_MATCH_INVC_WS_I22 */
                          iw.match_key_id,
                          iw.doc_id,
                          iw.item,
                          miw.due_date,
                          iw.unit_cost,
                          iw.ordloc_unit_cost--,
                          --case when count(distinct iw.unit_cost) over (partition by iw.match_key_id,
                          --                                                          iw.item) > REIM_CONSTANTS.ONE then
                          --        REIM_CONSTANTS.ONE
                          --else
                          --   count(iw.doc_id) over (partition by iw.match_key_id,
                          --                                       iw.item,
                          --                                       iw.unit_cost)
                          --end item_ctr
                     from im_match_invc_detl_ws iw,
                          im_match_invc_ws miw
                    where iw.workspace_id      = 79737 --I_workspace_id
                      --and iw.match_luw_id      = I_match_luw_id
                      --and iw.chunk_num         = I_chunk_num
                      and iw.status            = 'UNMTCH' --REIM_CONSTANTS.DOC_ITEM_STATUS_UNMTCH
                      and iw.workspace_id      = miw.workspace_id
                      and iw.doc_id            = miw.doc_id
                      and (   miw.detail_mtch_elig = 'Y'
                           or /*L_delay_detl_match*/'Y'   = 'N') ) i,
                  im_match_detail_rcpt_gtt gtt
            where i.match_key_id     = gtt.match_key_id(+)
              and i.item             = gtt.item(+)
              and i.ordloc_unit_cost = gtt.unit_cost_nc(+)
            order by i.item, i.due_date, gtt.unit_cost_nc)) gtt,
          im_match_rcpt_detl_ws mr
    where mr.workspace_id      = 79737 --I_workspace_id
      and mr.match_luw_id      = 1 --I_match_luw_id
      --and mr.chunk_num         = I_chunk_num
      and mr.match_key_id      = gtt.match_key_id
      and mr.item              = gtt.item
      and mr.invc_match_status = 'U'--REIM_CONSTANTS.SSKU_IM_STATUS_UNMTCH
      and gtt.rcpt_group_id is null 
      ;
