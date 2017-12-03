----------------------------------------------------------------------
-- View BWTA_V_ERR                                                  --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_ERR AS
SELECT 
 'ORA'||to_char(ID,'00000') as ID,
 ATMPT_CNT,
 DELAY_DAY*24*60 AS DELAY_MIN,
 PROLONG_KOEF,
 DIVERS_MOD
FROM BWTA_ERR WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_ERR IS q'~View to Error failover definition~';
COMMENT ON COLUMN BWTA_V_ERR.ATMPT_CNT IS q'~Number of allowed attempts~';
COMMENT ON COLUMN BWTA_V_ERR.DELAY_MIN IS q'~Delay between attempts in minutes~';
COMMENT ON COLUMN BWTA_V_ERR.PROLONG_KOEF IS q'~Koefficient of prolong of repeated attempts~';
COMMENT ON COLUMN BWTA_V_ERR.DIVERS_MOD IS q'~Mode of diversification of delay period~';
COMMENT ON COLUMN BWTA_V_ERR.ID IS q'~Oracle error code number (e.g. -1555 for ORA-01555)~';
----------------------------------------------------------------------
-- View BWTA_V_HEAP                                                 --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_HEAP AS
WITH LRL AS
  (
    SELECT --+materialize
      HEAP_SEQ
    , MAX(SEQ) ROUND_SEQ
    FROM BWTA_LOG_ROUND
    GROUP BY HEAP_SEQ
  )
, STAT AS
  (
    SELECT --+materialize
      T.HEAP_SEQ
    , NVL(LT.STATUS, 'WAIT') AS STATUS
    , LRL.ROUND_SEQ
    , COUNT(1) CNT
    FROM BWTA_TASK T
    LEFT JOIN LRL
    ON LRL.HEAP_SEQ = T.HEAP_SEQ
    LEFT JOIN BWTA_LOG_TASK LT
    ON LT.TASK_SEQ = T.SEQ
      AND LT.ROUND_SEQ = LRL.ROUND_SEQ
    GROUP BY T.HEAP_SEQ
    , NVL(LT.STATUS, 'WAIT')
    , LRL.ROUND_SEQ
  )
, L1 AS
  (
    SELECT H.SEQ AS HEAP_SEQ
    , H.ID       AS HEAP_ID
    , H.NOTE     AS HEAP_NOTE
    , LR.EFFECTIVE_DATE
    , LR.START_DT
    , LR.END_DT
    , S.STATUS
    , S.CNT
    , SUM(S.CNT) over (partition by H.ID) as TASKS_CNT
    FROM BWTA_HEAP H
    LEFT JOIN STAT S
    ON S.HEAP_SEQ = H.SEQ
    LEFT JOIN BWTA_LOG_ROUND LR
    ON LR.SEQ = S.ROUND_SEQ
  )
SELECT HEAP_SEQ
  , HEAP_ID
  , HEAP_NOTE
  , EFFECTIVE_DATE
  , START_DT
  , END_DT
  , TASKS_CNT
  , DONE_CNT
  , Case when START_DT is not null and END_DT is null then WAIT_CNT end as WAIT_CNT
  , ACTIVE_CNT
  , SUSPEND_CNT
  , ERROR_CNT
  , SKIP_CNT
FROM L1 PIVOT (SUM(CNT) FOR STATUS IN(
    'DONE'    AS Done_cnt
  , 'WAIT'    AS Wait_cnt
  , 'ACTIVE'  AS Active_cnt 
  , 'SUSPEND' AS Suspend_cnt
  , 'ERROR'   AS Error_cnt
  , 'SKIP'    AS Skip_cnt
 )) WITH READ ONLY  
;
COMMENT ON TABLE BWTA_V_HEAP IS q'~View to Heaps including statistics of current run~';
COMMENT ON COLUMN BWTA_V_HEAP.HEAP_SEQ IS q'~Sequence key of Heap~';
COMMENT ON COLUMN BWTA_V_HEAP.HEAP_ID IS q'~Identifier of Heap~';
COMMENT ON COLUMN BWTA_V_HEAP.HEAP_NOTE IS q'~Description of Heap~';
COMMENT ON COLUMN BWTA_V_HEAP.EFFECTIVE_DATE IS q'~Effective date of current run (round)~';
COMMENT ON COLUMN BWTA_V_HEAP.START_DT IS q'~Start date of current run~';
COMMENT ON COLUMN BWTA_V_HEAP.END_DT IS q'~End date of current run~';
COMMENT ON COLUMN BWTA_V_HEAP.TASKS_CNT IS q'~Total number of tasks in heap~';
COMMENT ON COLUMN BWTA_V_HEAP.DONE_CNT IS q'~Number of tasks in the state DONE in current run~';
COMMENT ON COLUMN BWTA_V_HEAP.WAIT_CNT IS q'~Number of tasks in the state WAIT in current run includes tasks in the initial state (no state) too~';
COMMENT ON COLUMN BWTA_V_HEAP.ACTIVE_CNT IS q'~Number of tasks in the state ACTIVE in current run~';
COMMENT ON COLUMN BWTA_V_HEAP.SUSPEND_CNT IS q'~Number of tasks in the state SUSPEND in current run~';
COMMENT ON COLUMN BWTA_V_HEAP.ERROR_CNT IS q'~Number of tasks in the state ERROR in current run~';
COMMENT ON COLUMN BWTA_V_HEAP.SKIP_CNT IS q'~Number of tasks in the state SKIP in current run~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_ERR                                              --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_ERR AS
SELECT 
    LE.ROUND_SEQ
  , LE.TASK_SEQ
  , T.ID AS TASK_ID 
  , T.HEAP_SEQ
  , H.ID as HEAP_ID
  , LE.ERR_ID
  , LE.DT
