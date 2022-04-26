select * from partner where partner_type = 'FF' and (partner_id LIKE '1218865%' or partner_desc like '%DP WORLD%');

SELECT * FROM ADDR WHERE KEY_VALUE_1 LIKE '1218865%';
SELECT * FROM SHIPMENT WHERE ;



RMS.EC_TABLE_PRT_AIUDR;

select * from dba_source where name = 'EC_TABLE_PRT_AIUDR';

select * from obligation where partner_id in('1218865-','65286');
select * from INVC_HEAD where partner_id in('1218865-','65286');

select * from addr where key_value_2 = '1218865-';
select * from addr where key_value_2 = '79544';
select * from addr where key_value_2 = '65286';

--01 - ALTERA PARA QUALQUER OUTRO TEMPORARIAMENTE
UPDATE obligation o set o.partner_id = '79544' where o.obligation_key in('1090021','1090022');
UPDATE invc_head p SET p.partner_id  = '79544' WHERE p.invc_id in('1395025','1395026');
UPDATE invc_head p SET p.addr_key  = '935017' WHERE p.invc_id in('1395025','1395026'); --era 1730046 05

UPDATE obligation o set o.partner_id = '65286' where o.obligation_key in('1090021','1090022');
UPDATE invc_head p SET p.partner_id  = '65286' WHERE p.invc_id in('1395025','1395026');
UPDATE invc_head p SET p.addr_key  = '1745045' WHERE p.invc_id in('1395025','1395026');

delete partner p WHERE p.partner_id = '1218865-';
delete addr p WHERE key_value_2 = '1218865-';

--02 - AJUSTA INTEGRAÇÃO E TABELA PRINCIPAL
UPDATE partner_pub_info  p SET p.partner_id = '65286' WHERE p.partner_id = '1218865-';
UPDATE partner p SET p.partner_id = '65286' WHERE p.partner_id = '1218865-';

--03 - ALTERA PARA NOVO ID
UPDATE obligation o set o.partner_id = '65286' where o.obligation_key in('1090021','1090022');
UPDATE invc_head p SET p.partner_id  = '65286' WHERE p.invc_id in('1395025','1395026');

select * from partner_pub_info p where p.partner_id = '1218865-';

RMS.IVH_PRT_FK;
RMS.IVH_ADR_FK;

select * from ordhead;


select * from obligation o where o.obligation_key in('1090021','1090022');
select * from all_triggers t where t.TABLE_NAME = 'OBLIGATION';

--------------------------
SELECT * FROM im_doc_head WHERE ext_doc_id LIKE '%002101-000003232%';
SELECT * FROM im_inject_doc_error;
SELECT * FROM im_inject_status WHERE STATUS <> 'FULL_SUCCESS' ORDER BY CREATION_DATE DESC;

SELECT * FROM im_inject_doc_error WHERE inject_id = 1657297;
SELECT * FROM im_inject_doc_head WHERE inject_id = 14106142;
SELECT * FROM im_inject_doc_head WHERE EXT_DOC_ID LIKE '%001002-000003153%';

SELECT * FROM obligation WHERE obligation_key = 965026;



declare
  o_error_message varchar2(4000);
  l_obligation_key obligation.obligation_key%type := null;
   l_invc_id invc_head.invc_id%TYPE := NULL;
  l_text varchar2(4000);
  
  cursor c_obl is
    select obligation_key,
           obligation_level,
           key_value_1,
           key_value_2,
           key_value_3,
           key_value_4,
           key_value_5,
           key_value_6,
           ext_invc_no,
           ext_invc_date,
           currency_code,
           exchange_rate,
           supplier,
           partner_type,
           partner_id
      from obligation
     where obligation_key in('1090021','1090022') and status = 'A';

  cursor c_invc(p_obligation_key obligation.obligation_key%TYPE) is
    select invc_id from invc_head where obligation_key = p_obligation_key;
        
  cursor c_alc(p_obligation_key obligation.obligation_key%type) is
    select 'order_no:' || alc_head.order_no ||
                 ' / ' || 'item:' || alc_head.item ||
                 ' / ' || 'status:' || alc_head.status ||
                 ' / ' || 'ALC_QTY:' || alc_head.alc_qty ||
                 ' / ' || 'ERROR_IND:' || alc_head.error_ind from alc_head where obligation_key = p_obligation_key;
      
