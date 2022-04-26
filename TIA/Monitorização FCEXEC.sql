--1º FAZER ESTES BACKUPS DEPOIS DO PREPOST FCEXEC EXECUTAR

create table cost_event_bkp2207 as
SELECT ce.*--ce.COST_EVENT_PROCESS_ID,ce.action,ct.thread_id, cr.status
FROM cost_event ce, cost_event_thread ct, cost_event_result cr
WHERE ce.cost_event_process_id = ct.cost_event_process_id(+)
AND ce.cost_event_process_id = cr.cost_event_process_id(+)
AND ct.thread_id = cr.thread_id
--and ct.cost_event_process_id in (4975432,4975433)
--AND ce.event_type = 'D'
--AND ce.user_id = 'RMS'
AND TRUNC(ce.create_datetime) = to_date('20210721', 'yyyymmdd') --subtituir esta data pelo dia da criaçao do evento
AND cr.status in ('N', 'E');

create table cost_event_thread_bkp2207 as
SELECT ct.*--ce.COST_EVENT_PROCESS_ID,ce.action,ct.thread_id, cr.status
FROM cost_event ce, cost_event_thread ct, cost_event_result cr
WHERE ce.cost_event_process_id = ct.cost_event_process_id(+)
AND ce.cost_event_process_id = cr.cost_event_process_id(+)
AND ct.thread_id = cr.thread_id
--and ct.cost_event_process_id in (4975432,4975433)
--AND ce.event_type = 'D'
--AND ce.user_id = 'RMS'
AND TRUNC(ce.create_datetime) = to_date('20210721', 'yyyymmdd') --subtituir esta data pelo dia da criaçao do evento
AND cr.status in ('N', 'E');

create table cost_event_result_bkp2207 as
SELECT cr.*--ce.COST_EVENT_PROCESS_ID,ce.action,ct.thread_id, cr.status
FROM cost_event ce, cost_event_thread ct, cost_event_result cr
WHERE ce.cost_event_process_id = ct.cost_event_process_id(+)
AND ce.cost_event_process_id = cr.cost_event_process_id(+)
AND ct.thread_id = cr.thread_id
--and ct.cost_event_process_id in (4975432,4975433)
--AND ce.event_type = 'D'
--AND ce.user_id = 'RMS'
AND TRUNC(ce.create_datetime) = to_date('20210721', 'yyyymmdd') --subtituir esta data pelo dia da criaçao do evento
AND cr.status in ('N', 'E');


--QUERY PARA VALIDAR/ACOMPANHAR O PROCESSAMENTO DAS THREADS DURANTE O FCEXEC
SELECT /*ce.cost_event_process_id,*/ ct.thread_id, cr.status, COUNT(1)
FROM cost_event ce, cost_event_thread ct, cost_event_result cr
WHERE ce.cost_event_process_id = ct.cost_event_process_id(+)
AND ce.cost_event_process_id = cr.cost_event_process_id(+)
AND ct.thread_id = cr.thread_id
--AND ce.event_type = 'D'
AND TRUNC(ce.create_datetime) = get_vdate --subtituir esta data pelo dia da criaçao do evento
AND cr.status in ('N', 'E')
GROUP BY /*ce.cost_event_process_id,*/ct.thread_id, cr.status
ORDER BY 1;

--PROCEDIMENTO CASO DÊ ERRO DE LOCKS
--Restart da cost_event
update cost_event_result
set status = 'N', error_message = NULL
where cost_event_process_id in (SELECT cost_event_process_id
FROM cost_event
where /*event_type = 'D'
and*/ trunc(create_datetime) = get_vdate)
and status = 'E' and error_message like '%RECORD_LOCKED%';
--Restart da thread após ela abortar (entre dar o erro e abortar pode levar vários minutos)
update restart_program_Status set restart_flag = 'Y' where program_name = 'fcexec' and program_Status = 'aborted in process';
--fcexec $UP &

--Logs de erros
select * from logger_logs_60_min where module='fcexec';
select * from logger_logs where module='fcexec' and trunc(TIME_STAMP)=get_vdate;

select * from restart_program_Status where program_name = 'fcexec';
select * from restart_program_Status where program_name = 'fcthreadexec';
select * from restart_bookmark;