FROM BWTA_LOG_ERR LE
JOIN BWTA_TASK T ON T.SEQ=LE.TASK_SEQ
JOIN BWTA_HEAP H ON H.SEQ=T.HEAP_SEQ
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_ERR IS q'~View of Failovers in realized runs (rounds) allows statistics of failover utilization~';
COMMENT ON COLUMN BWTA_V_LOG_ERR.ROUND_SEQ IS q'~Sequence key of Round when failover happened~';
COMMENT ON COLUMN BWTA_V_LOG_ERR.TASK_SEQ IS q'~Sequence key of failed Task~';
COMMENT ON COLUMN BWTA_V_LOG_ERR.TASK_ID IS q'~Identifier of failed Task~';
COMMENT ON COLUMN BWTA_V_LOG_ERR.HEAP_SEQ IS q'~Sequence key of Heap~';
COMMENT ON COLUMN BWTA_V_LOG_ERR.HEAP_ID IS q'~Identifier of Heap~';
COMMENT ON COLUMN BWTA_V_LOG_ERR.ERR_ID IS q'~Error code~';
COMMENT ON COLUMN BWTA_V_LOG_ERR.DT IS q'~Date and time when it happened~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_HEAP                                             --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_HEAP AS
WITH CONST AS(
  SELECT 
    10 AS ROUNDS_CNT
  , 10 AS MEDIAN_CNT
  FROM DUAL
)  
,LRL AS
  (
    SELECT --+materialize
      HEAP_SEQ
    , MAX(SEQ) ROUND_SEQ
    FROM BWTA_LOG_ROUND
    GROUP BY HEAP_SEQ
  )
,LR AS(
  SELECT 
     LR.HEAP_SEQ
    ,LR.SEQ AS ROUND_SEQ
    ,LR.START_DT
    ,LR.END_DT
    ,ROW_NUMBER()OVER(PARTITION BY LR.HEAP_SEQ ORDER BY LR.SEQ DESC) RN
  FROM BWTA_LOG_ROUND LR   
  WHERE LR.END_DT is not null
)
,TONGUES AS(
  SELECT LT.TASK_SEQ
   ,SUM(LR.END_DT-LT.START_DT) SUM_TONGUE
   ,MAX(LR.END_DT-LT.START_DT) MAX_TONGUE
   ,COUNT(LR.END_DT-LT.START_DT) CNT_TONGUE
  FROM CONST 
  JOIN LR ON LR.RN<=CONST.ROUNDS_CNT
  JOIN BWTA_LOG_TASK LT ON LT.ROUND_SEQ = LR.ROUND_SEQ  
  GROUP BY LT.TASK_SEQ
)
,TASKS AS(
  SELECT
   LT.TASK_SEQ
  ,LRL.HEAP_SEQ
  ,LT.START_DT
  ,LT.START_DT+(TG.SUM_TONGUE-TG.MAX_TONGUE)/NULLIF(TG.CNT_TONGUE-1,0) AS HEAP_END_ESTIMATION
  ,ROW_NUMBER()OVER(PARTITION BY LRL.HEAP_SEQ ORDER BY LT.START_DT DESC) RN
  FROM LRL
  JOIN BWTA_LOG_TASK LT ON LT.ROUND_SEQ=LRL.ROUND_SEQ AND LT.START_DT IS NOT NULL
  JOIN TONGUES TG on TG.TASK_SEQ=LT.TASK_SEQ
)
,HEAPS AS(
  SELECT 
    T.HEAP_SEQ
  , MEDIAN(T.HEAP_END_ESTIMATION) AS HEAP_END_ESTIMATION
  FROM CONST
  JOIN TASKS T ON T.RN <= CONST.MEDIAN_CNT
  GROUP BY T.HEAP_SEQ
)
SELECT 
   H."HEAP_SEQ",H."HEAP_ID",H."HEAP_NOTE",H."EFFECTIVE_DATE",H."START_DT",H."END_DT",H."TASKS_CNT",H."DONE_CNT",H."WAIT_CNT",H."ACTIVE_CNT",H."SUSPEND_CNT",H."ERROR_CNT",H."SKIP_CNT"
  ,HEAPS.HEAP_END_ESTIMATION 
FROM BWTA_V_HEAP H
LEFT JOIN HEAPS on HEAPS.HEAP_SEQ=H.HEAP_SEQ
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_HEAP IS q'~View of Heap last ( or current ) run including end of process estimation~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.HEAP_SEQ IS q'~Sequence key of Heap~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.HEAP_ID IS q'~Identifier of Heap~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.HEAP_NOTE IS q'~Description of Heap~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.EFFECTIVE_DATE IS q'~Effective date of last (current) run~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.START_DT IS q'~Start date and time of the run~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.END_DT IS q'~End date and time of the run~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.TASKS_CNT IS q'~Total number of tasks in the heap~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.DONE_CNT IS q'~Number of task in the heap in the current state DONE~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.WAIT_CNT IS q'~Number of task in the heap in the current state WAIT or in initial state (no state)~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.ACTIVE_CNT IS q'~Number of task in the heap in the current state ACTIVE~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.SUSPEND_CNT IS q'~Number of task in the heap in the current state SUSPEND~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.ERROR_CNT IS q'~Number of task in the heap in the current state ERROR~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.SKIP_CNT IS q'~Number of task in the heap in the current state SKIP~';
COMMENT ON COLUMN BWTA_V_LOG_HEAP.HEAP_END_ESTIMATION IS q'~Estimated end of the heap execution~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_ROUND                                            --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_ROUND AS
SELECT 
  R.SEQ as ROUND_SEQ
 ,R.HEAP_SEQ
 ,H.ID AS HEAP_ID
 ,R.EFFECTIVE_DATE
 ,R.START_DT
 ,R.END_DT