begin

  ---update obligation set status = 'A' where obligation_key not in (select obligation_key from invc_head where obligation_key is not null) and status = 'P' and obligation_key in (315048, 315049, 315050);

  for c_obl_rec in c_obl
  loop
    l_obligation_key := c_obl_rec.obligation_key;
    dbms_output.put_line('Attempting obligation_key => '||c_obl_rec.obligation_key ||
                         ' obligation_level => '||c_obl_rec.obligation_level ||
                         ' | key_value_1 => '||c_obl_rec.key_value_1 ||
                         ' | key_value_2 => '||c_obl_rec.key_value_2 ||
                         ' | key_value_3 => '||c_obl_rec.key_value_3 ||
                         ' | key_value_4 => '||c_obl_rec.key_value_4 ||
                         ' | key_value_5 => '||c_obl_rec.key_value_5 ||
                         ' | key_value_6 => '||c_obl_rec.key_value_6 );
    if not alc_alloc_sql.alloc_all_obl_comps(o_error_message => o_error_message,
                                              i_obligation_key => c_obl_rec.obligation_key,
                                              i_obligation_level => c_obl_rec.obligation_level,
                                              i_key_value_1 => c_obl_rec.key_value_1,
                                              i_key_value_2 => c_obl_rec.key_value_2,
                                              i_key_value_3 => c_obl_rec.key_value_3,
                                              i_key_value_4 => c_obl_rec.key_value_4,
                                              i_key_value_5 => c_obl_rec.key_value_5,
                                              i_key_value_6 => c_obl_rec.key_value_6)
    then
      dbms_output.put_line('Error message while allocating ALC: ' || o_error_message);

    else
      if not invc_rtm_sql.obl_invc_write(o_error_message => o_error_message,
                                          i_obligation_key => c_obl_rec.obligation_key,
                                          i_ext_invc_no => c_obl_rec.ext_invc_no,
                                          i_ext_invc_date => c_obl_rec.ext_invc_date,
                                          i_currency_code => c_obl_rec.currency_code,
                                          i_exchange_rate => c_obl_rec.exchange_rate,
                                          i_supplier => c_obl_rec.supplier,
                                          i_partner_type => c_obl_rec.partner_type,
                                          i_partner_id => c_obl_rec.partner_id)
      then
        dbms_output.put_line('Error message: ' || o_error_message);
      else
        dbms_output.put_line('SUCCESS' ||
                             ' | ext_invc_no => '||c_obl_rec.ext_invc_no ||
                             ' | ext_invc_date => '||c_obl_rec.ext_invc_date ||
                             ' | currency_code => '||c_obl_rec.currency_code ||
                             ' | exchange_rate => '||c_obl_rec.exchange_rate ||
                             ' | supplier => '||c_obl_rec.supplier ||
                             ' | partner_type => '||c_obl_rec.partner_type ||
                             ' | partner_id => '||c_obl_rec.partner_id );
      end if;
    end if;
      open c_invc(l_obligation_key);
      loop
         fetch c_invc into l_invc_id;

         exit when c_invc%notfound;
         dbms_output.put_line('Invoice_id: ' || l_invc_id );
      end loop;
      close c_invc;

      open c_alc(l_obligation_key);
      loop
         fetch c_alc into l_text;
         exit when c_alc%notfound;
         dbms_output.put_line('ALC exists: ' || l_text );
      end loop;
      close c_alc;
      
      l_text := null;
      l_invc_id := null;
      l_obligation_key := null;
  end loop;
end;
/

select * from ordloc where order_no = '5001270757';
--------------------------
declare
    O_error_message varchar2(4000);
    L_obligation_key obligation.obligation_key%TYPE := NULL;
    L_invc_id invc_head.invc_id%TYPE := NULL;
    L_oblig_key_inv obligation.obligation_key%TYPE := NULL;
    L_text varchar2(4000);
    
  cursor c_obl is
        select obligation_key,
                obligation_level,
               key_value_1,
           key_value_2,
           key_value_3,
           key_value_4,
           key_value_5,
           key_value_6,
                     ext_invc_no,
                     ext_invc_date,
                     currency_code,
                     exchange_rate,
                     supplier,
                     partner_type,
                     partner_id
            from obligation
         where 1=1
           --AND obligation_key not in (select obligation_key from invc_head where obligation_key is not null)
                     and status = 'A'
                     AND obligation_key IN (1090021,1090022);
                     
  cursor c_invc(p_obligation_key obligation.obligation_key%TYPE) is
    select invc_id from invc_head where obligation_key = p_obligation_key;
    
    cursor c_alc(p_obligation_key obligation.obligation_key%TYPE) is
    select alc_head.order_no || ':' || alc_head.item || ':' || alc_head.status from alc_head where obligation_key = p_obligation_key;
             
