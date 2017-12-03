----------------------------------------------------------------------
-- PACKAGE BWTA_METADATA                                            --
----------------------------------------------------------------------
Create or replace PACKAGE "BWTA_METADATA" IS 
  ----------------------------------------------------------------------------- 
  --Purpose: Simple processes and task management / METADATA API             -- 
  --Author:  Bob Jankovsky, copyleft 2008, 2013                              -- 
  --History: 1.3 /22-JUN-2013 -- extracted from central utility and enhanced -- 
  --         1.4 /24-JUL-2013 -- new Rename methods                          -- 
  ----------------------------------------------------------------------------- 
 ------------------------------------------------------------------------------ 
  -- TASK                                                                    --  
 ------------------------------------------------------------------------------ 
PROCEDURE setTask(-- Inserts or updates Task in the Simpletask metadata 
      P_HEAP          integer,  -- Sequence of heap
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_EXEC_COND     varchar2, -- Execute condition 
      P_SKIP_COND     varchar2, -- Skip condition 
      P_EXEC_FLAG     varchar2, -- Flag to execute process 
      P_SKIP_FLAG     varchar2, -- Flag to skip process 
      P_EXEC_CODE     varchar2, -- Execution code 
      P_PRIORITY      number,   -- Priority of task 
      P_TAG           varchar2  -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
PROCEDURE setTask(-- Inserts or updates Task in the Simpletask metadata 
                  -- shortened list of attributes
      P_HEAP          integer,  -- Sequence of heap 
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_EXEC_CODE     varchar2, -- Execution code 
      P_PRIORITY      number,   -- Priority of task 
      P_TAG           varchar2  -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
PROCEDURE setTask(-- Inserts or updates Task in the Simpletask metadata 
                  -- even more shortened list of attributes
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_EXEC_CODE     varchar2, -- Execution code 
      P_PRIORITY      number,   -- Priority of task 
      P_TAG           varchar2  -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
  PROCEDURE delTask(-- Removes Task from Simpletask metadata 
      P_ID            varchar2, -- Identifier of task 
      P_HEAP          integer,  -- Sequence of heap 
      P_TAG           varchar2  -- Change tag  
  ); 
 ------------------------------------------------------------------------------ 
  PROCEDURE renameTask(-- Renames Task in Simpletask metadata transparently  
      P_OLD_ID        varchar2, -- Identifier of task 
      P_NEW_ID        varchar2, -- Identifier of task, new 
      P_HEAP          integer,  -- Sequence of heap 
      P_TAG           varchar2  -- Change tag  
  ); 
 ------------------------------------------------------------------------------ 
  -- HEAP                                                                    --  
 ------------------------------------------------------------------------------ 
PROCEDURE setHeap(-- Inserts or updates Heap in the Simpletask metadata   
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_TAG           varchar2  -- Change tag  
  ); 
 ------------------------------------------------------------------------------ 
PROCEDURE delHeap(-- Removes Heap from Simpletask metadata  
      P_ID            varchar2, -- ID of heap 
      P_TAG           varchar2  -- Change tag  
  ); 
 ------------------------------------------------------------------------------ 
PROCEDURE renameHeap(-- Renames Heap in Simpletask metadata transparently   
      P_OLD_ID        VARCHAR2, -- Identifier of heap, old 
      P_NEW_ID        VARCHAR2, -- Identifier of heap, new 
      P_TAG           VARCHAR2  -- Change tag  
  ); 
 ------------------------------------------------------------------------------ 
  -- TASK_REL                                                                --  
 ------------------------------------------------------------------------------ 
PROCEDURE setTaskRel(-- Inserts or updates Task Dependency in the Simpletask metadata 
      P_ID1           varchar2, -- ID of dependent task 
      P_ID2           varchar2, -- ID of predecessor 
      P_HEAP          integer,  -- Sequence of heap     
      P_SKIP_FLAG     integer,  -- 1 if the dependency is to be ignored, otherwise 0 
      P_TAG           varchar2  -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
PROCEDURE delTaskRel(-- Removes Task Dependency from Simpletask metadata    
      P_SEQ1          integer, -- ID of dependent task 
      P_SEQ2          integer, -- ID of predecessor 
      P_TAG           varchar2 -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
  -- TASK_RES                                                                --  
 ------------------------------------------------------------------------------ 
PROCEDURE setTaskRes(-- Inserts or updates Task Resource consumption in the Simpletask metadata 
      P_TASK_SEQ      integer, -- ID of task 
      P_RES_SEQ       integer, -- ID of resource 
      P_AMOUNT        number,  -- Consumption of the resource for the process 
      P_TAG           varchar2 -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
PROCEDURE setTaskRes(-- Inserts or updates Task Resource consumption in the Simpletask metadata 
      P_TASK_ID       varchar2, -- ID of task 
      P_HEAP          integer,  -- sequence of heap 
      P_RES_ID        varchar2, -- ID of resource 
      P_AMOUNT        number,   -- Consumption of the resource for the process 
      P_TAG           varchar2  -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
PROCEDURE delTaskRes(-- Removes Task Resource consumption from Simpletask metadata  
      P_TASK_SEQ      integer, -- SEQ of task 
      P_RES_SEQ       integer, -- SEQ of resource 
      P_TAG           varchar2 -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
  -- RES                                                                     --  
 ------------------------------------------------------------------------------ 
PROCEDURE setRes( -- Inserts or updates Resource in the Simpletask metadata  
    P_ID              varchar2, -- Id of resource 
    P_NOTE            varchar2, -- Note if omit then ID will be used 
    P_AMOUNT          number,   -- Available amount (default 100) 
    P_PENDING         integer,  -- Cumulative resource flag  
              -- 0..resource released after end of process 
              -- 1..resource should be released by negative consumption 
    P_TAG             varchar2 -- Change tag  
  ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE delRes(-- Removes Resource from Simpletask metadata   
      P_ID            varchar2, -- ID of resource 
      P_TAG           varchar2  -- Change tag  
  ) ; 
 ------------------------------------------------------------------------------ 
PROCEDURE renameRes(-- Renames Resource in Simpletask metadata transparently    
      P_OLD_ID        varchar2, -- Identifier of res 
      P_NEW_ID        varchar2, -- Identifier of res, new 
      P_TAG           varchar2  -- Change tag  
  ); 
 ------------------------------------------------------------------------------ 
  -- ERR                                                                     --  
 ------------------------------------------------------------------------------ 
PROCEDURE setErr(  --Inserts or updates Error failover definition in the Simpletask metadata     
    P_ID           number,   -- Error code  
    P_ATMPT_CNT    integer,  -- Number of attempt of failover 
    P_DELAY_MIN    number,   -- Delay in minutes 
    P_PROLONG_KOEF number,   -- Koefficient of prolong 
    P_DIVERS_MOD   number,   -- Modifier for diversification of delay 
    P_TAG          varchar2  -- Change tag  
  ) ; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setErr(  --creates or updates Error failover definition 
    P_ID           number,   -- Error code  
    P_ATMPT_CNT    integer,  -- Number of attempt of failover 
    P_DELAY_MIN    number,   -- Delay in minures 
    P_TAG          varchar2  -- Change tag  
  ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE delErr(-- removes res  
      P_ID         varchar2, -- ID of resource 
      P_TAG        varchar2  -- Change tag  
  ) ; 
  ------------------------------------------------------------------------------ 
END BWTA_METADATA;
/
----------------------------------------------------------------------
-- PACKAGE BODY BWTA_METADATA                                       --
----------------------------------------------------------------------
Create or replace PACKAGE BODY "BWTA_METADATA" IS 
  ------------------------------------------------------------------------------ 
  -- TASK                                                                    --  
  ------------------------------------------------------------------------------ 
  FUNCTION  getTaskXR (P_ID VARCHAR2, P_HEAP INTEGER) RETURN XMLTYPE IS 
    v_XR XMLTYPE; 
  BEGIN 
    SELECT XMLELEMENT( "BWTA_TASK", XMLFOREST( 
        SEQ 
      , HEAP_SEQ 
      , ID 
      , NOTE 
      , EXEC_COND 
      , SKIP_COND 
      , EXEC_FLAG 
      , SKIP_FLAG 
      , EXEC_CODE 
      , PRIORITY 
    )) "VAL" 
    INTO v_XR 
    FROM BWTA_TASK 
    WHERE ID=P_ID and HEAP_SEQ=p_HEAP; 
    RETURN V_XR; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN RETURN NULL; 
  end getTaskXR;  
  ------------------------------------------------------------------------------ 
  procedure setTask(      -- creates or replaces task 
      P_HEAP          integer,  -- sequence of heap 
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_EXEC_COND     varchar2, -- Execute condition 
      P_SKIP_COND     varchar2, -- Skip condition 
      P_EXEC_FLAG     varchar2, -- Flag to execute process 
      P_SKIP_FLAG     varchar2, -- Flag to skip process 
      P_EXEC_CODE     VARCHAR2, -- Execution code 
      P_PRIORITY      NUMBER,   -- Priority pf task 
      P_TAG           VARCHAR2  --change tag  
  ) IS 
    v_XR_old XMLTYPE:=GetTaskXR(P_ID, P_HEAP); 
    V_XR_NEW XMLTYPE; 
    v_SEQ Integer; 
  BEGIN 
    MERGE INTO BWTA_TASK TRG$ 
    using ( select 
       P_HEAP          as HEAP_SEQ 
      ,P_ID            as id 
      ,P_NOTE          as NOTE 
      ,P_EXEC_COND     as EXEC_COND 
      ,P_SKIP_COND     as SKIP_COND 
      ,P_EXEC_FLAG     as EXEC_FLAG 
      ,P_SKIP_FLAG     as SKIP_FLAG 
      ,P_EXEC_CODE     as EXEC_CODE 
      ,p_PRIORITY     as PRIORITY 
    FROM DUAL) SRC$ 
    ON( 
       TRG$.HEAP_SEQ=SRC$.HEAP_SEQ 
       AND TRG$.id=SRC$.id 
    ) 
    WHEN MATCHED THEN UPDATE SET 
       TRG$.NOTE=SRC$.NOTE 
      ,TRG$.EXEC_COND=SRC$.EXEC_COND 
      ,TRG$.SKIP_COND=SRC$.SKIP_COND 
      ,TRG$.EXEC_FLAG=SRC$.EXEC_FLAG 
      ,TRG$.SKIP_FLAG=SRC$.SKIP_FLAG 
      ,TRG$.EXEC_CODE=SRC$.EXEC_CODE 
      ,TRG$.PRIORITY=SRC$.PRIORITY 
    where --update when 
          ((TRG$.NOTE is not null or SRC$.NOTE is not null) 
            and LNNVL(TRG$.NOTE = SRC$.NOTE)) 
       or ((TRG$.EXEC_COND is not null or SRC$.EXEC_COND is not null) 
            and LNNVL(TRG$.EXEC_COND = SRC$.EXEC_COND)) 
       or ((TRG$.SKIP_COND is not null or SRC$.SKIP_COND is not null) 
            and LNNVL(TRG$.SKIP_COND = SRC$.SKIP_COND)) 
       or ((TRG$.EXEC_FLAG is not null or SRC$.EXEC_FLAG is not null) 
            and LNNVL(TRG$.EXEC_FLAG = SRC$.EXEC_FLAG)) 
       or ((TRG$.SKIP_FLAG is not null or SRC$.SKIP_FLAG is not null) 
            and LNNVL(TRG$.SKIP_FLAG = SRC$.SKIP_FLAG)) 
       or ((TRG$.EXEC_CODE is not null or SRC$.EXEC_CODE is not null) 
            and LNNVL(TRG$.EXEC_CODE = SRC$.EXEC_CODE)) 
       or ((TRG$.PRIORITY is not null or SRC$.PRIORITY is not null) 
            and LNNVL(TRG$.PRIORITY = SRC$.PRIORITY)) 
    WHEN NOT MATCHED THEN INSERT( 
       TRG$.HEAP_SEQ 
      ,TRG$.ID 
      ,TRG$.NOTE 
      ,TRG$.EXEC_COND 
      ,TRG$.SKIP_COND 
      ,TRG$.EXEC_FLAG 
      ,TRG$.SKIP_FLAG 
      ,TRG$.EXEC_CODE 
      ,TRG$.PRIORITY 
    )VALUES( 
       SRC$.HEAP_SEQ 
      ,SRC$.ID 
      ,SRC$.NOTE 
      ,SRC$.EXEC_COND 
      ,SRC$.SKIP_COND 
      ,SRC$.EXEC_FLAG 
      ,SRC$.SKIP_FLAG 
      ,SRC$.EXEC_CODE 
      ,SRC$.PRIORITY 
    ); 
    V_XR_NEW :=GETTASKXR(P_ID, P_HEAP); 
    V_SEQ:=V_XR_NEW.EXTRACT('/BWTA_TASK/SEQ/text()').GETNUMBERVAL; 
    IF V_XR_OLD IS NULL THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,NEW_VAL,TAG,TABLE_NAME) 
       values (V_SEQ,systimestamp,'I',V_XR_NEW,P_TAG,'BWTA_TASK'); 
    ELSIF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_TASK'); 
    end if;    
  end setTask; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setTask(-- creates tasks 
      P_HEAP          integer,  -- sequence of heap 
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_EXEC_CODE     VARCHAR2, -- Execution code 
      P_PRIORITY      number,   -- Priority pf task 
      P_TAG           VARCHAR2  --change tag  
  ) is 
    v_taskrec BWTA_TASK%ROWTYPE;     
  begin 
    begin  
      select * into V_TASKREC from BWTA_TASK where id=P_ID and HEAP_SEQ=P_HEAP; 
    EXCEPTION when NO_DATA_FOUND then null; 
    end; 
    setTask( 
       P_HEAP  
      ,P_ID   
      ,P_NOTE     
      ,v_taskrec.EXEC_COND 
      ,v_taskrec.SKIP_COND  
      ,v_taskrec.EXEC_FLAG 
      ,v_taskrec.SKIP_FLAG 
      ,P_EXEC_CODE 
      ,P_PRIORITY 
      ,P_TAG 
    );  
  end setTask; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setTask(-- creates tasks 
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_EXEC_CODE     varchar2, -- Execution code 
      P_PRIORITY      number,   -- Priority pf task 
      P_TAG           varchar2  -- Change tag  
  ) is 
  begin 
    setTask( 
       -1  
      ,P_ID   
      ,P_NOTE     
      ,P_EXEC_CODE 
      ,P_PRIORITY 
      ,P_TAG 
    );  
  end setTask; 
  ------------------------------------------------------------------------------ 
  PROCEDURE delTask(-- removes task  
      P_ID            varchar2, -- Identifier of task 
      P_HEAP          integer,  -- Sequence of heap 
      P_TAG           varchar2  -- Change tag  
  ) is 
    v_XR_old XMLTYPE:=GetTaskXR(P_ID, P_HEAP); 
    V_SEQ INTEGER; 
  BEGIN  
    IF V_XR_OLD is null THEN  
      Raise NO_DATA_FOUND; 
    END IF; 
    V_SEQ:=V_XR_OLD.EXTRACT('/BWTA_TASK/SEQ/text()').GETNUMBERVAL; 
    FOR R1 IN  
      (select SEQ1, SEQ2 from BWTA_TASK_REL where V_SEQ in (SEQ1, SEQ2)) 
    LOOP 
       DelTaskRel(r1.seq1, r1.seq2, P_TAG); 
    End Loop; 
    FOR R1 IN  
      (select Task_SEQ, Res_SEQ from BWTA_TASK_RES where Task_seq = V_SEQ) 
    LOOP 
       DelTaskRes(r1.Task_seq, r1.Res_seq, P_TAG); 
    end loop; 
    DELETE FROM BWTA_LOG_ERR WHERE TASK_SEQ=V_SEQ; 
    DELETE FROM BWTA_TASK WHERE SEQ=V_SEQ; 
    INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'D',V_XR_OLD,P_TAG,'BWTA_TASK'); 
  END delTask; 
  ------------------------------------------------------------------------------ 
  PROCEDURE renameTask(-- renames task  
      P_OLD_ID        varchar2, -- Identifier of task 
      P_NEW_ID        varchar2, -- Identifier of task, new 
      P_HEAP          integer,  -- Sequence of heap 
      P_TAG           varchar2  -- Change tag  
  ) IS 
    v_XR_old XMLTYPE:=GetTaskXR(P_OLD_ID, P_HEAP); 
    V_XR_NEW XMLTYPE; 
    V_SEQ INTEGER:=V_XR_old.EXTRACT('/BWTA_TASK/SEQ/text()').GETNUMBERVAL;
  BEGIN
    UPDATE BWTA_TASK SET ID=P_NEW_ID WHERE SEQ=V_SEQ;  
    V_XR_NEW :=GETTASKXR(P_NEW_ID, P_HEAP); 
    IF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_TASK'); 
    END IF;    
  END renameTask;
  ------------------------------------------------------------------------------ 
  -- HEAP                                                                    --  
  ------------------------------------------------------------------------------ 
  FUNCTION  getHeapXR (P_ID Varchar2) RETURN XMLTYPE IS 
    v_XR XMLTYPE; 
  BEGIN 
    SELECT XMLELEMENT( "BWTA_HEAP", XMLFOREST( 
     SEQ 
    ,ID 
    ,NOTE 
    ,STAT_ROUND_SEQ 
      )) "VAL" 
    INTO v_XR 
    FROM BWTA_HEAP 
    WHERE ID=P_ID; 
    RETURN V_XR; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN RETURN NULL; 
  END getHeapXR; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setHeap(-- creates heap 
      P_ID            varchar2, -- Identifier of task 
      P_NOTE          varchar2, -- Note  
      P_TAG           varchar2  --change tag  
  ) IS 
    v_XR_old XMLTYPE:=GetHeapXR(P_ID); 
    V_XR_NEW XMLTYPE; 
    V_SEQ INTEGER; 
  begin 
    MERGE INTO BWTA_HEAP TRG$ 
    using ( select 
       P_ID as id 
      ,P_NOTE as NOTE 
    FROM DUAL) SRC$ 
    on( 
          TRG$.ID=SRC$.ID 
    ) 
    WHEN MATCHED THEN UPDATE SET 
       TRG$.NOTE=SRC$.NOTE 
    WHERE --update when 
          ((TRG$.NOTE is not null or SRC$.NOTE is not null) 
            and LNNVL(TRG$.NOTE = SRC$.NOTE)) 
    WHEN NOT MATCHED THEN INSERT( 
       TRG$.ID 
      ,TRG$.NOTE 
    )VALUES( 
       SRC$.ID 
      ,SRC$.NOTE 
    ); 
    V_XR_NEW :=GETHeapXR(P_ID); 
    V_SEQ:=V_XR_NEW.EXTRACT('/BWTA_HEAP/SEQ/text()').GETNUMBERVAL; 
    IF V_XR_OLD IS NULL THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,NEW_VAL,TAG,TABLE_NAME) 
       values (V_SEQ,systimestamp,'I',V_XR_NEW,P_TAG,'BWTA_HEAP'); 
    ELSIF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_HEAP'); 
    END IF;    
  END setHeap; 
  ------------------------------------------------------------------------------ 
  PROCEDURE delHeap(-- removes Heap  
      P_ID            varchar2, -- ID of heap 
      P_TAG           varchar2 --change tag  
  ) IS 
    V_XR_OLD XMLTYPE:=GetHeapXR(P_ID); 
    V_SEQ INTEGER; 
  BEGIN 
    DELETE FROM BWTA_HEAP WHERE ID=P_ID; 
    V_SEQ:=V_XR_OLD.EXTRACT('/BWTA_HEAP/SEQ/text()').GETNUMBERVAL; 
    INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'D',V_XR_OLD,P_TAG,'BWTA_HEAP'); 
  END delHeap; 
  ------------------------------------------------------------------------------ 
  PROCEDURE renameHeap(-- renames heap  
      P_OLD_ID        varchar2, -- Identifier of heap 
      P_NEW_ID        varchar2, -- Identifier of heap, new 
      P_TAG           varchar2  --change tag  
  ) IS 
    v_XR_old XMLTYPE:=GetHeapXR(P_OLD_ID); 
    V_XR_NEW XMLTYPE; 
    V_SEQ INTEGER:=V_XR_old.EXTRACT('/BWTA_HEAP/SEQ/text()').GETNUMBERVAL;
  BEGIN
    UPDATE BWTA_HEAP SET ID=P_NEW_ID WHERE SEQ=V_SEQ;  
    V_XR_NEW :=GETHEAPXR(P_NEW_ID); 
    IF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_HEAP'); 
    END IF;    
  END renameHeap;
  ------------------------------------------------------------------------------ 
  -- TASK_REL                                                                 --  
  ------------------------------------------------------------------------------ 
  FUNCTION  getTaskRelXR (P_SEQ1 Integer, p_SEQ2 Integer) RETURN XMLTYPE IS 
    v_XR XMLTYPE; 
  BEGIN 
    SELECT XMLELEMENT( "BWTA_TASK_REL", XMLFOREST( 
     SEQ1 
    ,SEQ2 
    ,SKIP_FLAG 
      )) "VAL" 
    INTO v_XR 
    FROM BWTA_TASK_REL 
    WHERE SEQ1=P_SEQ1 and SEQ2=P_SEQ2; 
    RETURN V_XR; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN RETURN NULL; 
  END getTaskRelXR; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setTaskRel(-- adds task rel  
      P_SEQ1          integer, --depending task seq 
      P_SEQ2          integer, --predecesssor task seq 
      P_SKIP_FLAG     integer, --1 if to be ignored 
      P_TAG           varchar2 --change tag  
  ) IS 
    v_XR_old XMLTYPE:=GetTaskRelXR(P_SEQ1,P_SEQ2); 
    V_XR_NEW XMLTYPE; 
  BEGIN 
    MERGE INTO BWTA_TASK_REL TRG$ 
    USING ( SELECT 
       P_SEQ1 as SEQ1 
      ,P_SEQ2 as SEQ2 
      ,P_SKIP_FLAG as SKIP_FLAG 
    FROM DUAL) SRC$ 
    ON( 
          TRG$.SEQ1=SRC$.SEQ1 
      AND TRG$.SEQ2=SRC$.SEQ2 
    ) 
    WHEN MATCHED THEN UPDATE SET 
       TRG$.SKIP_FLAG=SRC$.SKIP_FLAG 
    WHERE --update when 
          ((TRG$.SKIP_FLAG is not null or SRC$.SKIP_FLAG is not null) 
            and LNNVL(TRG$.SKIP_FLAG = SRC$.SKIP_FLAG)) 
    WHEN NOT MATCHED THEN INSERT( 
       TRG$.SEQ1 
      ,TRG$.SEQ2 
      ,TRG$.SKIP_FLAG 
    )VALUES( 
       SRC$.SEQ1 
      ,SRC$.SEQ2 
      ,SRC$.SKIP_FLAG 
    ); 
    V_XR_NEW :=GETTaskRelXR(P_SEQ1,P_SEQ2); 
    IF V_XR_OLD IS NULL THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,SEQ2,DT,OPERATION,NEW_VAL,TAG,TABLE_NAME) 
       values (P_SEQ1,P_SEQ2,systimestamp,'I',V_XR_NEW,P_TAG,'BWTA_TASK_REL'); 
    ELSIF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,SEQ2,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (P_SEQ1,P_SEQ2,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_TASK_REL'); 
    END IF;    
  END setTaskRel; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setTaskRel( 
      P_ID1           varchar2, -- ID of dependent task 
      P_ID2           varchar2, -- ID of predecessor 
      P_HEAP          integer,  -- Sequence of heap     
      P_SKIP_FLAG     integer, --1 if to be ignored 
      P_TAG           varchar2 --change tag  
  ) is 
    v_seq1 number; 
    v_seq2 number; 
  begin 
    SELECT SEQ INTO V_SEQ1 FROM BWTA_TASK WHERE HEAP_SEQ=P_HEAP AND ID=P_ID1;  
    SELECT SEQ INTO V_SEQ2 FROM BWTA_TASK WHERE HEAP_SEQ=P_HEAP AND ID=P_ID2; 
    SetTaskRel(V_SEQ1,V_SEQ2,P_SKIP_FLAG,P_TAG); 
  end setTaskRel; 
  ------------------------------------------------------------------------------ 
  PROCEDURE delTaskRel(-- removes task rel  
      P_SEQ1          integer, -- ID of dependent task 
      P_SEQ2          integer, -- ID of predecessor 
      P_TAG           varchar2 --change tag  
  ) IS 
    V_XR_OLD XMLTYPE:=GetTaskRelXR(P_SEQ1,P_SEQ2); 
  begin 
    DELETE FROM BWTA_TASK_REL WHERE SEQ1=P_SEQ1 AND SEQ2=P_SEQ2; 
    INSERT INTO BWTA_LOG_METADATA(SEQ,SEQ2,DT,OPERATION,OLD_VAL,TAG,TABLE_NAME) 
       VALUES (P_SEQ1,P_SEQ2,SYSTIMESTAMP,'D',V_XR_OLD,P_TAG,'BWTA_TASK_REL'); 
  End delTaskRel; 
  ------------------------------------------------------------------------------ 
  -- TASK_RES                                                                 --  
  ------------------------------------------------------------------------------ 
  FUNCTION  getTaskResXR (P_TASK_SEQ Integer, P_RES_SEQ Integer) RETURN XMLTYPE IS 
    v_XR XMLTYPE; 
  BEGIN 
    SELECT XMLELEMENT( "BWTA_TASK_RES", XMLFOREST( 
     TASK_SEQ 
    ,RES_SEQ 
    ,AMOUNT 
      )) "VAL" 
    INTO v_XR 
    FROM BWTA_TASK_RES 
    WHERE TASK_SEQ=P_TASK_SEQ AND RES_SEQ=P_RES_SEQ; 
    RETURN V_XR; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN RETURN NULL; 
  END getTaskResXR;   
  ------------------------------------------------------------------------------ 
  procedure setTaskRes(-- creates relaton between process and resource 
      P_TASK_SEQ      integer, -- ID of task 
      P_RES_SEQ       integer, -- ID of resource 
      P_AMOUNT        number,   -- consumption of the resource for the process 
      P_TAG           varchar2 --change tag  
  ) IS 
    V_XR_OLD XMLTYPE:=GetTaskResXR(P_TASK_SEQ,P_RES_SEQ); 
    V_XR_NEW XMLTYPE; 
  BEGIN 
    MERGE INTO BWTA_TASK_RES TRG$ 
    USING ( SELECT 
       P_TASK_SEQ as TASK_SEQ 
      ,P_RES_SEQ as RES_SEQ 
      ,P_AMOUNT as AMOUNT 
    FROM DUAL) SRC$ 
    ON( 
          TRG$.TASK_SEQ=SRC$.TASK_SEQ 
      AND TRG$.RES_SEQ=SRC$.RES_SEQ 
    ) 
    WHEN MATCHED THEN UPDATE SET 
       TRG$.AMOUNT=SRC$.AMOUNT 
    WHERE --update when 
          ((TRG$.AMOUNT is not null or SRC$.AMOUNT is not null) 
            and LNNVL(TRG$.AMOUNT = SRC$.AMOUNT)) 
    WHEN NOT MATCHED THEN INSERT( 
       TRG$.TASK_SEQ 
      ,TRG$.RES_SEQ 
      ,TRG$.AMOUNT 
    )VALUES( 
       SRC$.TASK_SEQ 
      ,SRC$.RES_SEQ 
      ,SRC$.AMOUNT 
    ); 
    V_XR_NEW :=GetTaskResXR(P_TASK_SEQ,P_RES_SEQ); 
    IF V_XR_OLD IS NULL THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,SEQ2,DT,OPERATION,NEW_VAL,TAG,TABLE_NAME) 
       values (P_TASK_SEQ,P_RES_SEQ,SYSTIMESTAMP,'I',V_XR_NEW,P_TAG,'BWTA_TASK_RES'); 
    ELSIF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,SEQ2,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (P_TASK_SEQ,P_RES_SEQ,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_TASK_RES'); 
    end if;    
  END setTaskRes; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setTaskRes(-- creates relaton between process and resource 
      P_TASK_ID       varchar2, -- ID of task 
      P_HEAP          integer,  -- sequence of heap 
      P_RES_ID        varchar2, -- ID of resource 
      P_AMOUNT        number,   -- consumption of the resource for the process 
      P_TAG           varchar2 --change tag  
  ) IS 
    V_PROC_SEQ INTEGER; 
    v_res_seq Integer; 
  begin 
    SELECT SEQ INTO V_PROC_SEQ FROM BWTA_TASK WHERE HEAP_SEQ=P_HEAP AND ID=P_TASK_ID;  
    SELECT SEQ INTO V_RES_SEQ FROM BWTA_RES WHERE  ID=P_RES_ID; 
    setTaskRes(V_PROC_SEQ, V_RES_SEQ, P_AMOUNT, P_TAG); 
  exception 
    when DUP_VAL_ON_INDEX then null;   
  end setTaskRes; 
  ------------------------------------------------------------------------------ 
  PROCEDURE delTaskRes(-- removes task res  
      P_TASK_SEQ      INTEGER, -- SEQ of task 
      P_RES_SEQ       INTEGER, -- SEQ of resource 
      P_TAG           VARCHAR2 --change tag  
  ) is 
    V_XR_OLD XMLTYPE:=GETTASKRESXR(P_TASK_SEQ,P_RES_SEQ); 
  BEGIN 
    DELETE FROM BWTA_TASK_RES WHERE Task_SEQ=P_Task_SEQ AND Res_SEQ=P_Res_SEQ; 
    INSERT INTO BWTA_LOG_METADATA(SEQ,SEQ2,DT,OPERATION,OLD_VAL,TAG,TABLE_NAME) 
       VALUES (P_TASK_SEQ,P_RES_SEQ,SYSTIMESTAMP,'D',V_XR_OLD,P_TAG,'BWTA_TASK_RES'); 
  END delTaskRes; 
  ------------------------------------------------------------------------------ 
  -- RES                                                                      --  
  ------------------------------------------------------------------------------ 
  FUNCTION  getResXR (P_ID Varchar2) RETURN XMLTYPE IS 
    v_XR XMLTYPE; 
  BEGIN 
    SELECT XMLELEMENT( "BWTA_RES", XMLFOREST( 
     SEQ 
    ,ID 
    ,NOTE 
    ,AMOUNT 
    ,PENDING 
      )) "VAL" 
    INTO v_XR 
    FROM BWTA_RES 
    WHERE ID=P_ID; 
    RETURN V_XR; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN RETURN NULL; 
  END getResXR; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setRes(  --creates or updates Res 
    P_ID      varchar2, -- id of resource 
    P_NOTE    varchar2, -- note if omit then ID will be used 
    P_AMOUNT  number,   -- available amount (default 100) 
    P_PENDING integer,  --0..resource released after end of process 
              --1..resource should be released by negative consumption 
    P_TAG     varchar2 --change tag  
  )IS 
    v_XR_old XMLTYPE:=GetResXR(P_ID); 
    V_XR_NEW XMLTYPE; 
    V_SEQ INTEGER; 
  BEGIN 
    MERGE INTO BWTA_RES TRG$ 
    USING ( SELECT 
       P_ID as ID 
      ,P_NOTE as NOTE 
      ,P_AMOUNT as AMOUNT 
      ,P_PENDING as PENDING 
    FROM DUAL) SRC$ 
    ON( 
          TRG$.ID=SRC$.ID 
    ) 
    WHEN MATCHED THEN UPDATE SET 
       TRG$.NOTE=SRC$.NOTE 
      ,TRG$.AMOUNT=SRC$.AMOUNT 
      ,TRG$.PENDING=SRC$.PENDING 
    WHERE --update when 
          ((TRG$.NOTE is not null or SRC$.NOTE is not null) 
            and LNNVL(TRG$.NOTE = SRC$.NOTE)) 
       or ((TRG$.AMOUNT is not null or SRC$.AMOUNT is not null) 
            and LNNVL(TRG$.AMOUNT = SRC$.AMOUNT)) 
       or ((TRG$.PENDING is not null or SRC$.PENDING is not null) 
            and LNNVL(TRG$.PENDING = SRC$.PENDING)) 
    WHEN NOT MATCHED THEN INSERT( 
       TRG$.ID 
      ,TRG$.NOTE 
      ,TRG$.AMOUNT 
      ,TRG$.PENDING 
    )VALUES( 
       SRC$.ID 
      ,SRC$.NOTE 
      ,SRC$.AMOUNT 
      ,SRC$.PENDING 
    ); 
    V_XR_NEW :=GETResXR(P_ID); 
    V_SEQ:=V_XR_NEW.EXTRACT('/BWTA_RES/SEQ/text()').GETNUMBERVAL; 
    IF V_XR_OLD IS NULL THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,NEW_VAL,TAG,TABLE_NAME) 
       values (V_SEQ,systimestamp,'I',V_XR_NEW,P_TAG,'BWTA_RES'); 
    ELSIF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_RES'); 
    END IF;    
  END setRes; 
  ------------------------------------------------------------------------------ 
  PROCEDURE delRes(-- removes res  
      P_ID            varchar2, -- ID of resource 
      P_TAG           varchar2 --change tag  
  ) is 
    V_XR_OLD XMLTYPE:=GETRESXR(P_ID); 
    V_SEQ    INTEGER; 
  BEGIN 
    DELETE FROM BWTA_RES WHERE ID=P_ID; 
    V_SEQ:=V_XR_OLD.EXTRACT('/BWTA_RES/SEQ/text()').GETNUMBERVAL; 
    INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'D',V_XR_OLD,P_TAG,'BWTA_RES'); 
  END delRes; 
  ------------------------------------------------------------------------------ 
  PROCEDURE renameRes(-- renames RES  
      P_OLD_ID        varchar2, -- Identifier of RES 
      P_NEW_ID        varchar2, -- Identifier of RES, new 
      P_TAG           varchar2  --change tag  
  ) IS 
    v_XR_old XMLTYPE:=GetRESXR(P_OLD_ID); 
    V_XR_NEW XMLTYPE; 
    V_SEQ INTEGER:=V_XR_old.EXTRACT('/BWTA_RES/SEQ/text()').GETNUMBERVAL;
  BEGIN
    UPDATE BWTA_RES SET ID=P_NEW_ID WHERE SEQ=V_SEQ;  
    V_XR_NEW :=GETRESXR(P_NEW_ID); 
    IF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (V_SEQ,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_RES'); 
    END IF;    
  END renameRes;
  ------------------------------------------------------------------------------ 
  -- ERR                                                                      --  
  ------------------------------------------------------------------------------ 
  FUNCTION  getErrXR (P_ID Number) RETURN XMLTYPE IS 
    v_XR XMLTYPE; 
  BEGIN 
    SELECT XMLELEMENT( "BWTA_ERR", XMLFOREST( 
     ID 
    ,ATMPT_CNT 
    ,DELAY_DAY 
    ,PROLONG_KOEF 
    ,DIVERS_MOD 
      )) "VAL" 
    INTO v_XR 
    FROM BWTA_ERR 
    WHERE ID=P_ID; 
    RETURN V_XR; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN RETURN NULL; 
  END getErrXR; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setErr(  --creates or updates Error failover definition 
    P_ID           number,   -- Error code  
    P_ATMPT_CNT    integer,  -- Number of attempt of failover 
    P_DELAY_MIN    number,   -- Delay in minutes 
    P_PROLONG_KOEF number,   --Koefficient of prolong 
    P_DIVERS_MOD   number,   --Modifier for diversification of delay 
    P_TAG          varchar2 --change tag  
  )IS 
    v_XR_old XMLTYPE:=GetErrXR(P_ID); 
    V_XR_NEW XMLTYPE; 
  BEGIN 
    MERGE INTO BWTA_ERR TRG$ 
    USING ( SELECT 
       P_ID as ID 
      ,P_ATMPT_CNT AS ATMPT_CNT 
      ,P_DELAY_MIN/24/60 as DELAY_DAY 
      ,P_PROLONG_KOEF as PROLONG_KOEF 
      ,P_DIVERS_MOD as DIVERS_MOD 
    FROM DUAL) SRC$ 
    ON( 
          TRG$.ID=SRC$.ID 
    ) 
    WHEN MATCHED THEN UPDATE SET 
       TRG$.ATMPT_CNT=SRC$.ATMPT_CNT 
      ,TRG$.DELAY_DAY=SRC$.DELAY_DAY 
      ,TRG$.PROLONG_KOEF=SRC$.PROLONG_KOEF 
      ,TRG$.DIVERS_MOD=SRC$.DIVERS_MOD 
    WHERE --update when 
          ((TRG$.ATMPT_CNT is not null or SRC$.ATMPT_CNT is not null) 
            and LNNVL(TRG$.ATMPT_CNT = SRC$.ATMPT_CNT)) 
       or ((TRG$.DELAY_DAY is not null or SRC$.DELAY_DAY is not null) 
            and LNNVL(TRG$.DELAY_DAY = SRC$.DELAY_DAY)) 
       or ((TRG$.PROLONG_KOEF is not null or SRC$.PROLONG_KOEF is not null) 
            and LNNVL(TRG$.PROLONG_KOEF = SRC$.PROLONG_KOEF)) 
       or ((TRG$.DIVERS_MOD is not null or SRC$.DIVERS_MOD is not null) 
            and LNNVL(TRG$.DIVERS_MOD = SRC$.DIVERS_MOD)) 
    WHEN NOT MATCHED THEN INSERT( 
       TRG$.ID 
      ,TRG$.ATMPT_CNT 
      ,TRG$.DELAY_DAY 
      ,TRG$.PROLONG_KOEF 
      ,TRG$.DIVERS_MOD 
    )VALUES( 
       SRC$.ID 
      ,SRC$.ATMPT_CNT 
      ,SRC$.DELAY_DAY 
      ,SRC$.PROLONG_KOEF 
      ,SRC$.DIVERS_MOD 
    ); 
    V_XR_NEW :=GETErrXR(P_ID); 
    IF V_XR_OLD IS NULL THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,NEW_VAL,TAG,TABLE_NAME) 
       values (P_ID,systimestamp,'I',V_XR_NEW,P_TAG,'BWTA_ERR'); 
    ELSIF INSTR(V_XR_NEW.GETSTRINGVAL,V_XR_OLD.GETSTRINGVAL)!=1 THEN  
       INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,NEW_VAL,TAG,TABLE_NAME) 
       VALUES (P_ID,SYSTIMESTAMP,'U',V_XR_OLD,V_XR_NEW,P_TAG,'BWTA_ERR'); 
    END IF;    
  END setErr; 
  ------------------------------------------------------------------------------ 
  PROCEDURE setErr(  --creates or updates Error failover definition 
    P_ID           number,   -- Error code  
    P_ATMPT_CNT    integer,  -- Number of attempt of failover 
    P_DELAY_MIN    number,   -- Delay in minures 
    P_TAG          varchar2 --change tag  
  )IS 
    v_ERRrec BWTA_ERR%ROWTYPE;     
  BEGIN 
    BEGIN  
      select * into V_ERRREC from BWTA_ERR where id=P_ID; 
    EXCEPTION when NO_DATA_FOUND then null; 
    END; 
    SetErr(P_ID,P_ATMPT_CNT,P_DELAY_MIN,NVL(V_ERRREC.PROLONG_KOEF,1),NVL(V_ERRREC.DIVERS_MOD,1),P_TAG); 
  END setErr; 
  ------------------------------------------------------------------------------ 
  PROCEDURE delErr(-- removes res  
      P_ID            varchar2, -- ID of resource 
      P_TAG           varchar2 --change tag  
  ) IS 
    V_XR_OLD XMLTYPE:=GETErrXR(P_ID); 
  BEGIN 
    DELETE FROM BWTA_ERR WHERE ID=P_ID; 
    INSERT INTO BWTA_LOG_METADATA(SEQ,DT,OPERATION,OLD_VAL,TAG,TABLE_NAME) 
       VALUES (P_ID,SYSTIMESTAMP,'D',V_XR_OLD,P_TAG,'BWTA_ERR'); 
  END DelErr; 
  ------------------------------------------------------------------------------ 
End BWTA_METADATA;
/
----------------------------------------------------------------------
-- PACKAGE BWTA_OPER                                                --
----------------------------------------------------------------------
Create or replace PACKAGE "BWTA_OPER" IS 
  ----------------------------------------------------------------------------- 
  --Purpose: Simple processes and task management                            -- 
  --Author:  Bob Jankovsky, copyleft 2008, 2013                              -- 
  --History: 1.0 /09-SEP-2008                                                -- 
  --         1.1 /29-OCT-2008 -- robustness enhanced                         -- 
  --         1.2 /22-DEC-2008 -- pending resources supported                 -- 
  --         1.3 /22-JUN-2013 -- clering code                                -- 
  --         1.4 /19-JUL-2013 -- API enhanced based on GUI ergonomy check    -- 
  ------------------------------------------------------------------------------ 
  -- start round of jobs - No 1 procedure starting batch 
  ------------------------------------------------------------------------------ 
PROCEDURE startRound(-- Starts batch process for specified effective date and Heap  
    P_EFFECTIVE_DATE   date    := TRUNC(SYSDATE,'DD'), -- Effective date of round, if omit then current day will be considered 
    P_HEAP             number  := - 1,  -- Number of batch, if omit then the default batch -1 will be used 
    P_THREADS          integer := 5 -- Number of threads - parallel processes - the heap will be processed
  ) ; 
PROCEDURE startDailyRound( --Starts daily process (in row) so if last run round was 2013-02-01, the current will be 2013-02-02  
    P_HEAP             number := - 1,  -- Number of batch, if omit then the default batch -1 will be used  
    P_THREADS          integer := 5 -- Number of threads - parallel processes - the heap will be processed 
  ) ; 
PROCEDURE addThreads(-- Adds new threads for specified or last round running
    P_THREADS    integer := 5,   -- Number of threads - parallel  processes - to be added 
    P_ROUND      number  := NULL -- Sequence of round. If omit last round considered 
  ) ; 
PROCEDURE remThreads(-- removes sleeping threads from specified or last round 
    P_THREADS    integer := 1, -- Number of threads - parallel processes - to be removed
    P_ROUND      number := NULL -- Sequence of round. If omit last round considered 
  ) ; 
  ------------------------------------------------------------------------------ 
  -- job management 
  ------------------------------------------------------------------------------ 
PROCEDURE restartTask(-- Restarts specified process after it is suspended  
    -- or an error is fixed 
    P_TASK_ID varchar2, -- ID of task to be restarted 
    P_HEAP    number   := - 1,  -- Sequence of heap 
    P_FORCE   boolean  := false -- Restart even done task to be ran again 
  ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE wakeupThread --Wakes up sleeping threads immediately not waiting for 
  --the Job timing
  ; 
  ------------------------------------------------------------------------------ 
PROCEDURE checkOrphans --Checks invalid jobs and threads caused by potential 
  --inconsistency between system and metadata
  ; 
  ------------------------------------------------------------------------------ 
PROCEDURE shakeIt -- Service activity including Orphan checking and Waking up 
  --threads 
  ;
  ------------------------------------------------------------------------------ 
PROCEDURE stopTask( --Stops immediatelly running task    
  P_TASK_ID  varchar2, --ID of task to be stopped 
  P_HEAP     integer   --Heap of the stopped task
 ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE stop(-- Stops all running and planed jobs - in standard process it 
  -- lets all running tasks to be finished 
    P_IMMEDIATELLY boolean := FALSE -- Flag of immediate action to stop running tasks too
  ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE releaseThreads -- Restarts threads stopped by the stop or stopHeap method 
  ;
  ------------------------------------------------------------------------------ 
PROCEDURE stopHeap( -- Stops specified Heap
    P_HEAP integer -- Sequence key of Heap
  ); 
  ------------------------------------------------------------------------------ 
PROCEDURE releaseHeap( -- Releases specified heap stopped by the stop or stopHeap method 
    P_HEAP integer -- Sequence key of Heap
  ); 
  ------------------------------------------------------------------------------ 
PROCEDURE stopThread( -- Stops specified thread
    P_THREAD integer  -- Sequence key of Thread
  );  
  ------------------------------------------------------------------------------ 
PROCEDURE releaseThread( -- Releases stopped thread
    P_THREAD integer -- Sequence key of Thread
  ); 
  ------------------------------------------------------------------------------ 
PROCEDURE waitTask(  -- Sets task to be waiting
    P_ID     varchar2, -- ID of task
    P_HEAP   integer,  -- Sequence key of Heap 
    P_ROUND  integer , -- Sequence key of Round
    P_DT     date,     -- Date and time specified the end of waiting
    P_MSG    varchar2  -- The parameter allows to specify Error or Issue message
  ); 
  ------------------------------------------------------------------------------ 
PROCEDURE suspendTask(  --Sets task suspended
    P_ID     varchar2,  -- ID of task               
    P_HEAP   integer,   -- Sequence key of Heap     
    P_ROUND  integer,   -- Sequence key of Round    
    P_MSG    varchar2   -- The parameter allows to specify Error or Issue message 
  ); 
  ------------------------------------------------------------------------------ 
PROCEDURE doneTask( -- Sets task to the state DONE 
    P_ID     varchar2, -- ID of task                                             
    P_HEAP   integer,  -- Sequence key of Heap                                   
    P_ROUND  integer,  -- Sequence key of Round                                  
    P_MSG    varchar2  -- The parameter allows to specify Error or Issue message          
  ); 
  ------------------------------------------------------------------------------ 
PROCEDURE startGuard -- Starts the guard job assuring business continuity  
  ; 
  ------------------------------------------------------------------------------ 
PROCEDURE stopGuard -- Stops the guard job assuring business continuity  
  ; 
  ------------------------------------------------------------------------------ 
PROCEDURE gatherStatistics  -- Gathers statistics of done tasks average duration 
  ; 
  ------------------------------------------------------------------------------
PROCEDURE clearStatistics( -- Clears statistics for particular task
  --that allows to selectively delete obsolete statistics in the case things 
  --about particular task changed
     P_TASK_ID varchar2, -- ID of teh task 
     P_HEAP    integer   -- Sequence key of the Heap
  );                     
  ------------------------------------------------------------------------------ 
PROCEDURE manualTask ( --Runs manual action causing surrogate error to make 
  --the task wait
     P_ACTION_DESC varchar2 --Description of the action
  ); 
  ------------------------------------------------------------------------------ 
END BWTA_OPER;
/
----------------------------------------------------------------------
-- PACKAGE BODY BWTA_OPER                                           --
----------------------------------------------------------------------
Create or replace PACKAGE BODY "BWTA_OPER" IS 
  --- global variables 
  --------------------------------------------------------- 
  g_guard_name CONSTANT VARCHAR2(8) := 'BWTA$$_G'; 
  ------------------------------------------------------------------------------ 
------------------------------------------------------------------------------ 
PROCEDURE startRound(
    P_EFFECTIVE_DATE    date   := TRUNC( SYSDATE,'DD'),
    P_HEAP              number := - 1, 
    P_THREADS           integer := 5 
    ) 
IS 
  v_round_seq  NUMBER; 
  v_thread_seq NUMBER; 
BEGIN 
  INSERT 
  INTO BWTA_LOG_ROUND 
    ( 
      HEAP_SEQ 
    , EFFECTIVE_DATE 
    , START_DT 
    ) 
    VALUES 
    ( 
      p_heap 
    , p_effective_date 
    , sysdate 
    ) 
  RETURNING seq 
  INTO V_ROUND_SEQ; 
  addThreads(p_threads, v_round_seq) ; 
END startRound; 
------------------------------------------------------------------------------ 
PROCEDURE startDailyRound( 
    P_HEAP    number := - 1, 
    P_THREADS integer := 5 
    )
IS 
  v_effdt DATE; 
  v_unfinished Integer; 
BEGIN 
  SELECT MAX(EFFECTIVE_DATE) 
     ,sum(CASE WHEN END_DT IS NULL THEN 1 ELSE 0 END) 
  INTO v_effdt, v_unfinished  
  FROM BWTA_LOG_ROUND 
  WHERE HEAP_SEQ=P_HEAP; 
  IF v_unfinished =0 THEN  
    StartRound(TRUNC(v_EffDT+1,'DD')); 
  ELSE 
    raise_application_error(-20001,'Previous round not finished yet'); 
  END IF; 
  COMMIT;
END startDailyRound; 
------------------------------------------------------------------------------ 
PROCEDURE addThreads ( 
    P_THREADS integer := 5, 
    P_ROUND   number := NULL
    )
IS 
  v_round_seq NUMBER := p_round; 
BEGIN 
  IF p_round IS NULL THEN 
    SELECT MAX(seq) 
    INTO v_round_seq 
    FROM BWTA_LOG_ROUND; 
  END IF; 
  FOR i IN 1..p_threads 
  LOOP 
    INSERT 
    INTO BWTA_LOG_THREAD 
      ( 
        ROUND_SEQ 
      , STATUS 
      ) 
      VALUES 
      ( 
        v_round_seq 
      , BWTA_THREAD.c_stThread_SLEEPING 
      ) ; 
  END LOOP; 
  COMMIT;
  BWTA_THREAD.wakeupThread(v_round_seq) ; 
END addThreads; 
------------------------------------------------------------------------------ 
PROCEDURE remThreads ( 
    P_THREADS integer := 1, 
    P_ROUND   number := NULL 
    ) 
IS 
  v_round_seq NUMBER := p_round; 
  v_toStop    INTEGER; 
BEGIN 
  IF p_round IS NULL THEN 
    SELECT MAX(seq) 
    INTO v_round_seq 
    FROM BWTA_LOG_ROUND; 
  END IF; 
  BWTA_THREAD.checkOrphans(v_round_seq) ; 
  DELETE 
  FROM BWTA_LOG_THREAD 
  WHERE round_seq = v_round_seq 
    AND status = BWTA_THREAD.c_stThread_SLEEPING 
    AND rownum <= p_threads; 
  v_toStop := p_threads - SQL%ROWCOUNT; 
  IF v_toStop > 0 THEN 
    UPDATE BWTA_LOG_THREAD 
    SET command = BWTA_THREAD.c_cmdThread_STOP 
    WHERE round_seq = v_round_seq 
      AND rownum <= v_toStop; 
  END IF; 
  COMMIT; 
END remThreads; 
------------------------------------------------------------------------------ 
PROCEDURE restartTask( 
    P_TASK_ID varchar2, 
    P_HEAP    number := - 1, 
    P_FORCE   boolean := false
    ) 
IS 
  v_round_seq NUMBER; 
  v_task_seq  NUMBER; 
  v_status    VARCHAR2(100) ; 
BEGIN 
  SELECT seq 
  INTO v_task_seq 
  FROM BWTA_TASK 
  WHERE heap_seq = p_heap 
    AND ID = P_TASK_ID; 
  SELECT LR.SEQ 
  INTO v_round_seq 
  FROM BWTA_LOG_ROUND LR 
  WHERE LR.HEAP_SEQ = P_HEAP 
    AND LR.END_DT is null; 
  IF NOT p_force THEN 
    SELECT status 
    INTO v_status 
    FROM BWTA_LOG_TASK 
    WHERE task_seq = v_task_seq 
      AND ROUND_SEQ = V_ROUND_SEQ; 
    IF v_status NOT IN(BWTA_THREAD.c_stTask_FAILED,BWTA_THREAD.c_stTask_PLANNED, 
      BWTA_THREAD.c_stTask_SUSPENDED) THEN 
      RETURN; 
    END IF; 
  END IF; 
  BWTA_THREAD.switchStatus(v_task_seq, v_round_seq, 
  BWTA_THREAD.C_STTASK_PLANNED, NULL, SYSDATE) ; 
  BWTA_THREAD.WAKEUPTHREAD(V_ROUND_SEQ) ; 
  COMMIT;
END restartTask; 
------------------------------------------------------------------------------ 
PROCEDURE wakeupThread
IS 
BEGIN 
  BWTA_THREAD.wakeupThread ; 
END wakeupThread; 
------------------------------------------------------------------------------ 
PROCEDURE checkOrphans
IS 
BEGIN 
  BWTA_THREAD.checkOrphans; 
END checkOrphans; 
------------------------------------------------------------------------------ 
PROCEDURE shakeIt 
IS 
BEGIN 
  BWTA_THREAD.shakeIt; 
END shakeIt; 
------------------------------------------------------------------------------ 
PROCEDURE stopTask( --stops immediatelly running task    
  P_TASK_ID  varchar2, --Task ID 
  P_HEAP     integer --Heap of stopped task
) 
IS 
  V_THREAD_SEQ NUMBER; 
  V_TASK_SEQ   NUMBER; 
  V_ROUND_SEQ  NUMBER; 
BEGIN
  SELECT SEQ INTO V_TASK_SEQ FROM BWTA_TASK WHERE ID=P_TASK_ID AND HEAP_SEQ=P_HEAP;
  Select SEQ,ROUND_SEQ INTO v_thread_seq,v_round_seq FROM BWTA_LOG_THREAD WHERE TASK_SEQ=v_task_seq; 
  DBMS_SCHEDULER.STOP_JOB(BWTA_THREAD.c_thread_prefix ||to_char(v_thread_seq)) ; 
  UPDATE BWTA_LOG_THREAD 
    SET status = BWTA_THREAD.c_stThread_SLEEPING 
      , task_seq = NULL 
      , start_dt = NULL 
    WHERE SEQ = V_THREAD_SEQ; 
    BWTA_THREAD.SWITCHSTATUS(V_TASK_SEQ, V_ROUND_SEQ, 
        BWTA_THREAD.C_STTASK_SUSPENDED, NULL, NULL);
   COMMIT; 
EXCEPTION
WHEN NO_DATA_FOUND THEN NULL;
END stopTask; 
------------------------------------------------------------------------------ 
PROCEDURE stop(
    P_IMMEDIATELLY BOOLEAN := FALSE
    ) 
IS 
  v_thread_seq NUMBER; 
  v_task_seq   NUMBER; 
  v_round_seq  NUMBER; 
BEGIN 
  UPDATE BWTA_LOG_THREAD 
  SET command = BWTA_THREAD.c_cmdThread_STOP; 
  IF p_immediatelly THEN 
    FOR r1 IN 
    ( 
      SELECT job_name 
      FROM user_scheduler_jobs 
      WHERE job_name LIKE BWTA_THREAD.c_thread_prefix ||'%' 
    ) 
    LOOP 
      DBMS_SCHEDULER.STOP_JOB(r1.job_name) ; 
      v_thread_seq := to_number(SUBSTR(r1.job_name, 8)) ; 
      SELECT task_seq 
      , round_seq 
      INTO v_task_seq 
      , v_round_seq 
      FROM BWTA_LOG_THREAD 
      WHERE seq = v_thread_seq; 
      UPDATE BWTA_LOG_THREAD 
      SET status = BWTA_THREAD.c_stThread_SLEEPING 
      , task_seq = NULL 
      , start_dt = NULL 
      WHERE SEQ = V_THREAD_SEQ; 
      BWTA_THREAD.SWITCHSTATUS(V_TASK_SEQ, V_ROUND_SEQ, 
        BWTA_THREAD.C_STTASK_SUSPENDED, NULL, NULL);
      COMMIT; 
    END LOOP; 
  END IF; 
END stop; 
------------------------------------------------------------------------------ 
PROCEDURE releaseThreads  
IS 
BEGIN 
  UPDATE BWTA_LOG_THREAD 
  SET status = BWTA_THREAD.c_stThread_SLEEPING 
  WHERE status! = BWTA_THREAD.c_stThread_ACTIVE; 
  UPDATE BWTA_LOG_THREAD 
  SET command = NULL 
  , error_msg = NULL; 
  COMMIT; 
  BWTA_THREAD.WakeupThread; 
END releaseThreads; 
------------------------------------------------------------------------------ 
PROCEDURE stopHeap(
    P_HEAP integer    
    ) 
IS 
BEGIN 
  UPDATE BWTA_LOG_THREAD 
  SET COMMAND = BWTA_THREAD.C_CMDTHREAD_STOP 
  WHERE ROUND_SEQ IN (SELECT SEQ FROM BWTA_LOG_ROUND WHERE HEAP_SEQ=P_HEAP);
  COMMIT;
END stopHeap; 
------------------------------------------------------------------------------ 
PROCEDURE releaseHeap(
    P_HEAP integer
    ) 
IS 
BEGIN 
  UPDATE BWTA_LOG_THREAD 
  SET COMMAND = NULL 
  WHERE ROUND_SEQ IN (SELECT SEQ FROM BWTA_LOG_ROUND WHERE HEAP_SEQ=P_HEAP);
  COMMIT;
END releaseHeap; 
------------------------------------------------------------------------------ 
PROCEDURE stopThread(
    P_THREAD integer
    ) 
IS 
BEGIN 
  UPDATE BWTA_LOG_THREAD 
  SET COMMAND = BWTA_THREAD.C_CMDTHREAD_STOP 
  WHERE SEQ = P_THREAD;
  COMMIT;
END stopThread; 
------------------------------------------------------------------------------ 
PROCEDURE releaseThread(
    P_THREAD integer 
    ) 
IS 
BEGIN 
  UPDATE BWTA_LOG_THREAD 
  SET COMMAND = NULL 
  WHERE SEQ = P_THREAD;
  COMMIT;
END releaseThread; 
------------------------------------------------------------------------------ 
PROCEDURE waitTask(
    P_ID    varchar2, 
    P_HEAP  integer, 
    P_ROUND integer, 
    P_DT    date,    
    P_MSG   varchar2 
    ) 
IS 
  V_TASK_SEQ INTEGER;
  V_COUNT    INTEGER;
BEGIN
   SELECT SEQ INTO V_TASK_SEQ FROM BWTA_TASK WHERE ID=P_ID AND HEAP_SEQ=P_HEAP;
   SELECT COUNT(1) INTO V_COUNT FROM BWTA_LOG_TASK WHERE TASK_SEQ=V_TASK_SEQ AND ROUND_SEQ=P_ROUND;
   IF V_COUNT=0 THEN
      INSERT INTO BWTA_LOG_TASK(TASK_SEQ, ROUND_SEQ, STATUS)
      VALUES(V_TASK_SEQ, P_ROUND,BWTA_THREAD.C_STTASK_SUSPENDED) ;
   END IF;
   BWTA_THREAD.SWITCHSTATUS(V_TASK_SEQ, P_ROUND, 
        BWTA_THREAD.C_STTASK_PLANNED, P_MSG, P_DT);
   COMMIT; 
END waitTask; 
------------------------------------------------------------------------------ 
PROCEDURE suspendTask(
    P_ID    varchar2, 
    P_HEAP  integer, 
    P_ROUND integer, 
    P_MSG   varchar2 
    ) 
IS 
  V_TASK_SEQ INTEGER;
  V_COUNT    INTEGER;
BEGIN
   SELECT SEQ INTO V_TASK_SEQ FROM BWTA_TASK WHERE ID=P_ID AND HEAP_SEQ=P_HEAP;
   SELECT COUNT(1) INTO V_COUNT FROM BWTA_LOG_TASK WHERE TASK_SEQ=V_TASK_SEQ AND ROUND_SEQ=P_ROUND;
   IF V_COUNT=0 THEN
      INSERT INTO BWTA_LOG_TASK(TASK_SEQ, ROUND_SEQ, STATUS)
      VALUES(V_TASK_SEQ, P_ROUND,BWTA_THREAD.C_STTASK_SUSPENDED) ;
   ELSE 
      UPDATE BWTA_LOG_TASK SET START_DT=NULL
      WHERE TASK_SEQ=V_TASK_SEQ AND ROUND_SEQ=P_ROUND;
   END IF;
   BWTA_THREAD.SWITCHSTATUS(V_TASK_SEQ, P_ROUND, 
        BWTA_THREAD.C_STTASK_SUSPENDED, p_msg, NULL);
   COMMIT; 
END suspendTask; 
------------------------------------------------------------------------------ 
PROCEDURE doneTask(
    P_ID    varchar2,   
    P_HEAP  integer,    
    P_ROUND integer,    
    P_MSG   varchar2    
    ) 
IS 
  V_TASK_SEQ INTEGER;
  V_COUNT    INTEGER;
BEGIN
   SELECT SEQ INTO V_TASK_SEQ FROM BWTA_TASK WHERE ID=P_ID AND HEAP_SEQ=P_HEAP;
   SELECT COUNT(1) INTO V_COUNT FROM BWTA_LOG_TASK WHERE TASK_SEQ=V_TASK_SEQ AND ROUND_SEQ=P_ROUND;
   IF V_COUNT=0 THEN
      INSERT INTO BWTA_LOG_TASK(TASK_SEQ, ROUND_SEQ, STATUS)
      VALUES(V_TASK_SEQ, P_ROUND,BWTA_THREAD.C_STTASK_DONE) ;
   END IF;
   BWTA_THREAD.SWITCHSTATUS(V_TASK_SEQ, P_ROUND, 
        BWTA_THREAD.C_STTASK_DONE, p_msg, NULL);
   COMMIT;
   ShakeIt;
END doneTask; 
------------------------------------------------------------------------------ 
PROCEDURE startGuard 
IS 
BEGIN 
  DBMS_SCHEDULER.CREATE_JOB(job_name => g_guard_name, job_type => 'PLSQL_BLOCK' 
  , JOB_ACTION => 
  'begin BWTA_THREAD.ShakeIt;exception when others then null;end;' 
  , number_of_arguments => 0, start_date => sysdate, repeat_interval=> 
  'FREQ=MINUTELY;INTERVAL=5') ; 
  DBMS_SCHEDULER.ENABLE(g_guard_name) ; 
  COMMIT; 
END startGuard; 
------------------------------------------------------------------------------ 
PROCEDURE stopGuard 
IS 
BEGIN 
  DBMS_SCHEDULER.DROP_JOB(job_name => g_guard_name) ; 
  COMMIT; 
END stopGuard; 
------------------------------------------------------------------------------ 
PROCEDURE gatherStatistics 
IS 
BEGIN 
  FOR R1 IN 
  ( 
    WITH LRL as( 
      SELECT --+materialize  
        HEAP_SEQ, MAX(SEQ) ROUND_SEQ  
      FROM BWTA_LOG_ROUND 
      WHERE END_DT is not null 
      GROUP BY HEAP_SEQ 
    ) 
    SELECT H.SEQ 
     ,H.STAT_ROUND_SEQ 
     ,LRL.ROUND_SEQ as LAST_ROUND_SEQ 
    FROM BWTA_HEAP H 
    JOIN LRL on LRL.HEAP_SEQ=H.SEQ 
  ) 
  LOOP 
    Merge INTO BWTA_TASK T$TRG USING 
    ( 
      SELECT B.SEQ                   AS SEQ 
      , NVL(SUM  (A.END_DT - A.START_DT),0) AS SUM_DURATION 
      , NVL(COUNT(a.END_DT - a.START_DT),0) AS CNT_DURATION 
      FROM BWTA_LOG_TASK a 
      JOIN BWTA_TASK B 
      ON a.TASK_SEQ = B.SEQ 
      WHERE B.HEAP_SEQ = R1.SEQ 
        AND A.ROUND_SEQ >  R1.STAT_ROUND_SEQ 
        AND A.ROUND_SEQ <= R1.LAST_ROUND_SEQ 
        AND A.STATUS = 'DONE' 
      GROUP BY b.SEQ 
    ) 
    T$SRC ON(T$TRG.SEQ = T$SRC.SEQ) 
  WHEN matched THEN 
    UPDATE 
    SET T$TRG.AVG_DURATION =(T$SRC.SUM_DURATION +(NVL(T$TRG.CNT_DURATION,0) * 
      NVL(T$TRG.AVG_DURATION,0))) /(T$SRC.CNT_DURATION + NVL(T$TRG.CNT_DURATION,0)) 
    , T$TRG.CNT_DURATION = T$SRC.CNT_DURATION + NVL(T$TRG.CNT_DURATION,0) ; 
    UPDATE BWTA_HEAP SET STAT_ROUND_SEQ=R1.LAST_ROUND_SEQ; 
  END LOOP; 
  COMMIT;
END gatherStatistics; 
------------------------------------------------------------------------------ 
PROCEDURE clearStatistics(
    P_TASK_ID varchar2, 
    P_HEAP    integer  
    )
IS 
BEGIN
  UPDATE BWTA_TASK SET AVG_DURATION=NULL, CNT_DURATION=NULL
  WHERE ID=P_TASK_ID AND HEAP_SEQ=P_HEAP;
  COMMIT;
END clearStatistics;
------------------------------------------------------------------------------ 
PROCEDURE manualTask(
    P_ACTION_DESC varchar2   
    )
IS 
  V_ROUND_SEQ INTEGER;
BEGIN
  RAISE_APPLICATION_ERROR(-20999,'BWTA: Manual Action Expected ~'||P_ACTION_DESC||'~');
END manualTask;
------------------------------------------------------------------------------ 
END BWTA_OPER;
/
----------------------------------------------------------------------
-- PACKAGE BWTA_THREAD                                              --
----------------------------------------------------------------------
Create or replace PACKAGE "BWTA_THREAD" IS 
  ----------------------------------------------------------------------------- 
  --Purpose: Simple processes and task management  / thread self             -- 
  --Author:  Bob Jankovsky, copyleft 2008, 2013                              -- 
  --History: 1.0 /09-SEP-2008                                                -- 
  --         1.1 /29-OCT-2008 -- robustness enhanced                         -- 
  --         1.2 /22-DEC-2008 -- pending resources supported                 -- 
  --         1.3 /22-JUN-2013 -- clering code                                -- 
  ------------------------------------------------------------------------------ 
  -- constants 
  ------------------------------------------------------------------------------ 
  c_sttask_DONE       constant varchar2(4 char) := 'DONE'; --final status DONE 
  c_sttask_SKIPPED    constant varchar2(4 char) := 'SKIP'; --final status SKIPPED 
  c_sttask_PLANNED    constant varchar2(4 char) := 'WAIT'; --Waiting or planned 
  c_sttask_RUNNING    constant varchar2(6 char) := 'ACTIVE'; --Running task 
  c_sttask_FAILED     constant varchar2(5 char) := 'ERROR'; --Failed task 
  c_sttask_SUSPENDED  constant varchar2(7 char) := 'SUSPEND'; --Failed task 
  ------------------------------------------------------------------------------ 
  c_stthread_ACTIVE   constant varchar2(6 char) := 'ACTIVE'; 
  c_stthread_INACTIVE constant varchar2(8 char) := 'INACTIVE'; 
  c_stthread_ERROR    constant varchar2(5 char) := 'ERROR'; 
  c_stthread_SLEEPING constant varchar2(5 char) := 'SLEEP'; 
  ------------------------------------------------------------------------------ 
  c_cmdThread_STOP    constant varchar2(4 char) := 'STOP'; 
  ------------------------------------------------------------------------------ 
  C_LOCK_NAME_GETPROCTORUN constant varchar2(14 char) := 'BWTA_GPTR_LOCK'; 
  C_THREAD_PREFIX          constant varchar2(7 char)  := 'BWTA$$_'; 
  ------------------------------------------------------------------------------ 
  C_VAREFFDATE constant varchar2(15 char) := ':EFFECTIVE_DATE'; -- 
  C_VARTASK    constant varchar2(5 char)  := ':TASK'; -- 
  C_VARROUND   constant varchar2(6 char)  := ':ROUND'; -- 
  ------------------------------------------------------------------------------ 
  -- thread ... internally called process, do not call directly 
  ------------------------------------------------------------------------------ 
PROCEDURE thread( --Internally called process realizing the thread task
    --it realizes both the phases of orchestration (selects task to run) and
    --and execution of selected task  
    P_ROUND  number, -- Sequence key of round to be realized     
    P_THREAD number  -- Sequence key of thread to identify where the task is realized
  );    
  ------------------------------------------------------------------------------ 
PROCEDURE switchStatus( --Switches status of both task and thread driven by 
    --internal actions
    P_TASK   number, --Sequence key of Task
    P_ROUND  number, --Sequence key of Round 
    P_STATUS varchar2,  --Intended status to be set to task run
    P_ERR    varchar2 := NULL, --Error or issue message (optional)
    P_START  date     := NULL, --Start date to be set (optional)
    P_THREAD number   := NULL  --Thread realizing the change
  ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE wakeupThread(-- Wakes up threads of defined round  
    P_ROUND    number,         -- Sequence key of round 
    P_MIN_WAIT date := sysdate -- Minimum wait interval 
  ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE wakeupThread --Wakes up threads for all active rounds
  ;  
  ------------------------------------------------------------------------------ 
PROCEDURE checkOrphans(-- Checks "active" jobs in metadata without realy 
    -- scheduled jobs 
    P_ROUND number -- Sequence key of round the orphan jops will be eliminated
  ) ; 
  ------------------------------------------------------------------------------ 
PROCEDURE checkOrphans --Checks "active" jobs in metadata without realy scheduled 
    --of all active rounds 
  ;  
  ------------------------------------------------------------------------------ 
PROCEDURE shakeIt      --Checks Orphans and wakes up threads
  ;  
  ------------------------------------------------------------------------------ 
END BWTA_THREAD;
/
----------------------------------------------------------------------
-- PACKAGE BODY BWTA_THREAD                                         --
----------------------------------------------------------------------
Create or replace PACKAGE BODY "BWTA_THREAD" IS 
  ------------------------------------------------------------------------------ 
  --- global variables 
  --------------------------------------------------------- 
  G_CONTINUE boolean;  
  ------------------------------------------------------------------------------ 
  C_DTMASK  constant varchar2(16) := 'yyyymmddhh24miss'; 
  C_PKGNAME constant varchar2(11) := 'BWTA_THREAD'; 
  ------------------------------------------------------------------------------ 
  JOB_EXISTS exception; 
  PRAGMA EXCEPTION_INIT(job_exists, - 27477) ; 
  ------------------------------------------------------------------------------ 
FUNCTION getProcToRun( 
    P_ROUND number, 
    P_HEAP  number) 
  RETURN number 
IS -- flood method 
  v_amt NUMBER; 
  v_seq NUMBER := NULL; 
BEGIN 
  FOR r1 IN 
  ( 
  WITH L1 AS 
    ( 
      SELECT a.seq 
      , a.priority 
      , COUNT(c.seq2)   AS cnt_predecessors 
      , COUNT(d.end_dt) AS cnt_finished 
      FROM BWTA_TASK a 
      LEFT JOIN BWTA_LOG_TASK b 
      ON a.seq = b.task_seq 
        AND b.round_seq = p_round 
      LEFT JOIN BWTA_TASK_REL c 
      ON c.seq1 = a.seq 
        AND(c.skip_flag IS NULL 
        OR c.skip_flag = 0) 
      LEFT JOIN BWTA_LOG_TASK d 
      ON d.task_seq = c.seq2 
        AND d.round_seq = p_round 
        AND d.status IN(c_stTask_DONE, c_stTask_SKIPPED) --final statuses 
      WHERE a.heap_seq = p_heap 
        AND((b.status IS NULL) 
        OR(b.status = c_stTask_PLANNED 
        AND b.start_dt <= SYSDATE)) 
      GROUP BY a.priority 
      , a.seq 
    ) 
  SELECT seq 
  , priority 
  FROM L1 
  WHERE cnt_predecessors = cnt_finished 
  ORDER BY priority 
  , seq 
  ) 
  LOOP 
    v_amt := 0; --check resources 
    SELECT MIN(amount) 
    INTO v_amt 
    FROM 
      ( 
        SELECT b.seq 
        , MAX(b.amount) - SUM(A.amount) AS amount 
        FROM BWTA_TASK_RES a 
        JOIN BWTA_RES b 
        ON a.res_seq = b.seq 
        LEFT JOIN BWTA_LOG_TASK c 
        ON c.task_seq = a.task_seq 
          AND c.round_seq = p_round 
          AND(c.status = c_stTask_RUNNING 
          OR(b.pending = 1 
          AND c.status NOT IN(c_stTask_PLANNED, c_stTask_SKIPPED))) 
        WHERE(c.status IS NOT NULL 
          OR a.task_seq = r1.seq) 
        GROUP BY b.seq 
      ) ; 
    IF NVL(v_amt, 0) >= 0 THEN -- resources are enough 
      IF v_seq IS NULL THEN 
        v_seq := r1.seq; 
      ELSE 
        g_continue := true; 
        RETURN v_seq; 
      END IF; 
    END IF; 
  END LOOP; 
  g_continue := false; 
  RETURN v_seq; 
END getProcToRun; 
------------------------------------------------------------------------------ 
PROCEDURE thread_async( 
    P_ROUND  number,     
    P_THREAD number,     
    P_DT     date    := SYSDATE) 
IS 
  v_name VARCHAR2(100) := c_thread_prefix||TO_CHAR(p_thread) ; 
BEGIN 
  DBMS_SCHEDULER.CREATE_JOB(job_name => v_name, job_type => 'PLSQL_BLOCK', 
  job_action => 'begin '||c_pkgName||'.thread('||TO_CHAR(p_round) ||','|| 
  TO_CHAR(p_thread) ||');end;', number_of_arguments => 0, start_date => p_dt) ; 
  UPDATE BWTA_LOG_THREAD 
  SET status = c_stThread_INACTIVE 
  WHERE seq = p_thread; 
  DBMS_SCHEDULER.ENABLE(v_name) ; 
  COMMIT; 
END thread_async; 
------------------------------------------------------------------------------ 
PROCEDURE wakeupThread( 
    P_ROUND    number,                  
    P_MIN_WAIT date   := SYSDATE)      
IS 
  v_round_seq NUMBER := p_round; 
  v_repcnt    INTEGER := 5; 
BEGIN 
  WHILE v_repcnt > 0 
  LOOP 
    v_repcnt := v_repcnt - 1; 
    FOR r1 IN 
    ( 
      SELECT seq 
      FROM BWTA_LOG_THREAD 
      WHERE round_seq = v_round_seq 
        AND status = c_stThread_SLEEPING 
        AND NVL(command, '#') != c_cmdThread_STOP 
    ) 
    LOOP 
      BEGIN 
        thread_async(v_round_seq, r1.seq, p_min_wait) ; 
        v_repcnt := 0; 
      EXCEPTION 
      WHEN job_exists THEN 
        NULL; 
      END; 
      EXIT 
    WHEN v_repcnt = 0; 
    END LOOP; 
    IF v_repcnt > 0 THEN 
      DBMS_LOCK.sleep(1) ; 
    END IF; 
  END LOOP; 
  COMMIT; 
END wakeupThread; 
------------------------------------------------------------------------------ 
PROCEDURE wakeupThread 
IS 
BEGIN 
  FOR R1 IN (SELECT SEQ FROM BWTA_LOG_ROUND WHERE END_DT IS NULL) LOOP 
    WakeupThread(r1.seq); 
  end LOOP; 
END wakeupThread; 
------------------------------------------------------------------------------ 
PROCEDURE checkOrphans( 
    P_ROUND number 
    ) 
IS 
  v_round_seq   NUMBER := p_round; 
  v_orphanfound BOOLEAN := false; 
BEGIN 
  UPDATE BWTA_LOG_THREAD  
  SET start_dt = NULL 
  , task_seq = NULL 
  , STATUS = C_STTHREAD_SLEEPING 
  WHERE STATUS = C_STTHREAD_ACTIVE 
  AND C_THREAD_PREFIX||TO_CHAR(SEQ) NOT IN  
  (Select job_name from USER_SCHEDULER_JOBS); 
  IF SQL%ROWCOUNT > 0 THEN 
    v_orphanfound := true; 
  END IF; 
  UPDATE BWTA_LOG_TASK 
  SET status = c_stTask_PLANNED 
  , start_dt = sysdate 
  WHERE round_seq = v_round_seq 
    AND status = c_stTask_RUNNING 
    AND task_seq NOT IN 
    ( 
      SELECT task_seq 
      FROM BWTA_LOG_THREAD 
      WHERE status = c_stThread_ACTIVE 
    ) ; 
  IF SQL%ROWCOUNT > 0 THEN 
    v_orphanfound := true; 
  END IF; 
  COMMIT; 
  IF v_orphanfound THEN 
    wakeupThread(p_round) ; 
  END IF; 
END checkOrphans; 
------------------------------------------------------------------------------ 
PROCEDURE checkOrphans 
IS 
BEGIN 
  FOR R1 IN (SELECT SEQ FROM BWTA_LOG_ROUND WHERE END_DT IS NULL) LOOP 
    checkOrphans(r1.seq); 
  end LOOP; 
END checkOrphans; 
------------------------------------------------------------------------------ 
PROCEDURE shakeIt 
IS 
BEGIN 
  checkOrphans; 
  wakeupThread; 
END shakeIt; 
------------------------------------------------------------------------------ 
PROCEDURE switchStatus( 
    p_task   NUMBER, 
    p_round  NUMBER, 
    p_status VARCHAR2, 
    p_err    VARCHAR2 := NULL, 
    p_start DATE := NULL, 
    p_thread NUMBER := NULL) 
IS 
BEGIN 
  UPDATE BWTA_LOG_TASK 
  SET start_dt = NVL(p_start, start_dt) 
  , status = p_status 
  , end_dt = 
    CASE 
      WHEN p_status IN(C_STTASK_PLANNED, C_STTASK_RUNNING) 
      THEN NULL 
      ELSE sysdate 
    END 
  , error_msg = p_err 
  WHERE task_seq = p_task 
    AND round_seq = p_round; 
  UPDATE BWTA_LOG_THREAD 
  SET start_dt = NULL 
  , task_seq = NULL 
  , status = c_stthread_inactive 
  WHERE(p_thread IS NOT NULL 
    AND seq = p_thread) 
    OR(task_seq = p_task) ; 
  COMMIT; 
end switchStatus; 
------------------------------------------------------------------------------ 
procedure failOver( 
  P_ERROR_CODE varchar2, 
  P_ERROR_MSG varchar2, 
  P_TASK number, 
  P_ROUND number, 
  P_thread Number 
) is 
  V_ERRN         number; 
  v_atmpt_cnt    INTEGER; 
  v_delay_day    NUMBER; 
  v_prolong_koef NUMBER ; 
  v_divers_mod   INTEGER; 
Begin 
  SELECT COUNT(1) 
  INTO V_ERRN 
  FROM BWTA_LOG_ERR 
  WHERE task_seq = p_task 
    AND ROUND_SEQ = P_ROUND 
    AND ERR_ID = P_ERROR_CODE; 
  SELECT atmpt_cnt 
  , delay_day 
  , prolong_koef 
  , divers_mod 
  INTO v_atmpt_cnt 
  , v_delay_day 
  , v_prolong_koef 
  , v_divers_mod 
  FROM BWTA_ERR 
  WHERE id = P_ERROR_CODE; 
  IF NVL(v_errN, 0) < v_atmpt_cnt THEN 
    switchstatus(p_task, p_round, c_stTask_PLANNED, P_ERROR_MSG, sysdate +( 
    v_delay_day *(v_errn * v_prolong_koef + 1) *(mod(p_task, V_DIVERS_MOD) + 
    1)), p_thread) ; 
    INSERT 
    INTO BWTA_LOG_ERR 
      ( 
        TASK_SEQ 
      , ROUND_SEQ 
      , ERR_ID 
      , DT 
      ) 
      VALUES 
      ( 
        P_task 
      , P_ROUND 
      , P_ERROR_CODE 
      , systimestamp 
      ) ; 
    COMMIT; 
  ELSE 
    raise NO_DATA_FOUND; 
  END IF; 
EXCEPTION 
WHEN NO_DATA_FOUND THEN 
  SWITCHSTATUS(P_TASK, P_ROUND, C_STTASK_FAILED, P_ERROR_MSG, null, P_THREAD) ; 
END failOver; 
------------------------------------------------------------------------------ 
PROCEDURE exec( 
    P_TASK       number, 
    P_ROUND      number, 
    P_THREAD_SEQ number  
  ) 
IS 
  v_exec_cond VARCHAR2(8000) ; 
  v_skip_cond VARCHAR2(8000) ; 
  v_exec_flag INTEGER; 
  v_skip_flag INTEGER; 
  v_exec_code VARCHAR2(8000) ; 
  v_effective_date DATE; 
  v_effective_date_lit VARCHAR2(200) ; 
FUNCTION substVar( 
    p_code VARCHAR2) 
  RETURN VARCHAR2 
IS 
  v_code VARCHAR2(8000) := p_code; 
BEGIN 
  v_code := regexp_replace(v_code, '(\W)('||c_varEffDate||')(\W)', '\1'|| 
  v_effective_date_lit||'\3', 1, 1, 'i') ; 
  v_code := regexp_replace(v_code, '(\W)('||c_varTask||')(\W)', '\1'||TO_CHAR( 
  p_task) ||'\3', 1, 1, 'i') ; 
  v_code := regexp_replace(v_code, '(\W)('||c_varRound||')(\W)', '\1'||TO_CHAR( 
  p_round) ||'\3', 1, 1, 'i') ; 
  RETURN v_code; 
END substVar; 
BEGIN 
  SELECT effective_date 
  INTO v_effective_date 
  FROM BWTA_LOG_ROUND 
  WHERE seq = p_round; 
  v_effective_date_lit := 'to_date('''||TO_CHAR(v_effective_date, c_dtMask) || 
  ''','''||c_dtMask||''')'; 
  SELECT --get process data 
    exec_cond 
  , skip_cond 
  , exec_flag 
  , skip_flag 
  , exec_code 
  INTO v_exec_cond 
  , v_skip_cond 
  , v_exec_flag 
  , v_skip_flag 
  , v_exec_code 
  FROM BWTA_TASK 
  WHERE seq = p_task; 
  IF NVL(v_exec_flag, 1) = 1 AND v_exec_cond IS NOT NULL THEN --evaluate exec 
    -- condition 
    EXECUTE immediate 'Select case when '||substVar(v_exec_cond) || 
    ' then 1 else 0 end from dual' INTO v_exec_flag; 
  END IF; 
  IF NVL(v_exec_flag, 1) != 1 THEN 
    switchstatus(p_task, p_round, C_STTASK_PLANNED, NULL, sysdate +(1 / 24 / 6) 
    , p_thread_seq) ; 
  ELSE 
    IF NVL(v_skip_flag, 0) = 0 AND v_skip_cond IS NOT NULL THEN --evaluate skip 
      -- condition 
      EXECUTE immediate 'Select case when '||substVar(v_skip_cond) || 
      ' then 1 else 0 end from dual' INTO v_skip_flag; 
    END IF; 
    IF v_skip_flag = 1 THEN --process skip 
      switchstatus(p_task, p_round, C_STTASK_SKIPPED, NULL, NULL, p_thread_seq) 
      ; 
    ELSE --execute 
      ----------------------------------------------------------------------- 
      dbms_session.reset_package; 
      EXECUTE immediate substVar(v_exec_code) ; 
      ----------------------------------------------------------------------- 
      switchstatus(p_task, p_round, c_stTask_DONE, NULL, NULL, p_thread_seq) ; 
    END IF; 
  END IF; 
EXCEPTION 
WHEN OTHERS THEN -- Error diversified threatment 
  FAILOVER(SQLCODE,SUBSTR(SQLERRM||CHR(10) ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 
  3994),P_TASK, P_ROUND, P_THREAD_SEQ); 
END exec; 
------------------------------------------------------------------------------ 
PROCEDURE thread 
  ( 
    P_ROUND  number, 
    P_THREAD number 
  )                
IS 
  v_err        VARCHAR2(8000) ; 
  v_seq        NUMBER; 
  v_batch      NUMBER; 
  v_thread_seq NUMBER := p_thread; 
  v_lockhandle VARCHAR2(8000) ; 
  v_lockresult INTEGER; 
  v_command    VARCHAR2(8000) ; 
  v_min_wait DATE; 
  v_cnt INTEGER; 
BEGIN 
  SELECT heap_seq 
  INTO v_batch 
  FROM BWTA_LOG_ROUND 
  WHERE seq = p_round; 
  LOOP 
    SELECT command 
    INTO v_command 
    FROM BWTA_LOG_THREAD 
    WHERE seq = v_thread_seq; 
    EXIT 
  WHEN v_command = c_cmdThread_STOP; 
    checkOrphans(p_round) ; 
    DBMS_LOCK.ALLOCATE_UNIQUE(c_lock_name_getProcToRun, v_lockhandle) ; 
    v_lockresult := DBMS_LOCK.REQUEST(v_lockhandle) ; 
    v_seq := getProcToRun(p_round, v_batch) ; 
    IF v_seq IS NOT NULL THEN 
      Merge INTO BWTA_LOG_TASK T$TRG USING 
      ( 
        SELECT v_seq       AS task_seq 
        , p_round          AS round_seq 
        , c_stTask_RUNNING AS status 
        , sysdate          AS start_dt 
        FROM dual 
      ) 
      T$SRC ON(T$TRG.task_seq = T$SRC.task_seq AND T$TRG.round_seq = 
        T$SRC.round_seq) 
    WHEN NOT matched THEN 
      INSERT 
        ( 
          T$TRG.task_seq 
        , T$TRG.round_seq 
        , T$TRG.status 
        , T$TRG.start_dt 
        ) 
        VALUES 
        ( 
          T$SRC.task_seq 
        , T$SRC.round_seq 
        , T$SRC.status 
        , T$SRC.start_dt 
        ) 
        WHEN matched THEN 
      UPDATE 
      SET T$TRG.status = T$SRC.status 
      , T$TRG.start_dt = T$SRC.start_dt 
      , T$TRG.end_dt = NULL ; 
      Merge INTO BWTA_LOG_THREAD T$TRG USING 
      ( 
        SELECT v_thread_seq AS seq 
        , p_round           AS round_seq 
        , c_stThread_ACTIVE AS status 
        , SYSDATE           AS start_dt 
        , v_seq             AS task_seq 
        FROM dual 
      ) 
      T$SRC ON(T$TRG.seq = T$SRC.seq) 
    WHEN NOT matched THEN 
      INSERT 
        ( 
          T$TRG.seq 
        , T$TRG.round_seq 
        , T$TRG.task_seq 
        , T$TRG.status 
        , T$TRG.start_dt 
        ) 
        VALUES 
        ( 
          T$SRC.seq 
        , T$SRC.round_seq 
        , T$SRC.task_seq 
        , T$SRC.status 
        , T$SRC.start_dt 
        ) 
        WHEN matched THEN 
      UPDATE 
      SET T$TRG.status = T$SRC.status 
      , T$TRG.task_seq = T$SRC.task_seq 
      , T$TRG.round_seq = T$SRC.round_seq 
      , T$TRG.start_dt = T$SRC.start_dt ; 
      IF g_continue THEN --wake up another thread 
        wakeupThread(p_round) ; 
      END IF; 
    END IF; 
    COMMIT; 
    v_lockresult := DBMS_LOCK.RELEASE(v_lockhandle) ; 
    EXIT 
  WHEN v_seq IS NULL; 
    EXEC(v_seq, p_round, v_thread_seq) ; 
  END LOOP; 
  SELECT COUNT(1) 
  INTO v_cnt 
  FROM BWTA_TASK a --check the round is completed 
  LEFT JOIN BWTA_LOG_TASK b 
  ON A.seq = b.task_seq 
    AND b.round_seq = p_round 
  WHERE a.heap_seq = v_batch 
    AND b.STATUS IS NULL 
    OR b.STATUS NOT IN(c_stTask_DONE, c_stTask_SKIPPED) ; 
  IF v_cnt = 0 THEN -- completed 
    UPDATE BWTA_LOG_ROUND 
    SET end_dt = sysdate 
    WHERE seq = p_round; 
    DELETE BWTA_LOG_THREAD 
    WHERE round_seq = p_round 
      AND(status = c_stThread_SLEEPING 
      OR seq = v_thread_seq) ; 
    COMMIT; 
  ELSE --plan yourself if you are last one or there are waiting 
    SELECT MIN(start_dt) 
    INTO v_min_wait 
    FROM BWTA_LOG_TASK 
    WHERE status = c_stTask_PLANNED 
      AND round_seq = p_round; 
    IF v_min_wait IS NULL THEN 
      SELECT COUNT(1) 
      INTO v_cnt 
      FROM BWTA_LOG_THREAD 
      WHERE status IN(c_stThread_ACTIVE, c_stThread_INACTIVE) 
        AND round_seq = p_round; 
      IF v_cnt = 0 THEN 
        v_min_wait := sysdate +(1 / 24 / 12) ; 
      END IF; 
    END IF; 
    UPDATE BWTA_LOG_THREAD 
    SET start_dt = NULL 
    , task_seq = NULL 
    , status = c_stThread_SLEEPING 
    WHERE seq = v_thread_seq; 
    IF v_min_wait IS NOT NULL THEN 
      wakeupThread(p_round, v_min_wait) ; 
    END IF; 
    COMMIT; 
  END IF; 
EXCEPTION 
WHEN OTHERS THEN 
  v_err := sqlerrm; 
  UPDATE BWTA_LOG_THREAD 
  SET error_msg = v_err 
  , status = c_stThread_ERROR 
  WHERE seq = v_thread_seq; 
  COMMIT; 
END thread; 
-------------------------------------------------------------------------------- 
END BWTA_THREAD;
/
show errors;