FROM BWTA_LOG_ROUND R
JOIN BWTA_HEAP H ON H.SEQ=R.HEAP_SEQ
ORDER BY R.EFFECTIVE_DATE desc , R.START_DT desc, R.SEQ desc
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_ROUND IS q'~View of Log of Rounds (runs)~';
COMMENT ON COLUMN BWTA_V_LOG_ROUND.ROUND_SEQ IS q'~Sequence key of round~';
COMMENT ON COLUMN BWTA_V_LOG_ROUND.HEAP_SEQ IS q'~Heap the round is associated to - sequence key~';
COMMENT ON COLUMN BWTA_V_LOG_ROUND.HEAP_ID IS q'~Heap the round is associated to - identifier~';
COMMENT ON COLUMN BWTA_V_LOG_ROUND.EFFECTIVE_DATE IS q'~Effective date of round~';
COMMENT ON COLUMN BWTA_V_LOG_ROUND.START_DT IS q'~Start date time of round~';
COMMENT ON COLUMN BWTA_V_LOG_ROUND.END_DT IS q'~End date time of round~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_TASK                                             --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_TASK AS
SELECT
  LT.TASK_SEQ
 ,T.ID as TASK_ID
 ,H.SEQ as HEAP_SEQ
 ,H.id as HEAP_ID
 ,LR.EFFECTIVE_DATE
 ,LT.ROUND_SEQ
 ,LT.STATUS
 ,LT.START_DT
 ,LT.END_DT
 ,(LT.END_DT-LT.START_DT) *60*24 as MINUTES
 ,LT.ERROR_MSG
FROM BWTA_LOG_TASK LT
JOIN BWTA_TASK T on T.SEQ = LT.TASK_SEQ
JOIN BWTA_HEAP H on H.SEQ=T.HEAP_SEQ 
JOIN BWTA_LOG_ROUND LR on LR.SEQ=LT.ROUND_SEQ
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_TASK IS q'~View of task runs~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.TASK_ID IS q'~Identifier of task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.HEAP_SEQ IS q'~Sequence key of Heap the task belongs to~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.HEAP_ID IS q'~Identifier of Heap the task belongs to~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.EFFECTIVE_DATE IS q'~Effective date of round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.ROUND_SEQ IS q'~Sequence key of round of the run~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.STATUS IS q'~Final status of the run~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.START_DT IS q'~Start datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.END_DT IS q'~End datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.MINUTES IS q'~Minutes of run~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.ERROR_MSG IS q'~Error message in the case of error of message related to Suspend or Wait~';
COMMENT ON COLUMN BWTA_V_LOG_TASK.TASK_SEQ IS q'~Sequence key of task~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_TASK_ACTIVE                                      --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_TASK_ACTIVE AS
WITH LRL AS
  (
    SELECT --+materialize
      HEAP_SEQ
    , MAX(SEQ) ROUND_SEQ
    FROM BWTA_LOG_ROUND
    GROUP BY HEAP_SEQ
  )
SELECT 
    T.SEQ AS TASK_SEQ
  , T.ID       AS TASK_ID
  , T.NOTE     AS TASK_NOTE
  , T.PRIORITY AS TASK_PRIORITY
  , T.HEAP_SEQ AS HEAP_SEQ
  , H.ID       AS HEAP_ID
  , LR.SEQ     AS ROUND_SEQ
  , LR.EFFECTIVE_DATE
  , LT.STATUS
  , LT.START_DT
  , LT.START_DT+(T.AVG_DURATION) as APPROX_END_DT
FROM BWTA_TASK T
JOIN BWTA_HEAP H ON H.SEQ = T.HEAP_SEQ
LEFT JOIN LRL  ON LRL.HEAP_SEQ = H.SEQ
LEFT JOIN BWTA_LOG_ROUND LR ON LR.SEQ = LRL.ROUND_SEQ
LEFT JOIN BWTA_LOG_TASK  LT ON LT.TASK_SEQ = T.SEQ AND LT.ROUND_SEQ = LRL.ROUND_SEQ
WHERE LT.STATUS IN ('ACTIVE')
ORDER BY  LT.STATUS, LT.START_DT
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_TASK_ACTIVE IS q'~View of active tasks and their run current state~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.TASK_SEQ IS q'~Sequence key of task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.TASK_ID IS q'~Identifier of task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.TASK_NOTE IS q'~Description of task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.TASK_PRIORITY IS q'~Priority of task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.HEAP_SEQ IS q'~Sequence key of Heap the task belongs to~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.HEAP_ID IS q'~Identifier of Heap the task belongs to~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.ROUND_SEQ IS q'~Sequence of active round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.EFFECTIVE_DATE IS q'~Effective date of active round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.STATUS IS q'~Current status of task run~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.START_DT IS q'~Start date and time~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_ACTIVE.APPROX_END_DT IS q'~End date and time~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_TASK_H                                           --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_TASK_H AS
SELECT
  LT.TASK_SEQ
 ,T.ID as TASK_ID
 ,H.SEQ as HEAP_SEQ
 ,H.id as HEAP_ID
 ,LR.EFFECTIVE_DATE
 ,LT.ROUND_SEQ
 ,LT.STATUS
 ,LT.START_DT
 ,LT.END_DT
 ,(LT.END_DT - LT.START_DT) * 60 * 24 AS MINUTES
 ,LT.ERROR_MSG
 ,LT.TS 