BEGIN
    
  UPDATE OBLIGATION SET OBLIGATION_LEVEL = 'PO'
    WHERE 1=1
      and status = 'A' and obligation_level = 'POT' AND obligation_key IN (1090021,1090022);
      --and obligation_key not in (select obligation_key from invc_head where obligation_key is not null) 
    
    UPDATE ORDLOC SET QTY_ORDERED = 22800 WHERE ORDER_NO = 5001270757 AND ITEM = 314015000;

  UPDATE ORDLOC SET QTY_ORDERED = 825 WHERE ORDER_NO = 5001270757 AND ITEM = 314017000;

  
  for c_obl_rec in c_obl
  LOOP
        L_obligation_key := c_obl_rec.obligation_key;
        dbms_output.put_line('Attempting obligation_key => '||c_obl_rec.obligation_key ||
                             ' obligation_level => '||c_obl_rec.obligation_level ||
                         ' | key_value_1 => '||c_obl_rec.key_value_1 ||
                         ' | key_value_2 => '||c_obl_rec.key_value_2 ||
                         ' | key_value_3 => '||c_obl_rec.key_value_3 ||
                         ' | key_value_4 => '||c_obl_rec.key_value_4 ||
                         ' | key_value_5 => '||c_obl_rec.key_value_5 ||
                         ' | key_value_6 => '||c_obl_rec.key_value_6 );
      IF NOT ALC_ALLOC_SQL.ALLOC_ALL_OBL_COMPS(O_error_message => O_error_message,
                                              I_obligation_key => c_obl_rec.obligation_key,
                                              I_obligation_level => c_obl_rec.obligation_level,
                                              I_key_value_1 => c_obl_rec.key_value_1,
                                              I_key_value_2 => c_obl_rec.key_value_2,
                                              I_key_value_3 => c_obl_rec.key_value_3,
                                              I_key_value_4 => c_obl_rec.key_value_4,
                                              I_key_value_5 => c_obl_rec.key_value_5,
                                              I_key_value_6 => c_obl_rec.key_value_6)
        THEN
            dbms_output.put_line('Error message while allocating ALC: ' || O_error_message);

        ELSE
            if not INVC_RTM_SQL.OBL_INVC_WRITE(O_error_message => O_error_message,
                                                                                    I_obligation_key => c_obl_rec.obligation_key,
                                                                                    I_ext_invc_no => c_obl_rec.ext_invc_no,
                                                                                    I_ext_invc_date => c_obl_rec.ext_invc_date,
                                                                                    I_currency_code => c_obl_rec.currency_code,
                                                                                    I_exchange_rate => c_obl_rec.exchange_rate,
                                                                                    I_supplier => c_obl_rec.supplier,
                                                                                    I_partner_type => c_obl_rec.partner_type,
                                                                                    I_partner_id => c_obl_rec.partner_id)
            THEN
                dbms_output.put_line('Error message: ' || O_error_message);
            ELSE
                dbms_output.put_line('SUCCESS' ||
                                                         ' | ext_invc_no => '||c_obl_rec.ext_invc_no ||
                                                         ' | ext_invc_date => '||c_obl_rec.ext_invc_date ||
                                                         ' | currency_code => '||c_obl_rec.currency_code ||
                                                         ' | exchange_rate => '||c_obl_rec.exchange_rate ||
                                                         ' | supplier => '||c_obl_rec.supplier ||
                                                         ' | partner_type => '||c_obl_rec.partner_type ||
                                                         ' | partner_id => '||c_obl_rec.partner_id );
            END IF;
            
        END IF;
        
        UPDATE ORDLOC SET QTY_ORDERED = 0 WHERE ORDER_NO = 5000150290 AND ITEM = 169648000;

        UPDATE ORDLOC SET QTY_ORDERED = 0 WHERE ORDER_NO = 5000150290 AND ITEM = 169649000;

        UPDATE ORDLOC SET QTY_ORDERED = 0 WHERE ORDER_NO = 5000150290 AND ITEM = 169650000;

          open c_invc(L_obligation_key);
      LOOP
                FETCH c_invc into L_invc_id;
        EXIT WHEN c_invc%notfound;
                dbms_output.put_line('Created Invoice_id: ' || L_invc_id );
      END LOOP;
      close c_invc;

            open c_alc(L_obligation_key);
      LOOP
        FETCH c_alc into L_text;
        EXIT WHEN c_alc%notfound;
                dbms_output.put_line('ALC exists: ' || L_text );
      END LOOP;
      close c_alc;
            
      L_text := NULL;
          L_invc_id := NULL;
        L_obligation_key := NULL;
    end loop;

end;
