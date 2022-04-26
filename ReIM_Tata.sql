select /*+parallel(8)*/ --count(1)
* 
from logger_logs_60_min 
where 1=1
--and time_stamp>SYSDATE-10/3600 
and client_identifier='REIM_BATCH' 
order by time_stamp desc;

select /*+parallel(8)*/ --count(1)
* 
from logger_logs_60_min
where 1=1
and text like '%I_workspace_id%'
order by time_stamp desc;

'REIM_AUTO_MATCH_SQL.PERSIST_SUMMARY_MATCH_DATA'


--sql_lib.create_msg message:@0PACKAGE_ERROR@1ORA-00001: unique constraint (RMS.PK_IM_PART_MATCHED_RECEIPTS) violated@2REIM_AUTO_MATCH_SQL.PERSIST_SUMMARY_MATCH_DATA
--SHIPMENT, ITEM
RMS.REIM_AUTO_MATCH_SQL;

select * from IM_PARTIALLY_MATCHED_RECEIPTS;


 select rd.shipment,
                 rd.item,
                 rd.qty_available qty_matched
            from gtt_num_num_str_str_date_date gtt,
                 im_match_rcpt_detl_ws rd
           where gtt.varchar2_1                    = rd.match_group_id;

select max(workspace_id) from im_match_group_head_ws gh;

--01
   insert into gtt_num_num_str_str_date_date (number_1, number_2, varchar2_1)
   select gh.match_key_id,
          im_summary_match_history_seq.nextval,
          gh.match_group_id
     from im_match_group_head_ws gh
    where gh.workspace_id = 1233740 --I_workspace_id
      --and gh.match_luw_id = I_match_luw_id
      --and gh.match_key_id = nvl(I_match_key_id,gh.match_key_id)
      --and gh.match_status = REIM_CONSTANTS.DOC_STATUS_MTCH
      --and gh.match_type   IN (REIM_CONSTANTS.MATCH_LEVEL_SUMM_ALL_2_ALL,
      --                        REIM_CONSTANTS.MATCH_LEVEL_SUMM_1_2_MANY)
      --                        ;
--02
   merge into im_partially_matched_receipts target
   using (select rd.shipment,
                 rd.item,
                 rd.qty_available qty_matched
            from gtt_num_num_str_str_date_date gtt,
                 im_match_rcpt_detl_ws rd
           where gtt.varchar2_1                    = rd.match_group_id
   ) use_this
   on (    target.shipment = use_this.shipment
       and target.item     = use_this.item)
   when matched then update
    set target.qty_matched       = target.qty_matched + use_this.qty_matched,
        target.last_updated_by   = user,
        target.last_update_date  = sysdate,
        target.object_version_id = target.object_version_id + 1 --REIM_CONSTANTS.ONE
   when not matched then insert (shipment,
                                 item,
                                 qty_matched,
                                 created_by,
                                 creation_date,
                                 last_updated_by,
                                 last_update_date,
                                 object_version_id)
                         values (use_this.shipment,
                                 use_this.item,
                                 use_this.qty_matched,
                                 user,
                                 sysdate,
                                 user,
                                 sysdate,
                                 1 --REIM_CONSTANTS.ONE
                                 );
--03
select rd.shipment,
        rd.item, max(rd.match_group_id ), min(rd.match_group_id), count(*)
   from gtt_num_num_str_str_date_date gtt,
        im_match_rcpt_detl_ws rd
  where gtt.varchar2_1                    = rd.match_group_id 
 group by rd.shipment,
          rd.item having count(*) > 1;
select *
            from gtt_num_num_str_str_date_date gtt,
                 im_match_rcpt_detl_ws rd
           where gtt.varchar2_1                    = rd.match_group_id 
          and shipment = '1842796' and item = '1000041739';


   merge into im_partially_matched_receipts target
   using (select rd.shipment,
                 rd.item,
                 rd.qty_available qty_matched
            from gtt_num_num_str_str_date_date gtt,
                 im_match_rcpt_detl_ws rd
           where gtt.varchar2_1                    = rd.match_group_id
   ) use_this
   on (    target.shipment = use_this.shipment
       and target.item     = use_this.item)
   when matched then update
    set target.qty_matched       = target.qty_matched + use_this.qty_matched,
        target.last_updated_by   = user,
        target.last_update_date  = sysdate,
        target.object_version_id = target.object_version_id + 1 --REIM_CONSTANTS.ONE
   when not matched then insert (shipment,
                                 item,
                                 qty_matched,
                                 created_by,
                                 creation_date,
                                 last_updated_by,
                                 last_update_date,
                                 object_version_id)
                         values (use_this.shipment,
                                 use_this.item,
                                 use_this.qty_matched,
                                 user,
                                 sysdate,
                                 user,
                                 sysdate,
                                 1 --REIM_CONSTANTS.ONE
                                 );
                                 
select * from im_match_group_head_ws where match_group_id = 7991440;

--02
create table cms_im_match_rcpt_detl_ws as
select * from im_match_rcpt_detl_ws where   match_group_id = '7991440' and item = '1000041739';       
--03
delete from im_match_rcpt_detl_ws where   match_group_id = '7991440' and item = '1000041739';       
insert into im_match_rcpt_detl_ws 
select t.workspace_id, t.shipment, t.item, t.substitute_item, t.match_key_id, t.chunk_num, t.match_luw_id, t.invc_match_status, max(unit_cost), sum(qty_received), sum(qty_available), max(unit_cost_nc),
 sum(t.qty_available_nc),
 t.catch_weight_type, t.choice_flag, t.match_group_id, t.match_hist_id, t.item_parent, t.vpn, t.deals_exist
  from cms_im_match_rcpt_detl_ws t
  group by t.workspace_id, t.shipment, t.item, t.substitute_item, t.match_key_id, t.chunk_num, t.match_luw_id, t.invc_match_status, t.catch_weight_type, t.choice_flag, t.match_group_id, t.match_hist_id, t.item_parent, t.vpn, t.deals_exist
  
  select * from shipsku where shipment = 1842796 and item = '1000041739';
  
delete from shipsku where shipment = 1842796 and item = '1000041739';  
insert into shipsku
select shipment,
seq_no,
item,
distro_no,
distro_type,
ref_item,
carton,
inv_status,
status_code,
qty_received,
unit_cost,
unit_retail,
qty_expected,
match_invc_id,
adjust_type,
actual_receiving_store,
reconcile_user_id,
reconcile_date,
tampered_ind,
dispositioned_ind,
qty_matched,
weight_received,
weight_received_uom,
weight_expected,
weight_expected_uom,
orig_matched_cost,
invc_match_status,
from shipsku where shipment = 1842796 and item = '1000041739';  