FROM BWTA_LOG_TASK_H LT
join BWTA_TASK T on T.SEQ = LT.TASK_SEQ
join BWTA_HEAP H on H.SEQ=T.HEAP_SEQ 
join BWTA_LOG_ROUND LR on LR.SEQ=LT.ROUND_SEQ
UNION ALL
SELECT
  LT.TASK_SEQ
 ,T.ID as TASK_ID
 ,H.SEQ as HEAP_SEQ
 ,H.id as HEAP_ID
 ,LR.EFFECTIVE_DATE
 ,LT.ROUND_SEQ
 ,LT.STATUS
 ,LT.START_DT
 ,LT.END_DT
 ,(LT.END_DT - LT.START_DT) * 60 * 24 AS MINUTES
 ,LT.ERROR_MSG
 ,(LT.END_DT-SYSTIMESTAMP)+SYSTIMESTAMP+(1/24/3600)  as TS 
FROM BWTA_LOG_TASK LT
join BWTA_TASK T on T.SEQ = LT.TASK_SEQ
join BWTA_HEAP H on H.SEQ=T.HEAP_SEQ 
join BWTA_LOG_ROUND LR on LR.SEQ=LT.ROUND_SEQ
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_TASK_H IS q'~View of log of task runs including details of the status changes of the task round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.TASK_ID IS q'~Identifier of Task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.HEAP_SEQ IS q'~Sequence key of Heap~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.HEAP_ID IS q'~Identifier of Heap~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.EFFECTIVE_DATE IS q'~Effective date of round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.ROUND_SEQ IS q'~Sequence of round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.STATUS IS q'~Status at the moment~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.START_DT IS q'~Start datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.END_DT IS q'~End datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.MINUTES IS q'~Minutes between end and start~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.ERROR_MSG IS q'~Error or auxiliary message~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.TS IS q'~Timestamp of the state snap~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_H.TASK_SEQ IS q'~Sequence key of Task~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_TASK_TBD                                         --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_TASK_TBD AS
WITH LRL AS
  (
    SELECT --+materialize
      HEAP_SEQ
    , MAX(SEQ) ROUND_SEQ
    FROM BWTA_LOG_ROUND
    GROUP BY HEAP_SEQ
  )
SELECT T.SEQ AS TASK_SEQ
  , T.ID       AS TASK_ID
  , T.NOTE     AS TASK_NOTE
  , T.PRIORITY AS TASK_PRIORITY
  , T.HEAP_SEQ AS HEAP_SEQ
  , H.ID       AS HEAP_ID
  , LR.SEQ     AS ROUND_SEQ
  , LR.EFFECTIVE_DATE
  , Case when LT.STATUS = 'ERROR' and substr(LT.ERROR_MSG,1,9) = 'ORA-20999' then 'MANUAL' else LT.STATUS end as STATUS
  , LT.START_DT
  , LT.END_DT
  , Case when LT.STATUS = 'ERROR' and substr(LT.ERROR_MSG,1,9) = 'ORA-20999' then regexp_replace(LT.ERROR_MSG,'^([^~]*[~])([^~]*)([~].*)$','\2',1,1,'n') else LT.ERROR_MSG end as ERROR_MSG
FROM BWTA_TASK T
JOIN BWTA_HEAP H ON H.SEQ = T.HEAP_SEQ
LEFT JOIN LRL ON LRL.HEAP_SEQ = H.SEQ
LEFT JOIN BWTA_LOG_ROUND LR ON LR.SEQ = LRL.ROUND_SEQ
LEFT JOIN BWTA_LOG_TASK LT ON LT.TASK_SEQ = T.SEQ AND LT.ROUND_SEQ = LRL.ROUND_SEQ
WHERE 
 (LT.STATUS IN ('ERROR','SUSPEND')
  OR (LT.STATUS='WAIT' and LT.ERROR_MSG is not null))
ORDER BY  LT.STATUS, LT.START_DT
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_TASK_TBD IS q'~View of tasks in the state requiring attention of operator, that covers states of Errors, suspended or waiting tasks and tasks requiring manual action~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.TASK_ID IS q'~Identifier of Task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.TASK_NOTE IS q'~Description of Task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.TASK_PRIORITY IS q'~Priority of Task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.HEAP_SEQ IS q'~Sequence key of the task Heap~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.HEAP_ID IS q'~Identifier of the task Heap~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.ROUND_SEQ IS q'~Sequence key of Round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.EFFECTIVE_DATE IS q'~Effective date of current round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.STATUS IS q'~Current status of the Task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.START_DT IS q'~Start datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.END_DT IS q'~End datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.ERROR_MSG IS q'~Error or auxiliary message~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_TBD.TASK_SEQ IS q'~Sequence key of the task~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_TASK_WIDE                                        --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_TASK_WIDE AS
WITH CONST AS
  (
    SELECT 10 AS ROUNDS_CNT
    , 5       AS MEDIAN_CNT
    FROM DUAL
  )
, LRL AS
  (
    SELECT --+materialize
      HEAP_SEQ
    , MAX(SEQ) ROUND_SEQ
    , MAX(BWTA_LOG_ROUND.START_DT) START_DT
    FROM BWTA_LOG_ROUND
    GROUP BY HEAP_SEQ
  )
, DEP AS
  (
    SELECT TR.SEQ1 SEQ
    , LISTAGG(
      CASE
        WHEN NVL(TR.SKIP_FLAG, 0) = 0
        THEN TDEP.ID
        ELSE '('||TDEP.ID||')'
      END, ', ') WITHIN GROUP(
    ORDER BY TDEP.SEQ) AS DEP_TASKS
    FROM BWTA_TASK_REL TR
    LEFT JOIN BWTA_TASK TDEP
    ON TDEP.SEQ = TR.SEQ2
    GROUP BY TR.SEQ1
  )
, DEPNOW AS
  (
    SELECT TR.SEQ1 AS SEQ
    , LISTAGG(TDEP.ID, ', ') WITHIN GROUP(
    ORDER BY TDEP.SEQ) AS DEP_TASKS
    FROM BWTA_TASK_REL TR
    LEFT JOIN BWTA_TASK TDEP
    ON TDEP.SEQ = TR.SEQ2
    LEFT JOIN LRL
    ON LRL.HEAP_SEQ = TDEP.HEAP_SEQ
    LEFT JOIN BWTA_LOG_TASK LTDEP
    ON LTDEP.TASK_SEQ = TDEP.SEQ
      AND LTDEP.ROUND_SEQ = LRL.ROUND_SEQ
    WHERE NVL(LTDEP.STATUS, '#') NOT IN('DONE', 'SKIP')
      AND NVL(TR.SKIP_FLAG, 0) = 0
    GROUP BY TR.SEQ1
  )
, RES AS
  (
    SELECT TRS.TASK_SEQ AS TASK_SEQ
    , LISTAGG( R.ID||'('||TRS.AMOUNT||'/'||R.AMOUNT||')', ', ') WITHIN GROUP(
    ORDER BY R.ID) AS RESOURCES
    FROM BWTA_TASK_RES TRS
    LEFT JOIN BWTA_RES R
    ON R.SEQ = TRS.RES_SEQ
    GROUP BY TRS.TASK_SEQ
  )
, LR AS
  (
    SELECT LR.HEAP_SEQ
    , LR.SEQ AS ROUND_SEQ
    , LR.START_DT
    , LR.END_DT
    , ROW_NUMBER() OVER(PARTITION BY LR.HEAP_SEQ ORDER BY LR.SEQ DESC) RN
    FROM BWTA_LOG_ROUND LR
    WHERE LR.END_DT IS NOT NULL
  )
, TAILS AS
  (
    SELECT LT.TASK_SEQ
    , SUM(LT.START_DT - LR.START_DT) SUM_TAIL
    , MAX(LT.START_DT - LR.START_DT) MAX_TAIL
    , COUNT(LT.START_DT - LR.START_DT) CNT_TAIL
    FROM CONST
    JOIN LR
    ON LR.RN <= CONST.ROUNDS_CNT
    JOIN BWTA_LOG_TASK LT
    ON LT.ROUND_SEQ = LR.ROUND_SEQ
    GROUP BY LT.TASK_SEQ
  )
, TAILS_M AS
  (
    SELECT TL.TASK_SEQ
    , LT.TASK_SEQ                                                           AS TASK_SEQ_YET
    , ROW_NUMBER() OVER(PARTITION BY TL.TASK_SEQ ORDER BY LT.START_DT DESC) AS
      RN
    , LRL.START_DT + NVL((TL.SUM_TAIL - TL.MAX_TAIL) / NULLIF(TL.CNT_TAIL - 1,
      0), TL.SUM_TAIL / NULLIF(TL.CNT_TAIL, 0)) AS ESTIM_START_OLD
    , LT.START_DT + NVL((TL.SUM_TAIL - TL.MAX_TAIL) / NULLIF(TL.CNT_TAIL - 1, 0
      ), TL.SUM_TAIL / NULLIF(TL.CNT_TAIL, 0)) - NVL((TY.SUM_TAIL - TY.MAX_TAIL
      ) / NULLIF(TY.CNT_TAIL - 1, 0), TY.SUM_TAIL / NULLIF(TY.CNT_TAIL, 0)) AS
      ESTIM_START_YET
    FROM LRL
    JOIN BWTA_LOG_TASK LT
    ON LT.ROUND_SEQ = LRL.ROUND_SEQ
    JOIN TAILS TL
    ON TL.TASK_SEQ != LT.TASK_SEQ
    JOIN TAILS TY
    ON TY.TASK_SEQ = LT.TASK_SEQ
  )
, TAILS_MG AS
  (
    SELECT TM.TASK_SEQ
    , MEDIAN(ESTIM_START_YET) AS START_DT_ESTIMATION
    FROM TAILS_M TM
    JOIN CONST
    ON CONST.MEDIAN_CNT >= TM.RN
    GROUP BY TM.TASK_SEQ
  )
SELECT T.SEQ AS TASK_SEQ
  , T.ID       AS TASK_ID
  , T.NOTE     AS TASK_NOTE
  , T.PRIORITY AS TASK_PRIORITY
  , T.HEAP_SEQ AS HEAP_SEQ
  , H.ID       AS HEAP_ID
    --,H.NOTE       AS HEAP_NOTE
    -- runtime-------------------------------------------------------------------
  , LR.SEQ AS ROUND_SEQ
  , LR.EFFECTIVE_DATE
  , CASE
      WHEN LR.END_DT IS NULL
      THEN 'STARTED'
      ELSE 'FINISHED'
    END AS ROUND_STATUS
  , LT.STATUS
  , LT.START_DT
  , LT.END_DT
  ,(
    CASE
      WHEN LT.STATUS = 'ACTIVE'
      THEN SYSDATE
      ELSE LT.END_DT
    END - LT.START_DT) * 24 * 60 AS MINUTES
  , T.AVG_DURATION * 24 * 60     AS AVG_MINUTES
  , LT.ERROR_MSG
    -- dependencies--------------------------------------------------------------
  , DEP.DEP_TASKS    AS PREDECESSOR_TASKS
  , DEPNOW.DEP_TASKS AS BLOCKING_TASKS
  , RES.RESOURCES    AS RESOURCES
    -- conditions--------------------------------------------------------------
  , T.EXEC_COND AS TASK_EXEC_COND
  , T.EXEC_FLAG AS TASK_EXEC_FLAG
  , T.SKIP_COND AS TASK_SKIP_COND
  , T.SKIP_FLAG AS TASK_SKIP_FLAG
  , T.EXEC_CODE AS TASK_EXEC_CODE
  , TL.START_DT_ESTIMATION
FROM BWTA_TASK T
JOIN BWTA_HEAP H ON H.SEQ = T.HEAP_SEQ
  -- runtime-------------------------------------------------------------------
LEFT JOIN LRL ON LRL.HEAP_SEQ = H.SEQ
LEFT JOIN BWTA_LOG_ROUND LR ON LR.SEQ = LRL.ROUND_SEQ
LEFT JOIN BWTA_LOG_TASK LT ON LT.TASK_SEQ = T.SEQ AND LT.ROUND_SEQ = LRL.ROUND_SEQ
  -- dependencies--------------------------------------------------------------
LEFT JOIN DEP ON DEP.SEQ = T.SEQ
LEFT JOIN DEPNOW ON DEPNOW.SEQ = T.SEQ
LEFT JOIN RES ON RES.TASK_SEQ = T.SEQ
  -- tails --------------------------------------------------------------------
LEFT JOIN TAILS_MG TL ON TL.TASK_SEQ = T.SEQ
  -----------------------------------------------------------------------------
ORDER BY H.SEQ, T.ID
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_TASK_WIDE IS q'~View of all the possible characteristics of Task run showing all the states of current or last task execution~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_EXEC_FLAG IS q'~Execution flag of the task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_SKIP_COND IS q'~Skip condition of the task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_SKIP_FLAG IS q'~Skip flag of the task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_EXEC_CODE IS q'~Execution code~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.START_DT_ESTIMATION IS q'~Estimation of start datetime of not ran yet tasks~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_SEQ IS q'~Sequence key of the task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_ID IS q'~Identifier of the task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_NOTE IS q'~Description of the task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_PRIORITY IS q'~Prioerity of the task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.HEAP_SEQ IS q'~Sequence key of the task Heap~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.HEAP_ID IS q'~Identifier of the task Heap~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.ROUND_SEQ IS q'~Sequence key of last or current round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.EFFECTIVE_DATE IS q'~Effective date of last or current round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.ROUND_STATUS IS q'~Final or current status of round~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.STATUS IS q'~Final or current status of task~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.START_DT IS q'~Start datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.END_DT IS q'~End datetime~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.MINUTES IS q'~Minutes between the end and start~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.AVG_MINUTES IS q'~Average minutes of task executions in the past~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.ERROR_MSG IS q'~Error or auxiliary message~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.PREDECESSOR_TASKS IS q'~List of predecessor tasks~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.BLOCKING_TASKS IS q'~List of still blocking predecessor tasks~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.RESOURCES IS q'~List of resources~';
COMMENT ON COLUMN BWTA_V_LOG_TASK_WIDE.TASK_EXEC_COND IS q'~Execution condition of the task~';
----------------------------------------------------------------------
-- View BWTA_V_LOG_THREAD                                           --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_LOG_THREAD AS
SELECT
    H.ID as HEAP_ID
  , H.SEQ as HEAP_SEQ
  , LTH.SEQ as THREAD_SEQ
  , LTH.ROUND_SEQ
  , LTH.STATUS
  , LTH.TASK_SEQ
  , T.ID AS TASK_ID
  , LTH.START_DT
  , LTH.COMMAND
  , LTH.ERROR_MSG
FROM BWTA_LOG_THREAD LTH 
JOIN BWTA_LOG_ROUND LR ON LTH.ROUND_SEQ=LR.SEQ
JOIN BWTA_HEAP H ON H.SEQ=LR.HEAP_SEQ
LEFT JOIN BWTA_TASK T on T.seq=LTH.TASK_SEQ
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_LOG_THREAD IS q'~View of current runtime threads and their states~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.HEAP_ID IS q'~Identifire to the Heap associated~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.HEAP_SEQ IS q'~Sequence key of the Heap associated~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.THREAD_SEQ IS q'~Sequence key of the Thread~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.ROUND_SEQ IS q'~Sequence key of the Round associated~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.STATUS IS q'~Status of the thread~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.TASK_SEQ IS q'~Sequence key of the task if there is any just processed~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.TASK_ID IS q'~Identifier of the task if there is any just processed~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.START_DT IS q'~Start datetime of the thread~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.COMMAND IS q'~Command sent to the thread influencing it's next activity (e.g. STOP)~';
COMMENT ON COLUMN BWTA_V_LOG_THREAD.ERROR_MSG IS q'~Error message related to teh thread job execution~';
----------------------------------------------------------------------
-- View BWTA_V_RES                                                  --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_RES AS
WITH TSTAT AS (
  SELECT RES_SEQ
   , count(TASK_SEQ) as CNT
  FROM BWTA_TASK_RES
  GROUP BY RES_SEQ
)
SELECT SEQ AS RES_SEQ
  , R.ID AS RES_ID
  , R.NOTE AS RES_NOTE
  , R.AMOUNT AS RES_AMOUNT
  , R.PENDING AS RES_PENDING_FLAG
  , NVL(TSTAT.CNT,0) as TASK_CNT 
FROM BWTA_RES R
LEFT JOIN TSTAT ON TSTAT.RES_SEQ=R.SEQ
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_RES IS q'~View to Resource definition~';
COMMENT ON COLUMN BWTA_V_RES.RES_SEQ IS q'~Sequence key of the Resource~';
COMMENT ON COLUMN BWTA_V_RES.RES_ID IS q'~Identifier of the Resource~';
COMMENT ON COLUMN BWTA_V_RES.RES_NOTE IS q'~Description~';
COMMENT ON COLUMN BWTA_V_RES.RES_AMOUNT IS q'~Available amount of the Resource~';
COMMENT ON COLUMN BWTA_V_RES.RES_PENDING_FLAG IS q'~Flag of Pending (persistent) resource~';
COMMENT ON COLUMN BWTA_V_RES.TASK_CNT IS q'~Number of Tasks consuming the resource by definition~';
----------------------------------------------------------------------
-- View BWTA_V_RES_USAGE                                            --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_RES_USAGE AS
WITH LRL AS
  (
    SELECT --+materialize
      HEAP_SEQ
    , MAX(SEQ) ROUND_SEQ
    FROM BWTA_LOG_ROUND
    GROUP BY HEAP_SEQ
  )
SELECT R.SEQ          AS RES_SEQ
  , R.ID              AS RES_ID
  , R.NOTE            AS RES_NOTE
  , R.AMOUNT          AS RES_AMOUNT
  , R.PENDING         AS RES_PENDING_FLAG
  , SUM(TR.AMOUNT)OVER(PARTITION BY R.SEQ) AS USED_AMOUNT
  , SUM(TR.AMOUNT)OVER(PARTITION BY R.SEQ)*100/NULLIF(R.AMOUNT,0) AS USED_PCT
  , H.ID              AS HEAP_ID
  , T.ID              AS TASK_ID
  , TR.AMOUNT         AS TASK_USED_AMOUNT
FROM BWTA_RES R
JOIN BWTA_TASK_RES TR ON TR.RES_SEQ = R.SEQ
JOIN BWTA_TASK T ON T.SEQ = TR.TASK_SEQ
JOIN BWTA_HEAP H ON H.SEQ = T.HEAP_SEQ
JOIN LRL ON LRL.HEAP_SEQ = T.HEAP_SEQ
JOIN BWTA_LOG_TASK LT ON  LT.TASK_SEQ = T.SEQ AND LT.ROUND_SEQ=LRL.ROUND_SEQ
WHERE (LT.STATUS='ACTIVE' or (R.PENDING=1 and LT.STATUS!='WAIT'))
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_RES_USAGE IS q'~View to resource definition enhanced by it's usage information useful for the required amount control~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.RES_SEQ IS q'~Sequence key of Resource~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.RES_ID IS q'~Identifier of Resource~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.RES_NOTE IS q'~Description~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.RES_AMOUNT IS q'~Available amount of the Resource~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.RES_PENDING_FLAG IS q'~Flag of Pending (persistent) resource~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.USED_AMOUNT IS q'~Currently used amount of the Resource~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.USED_PCT IS q'~Percentage of current Resource usage~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.HEAP_ID IS q'~Identifier of consuming Heap~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.TASK_ID IS q'~Identifier of consuming task~';
COMMENT ON COLUMN BWTA_V_RES_USAGE.TASK_USED_AMOUNT IS q'~Amount of the resource consumed just by the certain task~';
----------------------------------------------------------------------
-- View BWTA_V_TASK                                                 --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_TASK AS
WITH DEP AS ( 
    SELECT TR.SEQ1 SEQ 
      ,LISTAGG( 
         Case when NVL(TR.SKIP_FLAG,0)=0 then TDEP.ID else '('||TDEP.ID||')' end 
        ,', ') WITHIN GROUP (ORDER BY TDEP.SEQ) as DEP_TASKS 
    FROM BWTA_TASK_REL TR   
    LEFT JOIN BWTA_TASK TDEP ON TDEP.SEQ=TR.SEQ2 
    GROUP BY TR.SEQ1 
  ) 
  ,RES AS ( 
    SELECT TRS.TASK_SEQ AS TASK_SEQ 
      ,LISTAGG( 
         R.ID||'('||TRS.AMOUNT||'/'||R.AMOUNT||')' 
        ,', ') WITHIN GROUP (ORDER BY R.ID) AS RESOURCES 
    FROM BWTA_TASK_RES TRS   
    LEFT JOIN BWTA_RES R ON R.SEQ=TRS.RES_SEQ 
    GROUP BY TRS.TASK_SEQ 
  ) 
  SELECT  
    T.SEQ        AS TASK_SEQ 
   ,T.ID         AS TASK_ID 
   ,T.NOTE       AS TASK_NOTE 
   ,T.PRIORITY   AS TASK_PRIORITY 
   ,T.HEAP_SEQ   AS HEAP_SEQ 
   ,H.ID         AS HEAP_ID 
   ,T.AVG_DURATION*24*60 AS AVG_MINUTES 
  -- dependencies-------------------------------------------------------------- 
   ,DEP.DEP_TASKS    AS PREDECESSOR_TASKS 
   ,RES.RESOURCES    AS RESOURCES 
  -- conditions-------------------------------------------------------------- 
   ,T.EXEC_COND AS TASK_EXEC_COND 
   ,T.EXEC_FLAG AS TASK_EXEC_FLAG 
   ,T.SKIP_COND AS TASK_SKIP_COND 
   ,T.SKIP_FLAG AS TASK_SKIP_FLAG 
   ,T.EXEC_CODE AS TASK_EXEC_CODE 
  FROM BWTA_TASK T 
  JOIN BWTA_HEAP H ON H.SEQ=T.HEAP_SEQ 
  -- dependencies-------------------------------------------------------------- 
  LEFT JOIN DEP    ON DEP.SEQ=T.SEQ 
  LEFT JOIN RES    ON RES.TASK_SEQ=T.SEQ 
  ----------------------------------------------------------------------------- 
  ORDER BY H.SEQ, T.ID
 WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_TASK IS q'~View to Task definition~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_SEQ IS q'~Sequence key of Task~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_ID IS q'~Identifier of Task~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_NOTE IS q'~Description of Task~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_PRIORITY IS q'~Priority of Task~';
COMMENT ON COLUMN BWTA_V_TASK.HEAP_SEQ IS q'~Sequence key of the Heap~';
COMMENT ON COLUMN BWTA_V_TASK.HEAP_ID IS q'~Identifier of the Heap~';
COMMENT ON COLUMN BWTA_V_TASK.AVG_MINUTES IS q'~Average duration of execution in minutes~';
COMMENT ON COLUMN BWTA_V_TASK.PREDECESSOR_TASKS IS q'~List of predecessor tasks~';
COMMENT ON COLUMN BWTA_V_TASK.RESOURCES IS q'~List of Resources~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_EXEC_COND IS q'~Execution condition of the Task~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_EXEC_FLAG IS q'~Execution flag of the Task~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_SKIP_COND IS q'~Skip condition of the Task~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_SKIP_FLAG IS q'~Skip flag of the Task~';
COMMENT ON COLUMN BWTA_V_TASK.TASK_EXEC_CODE IS q'~Execution code specification of the task~';
----------------------------------------------------------------------
-- View BWTA_V_TASK_REL                                             --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_TASK_REL AS
SELECT 
  TR.SEQ1 AS TASK_SEQ_1
, T1.ID   AS TASK_ID_1  
, T1.HEAP_SEQ   AS HEAP_SEQ_1  
, TR.SEQ2 as TASK_SEQ_2
, T2.ID   AS TASK_ID_2  
, T2.HEAP_SEQ   AS HEAP_SEQ_2  
, TR.SKIP_FLAG
FROM BWTA_TASK_REL TR
JOIN BWTA_TASK T1 ON T1.SEQ=tr.SEQ1
JOIN BWTA_TASK T2 ON T2.SEQ=TR.SEQ2
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_TASK_REL IS q'~Vew to Relationship of two tasks showing predecessors~';
COMMENT ON COLUMN BWTA_V_TASK_REL.TASK_ID_1 IS q'~Successor task id~';
COMMENT ON COLUMN BWTA_V_TASK_REL.HEAP_SEQ_1 IS q'~Successor task sequence~';
COMMENT ON COLUMN BWTA_V_TASK_REL.TASK_SEQ_2 IS q'~Predecessor task sequence~';
COMMENT ON COLUMN BWTA_V_TASK_REL.TASK_ID_2 IS q'~Predecessor task identifier~';
COMMENT ON COLUMN BWTA_V_TASK_REL.HEAP_SEQ_2 IS q'~Heap of the predecessor task~';
COMMENT ON COLUMN BWTA_V_TASK_REL.TASK_SEQ_1 IS q'~Heap of the successor task~';
COMMENT ON COLUMN BWTA_V_TASK_REL.SKIP_FLAG IS q'~Skip flag of the dependency to suppress it~';
----------------------------------------------------------------------
-- View BWTA_V_TASK_REL_CYCLIC                                      --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_TASK_REL_CYCLIC AS
WITH L0 AS(
   SELECT T.ID, TR.* 
   FROM BWTA_TASK T
   JOIN BWTA_TASK_REL TR on TR.SEQ1=T.SEQ
   WHERE TR.SKIP_FLAG = 0
  )
,L1 AS(
    SELECT CONNECT_BY_ISCYCLE CYC
    , ID||SYS_CONNECT_BY_PATH(ID, '->') PTH
    , LEVEL LVL
    , SEQ1
    , SEQ2
    FROM L0
      CONNECT BY NOCYCLE SEQ1 = PRIOR SEQ2
  )
SELECT PTH
FROM L1
WHERE CYC = 1
ORDER BY LENGTH(PTH)
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_TASK_REL_CYCLIC IS q'~View to cyclic fragments of graph used to alert round dependencies~';
COMMENT ON COLUMN BWTA_V_TASK_REL_CYCLIC.PTH IS q'~Path of the cycle~';
----------------------------------------------------------------------
-- View BWTA_V_TASK_RES                                             --
----------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW BWTA_V_TASK_RES AS
SELECT 
  TRS.TASK_SEQ
, T.ID AS TASK_ID
, T.HEAP_SEQ  
, TRS.RES_SEQ
, R.ID AS RES_ID  
, TRS.AMOUNT
,R.AMOUNT as OF_AMOUNT
FROM BWTA_TASK_RES TRS
JOIN BWTA_TASK T ON T.SEQ=TRS.TASK_SEQ
JOIN BWTA_RES R ON R.SEQ=TRS.RES_SEQ
WITH READ ONLY
;
COMMENT ON TABLE BWTA_V_TASK_RES IS q'~View to Resource consumption by tasks~';
COMMENT ON COLUMN BWTA_V_TASK_RES.TASK_ID IS q'~Identifier of Task~';
COMMENT ON COLUMN BWTA_V_TASK_RES.HEAP_SEQ IS q'~Sequence key of the Heap~';
COMMENT ON COLUMN BWTA_V_TASK_RES.RES_SEQ IS q'~Sequence key of consumed Resource~';
COMMENT ON COLUMN BWTA_V_TASK_RES.RES_ID IS q'~Identifier of consumed Resource~';
COMMENT ON COLUMN BWTA_V_TASK_RES.AMOUNT IS q'~Consumed amount of the resource~';
COMMENT ON COLUMN BWTA_V_TASK_RES.OF_AMOUNT IS q'~Available amount of the resource~';
COMMENT ON COLUMN BWTA_V_TASK_RES.TASK_SEQ IS q'~Sequence key of Task~';
