--------------------------------------------------------
--  DDL for Sequence BWTA_HEAP_SEQ
--------------------------------------------------------
   CREATE SEQUENCE  "BWTA_HEAP_SEQ"  MINVALUE 1 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE;
--------------------------------------------------------
--  DDL for Sequence BWTA_LOG_ROUND_SEQ
--------------------------------------------------------
   CREATE SEQUENCE  "BWTA_LOG_ROUND_SEQ"  MINVALUE 1 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE;
--------------------------------------------------------
--  DDL for Sequence BWTA_LOG_THREAD_SEQ
--------------------------------------------------------
   CREATE SEQUENCE  "BWTA_LOG_THREAD_SEQ"  MINVALUE 1 MAXVALUE 999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  CYCLE;
--------------------------------------------------------
--  DDL for Sequence BWTA_RES_SEQ
--------------------------------------------------------
   CREATE SEQUENCE  "BWTA_RES_SEQ"  MINVALUE 1 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE;
--------------------------------------------------------
--  DDL for Sequence BWTA_TASK_SEQ
--------------------------------------------------------
   CREATE SEQUENCE  "BWTA_TASK_SEQ"  MINVALUE 1 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE;
--------------------------------------------------------
--  DDL for Table BWTA_ERR
--------------------------------------------------------
  CREATE TABLE "BWTA_ERR" 
   (	"ID" NUMBER, 
	"ATMPT_CNT" NUMBER(*,0), 
	"DELAY_DAY" NUMBER, 
	"PROLONG_KOEF" NUMBER DEFAULT 0, 
	"DIVERS_MOD" NUMBER(*,0) DEFAULT 1
   ); 
   COMMENT ON COLUMN "BWTA_ERR"."ID" IS 'ORA error number';
   COMMENT ON COLUMN "BWTA_ERR"."ATMPT_CNT" IS 'Number of attempts' ;
   COMMENT ON COLUMN "BWTA_ERR"."DELAY_DAY" IS 'Delay specified as a fragment of day';
   COMMENT ON COLUMN "BWTA_ERR"."PROLONG_KOEF" IS 'Koefficient of prolongation of each next attempt';
   COMMENT ON COLUMN "BWTA_ERR"."DIVERS_MOD" IS 'Modulo used for diversification of particular processes';
   COMMENT ON TABLE "BWTA_ERR"  IS 'Maintained errors';
/
--------------------------------------------------------
--  DDL for Table BWTA_HEAP
--------------------------------------------------------
  CREATE TABLE "BWTA_HEAP" 
   (	"SEQ" NUMBER, 
	"ID" VARCHAR2(100), 
	"NOTE" VARCHAR2(500), 
	"STAT_ROUND_SEQ" NUMBER DEFAULT -1
   ); 
   COMMENT ON COLUMN "BWTA_HEAP"."SEQ" IS 'Sequence key of batch, -1 is default one';
   COMMENT ON COLUMN "BWTA_HEAP"."ID" IS 'ID of batch';
   COMMENT ON COLUMN "BWTA_HEAP"."NOTE" IS 'Description of batch';
   COMMENT ON COLUMN "BWTA_HEAP"."STAT_ROUND_SEQ" IS 'Last round the statistics has been gathered';
   COMMENT ON TABLE "BWTA_HEAP"  IS 'Batch of processes to be run';
--------------------------------------------------------
--  DDL for Table BWTA_LOG_ERR
--------------------------------------------------------
  CREATE TABLE "BWTA_LOG_ERR" 
   (	"ROUND_SEQ" NUMBER, 
	"TASK_SEQ" NUMBER, 
	"ERR_ID" NUMBER, 
	"DT" TIMESTAMP (6)
   ) 
  PARTITION BY RANGE ("ROUND_SEQ") INTERVAL (100) 
 (PARTITION "P_0"  VALUES LESS THAN (1)); 
   COMMENT ON COLUMN "BWTA_LOG_ERR"."ROUND_SEQ" IS 'Round when it happened';
   COMMENT ON COLUMN "BWTA_LOG_ERR"."TASK_SEQ" IS 'Sequence key of Task';
   COMMENT ON COLUMN "BWTA_LOG_ERR"."ERR_ID" IS 'Error ID';
   COMMENT ON COLUMN "BWTA_LOG_ERR"."DT" IS 'Timestamp when it happened';
   COMMENT ON TABLE "BWTA_LOG_ERR"  IS 'Log of all the realized failover actions';
--------------------------------------------------------
--  DDL for Table BWTA_LOG_METADATA
--------------------------------------------------------
  CREATE TABLE "BWTA_LOG_METADATA" 
   (	"SEQ" NUMBER(*,0), 
	"SEQ2" NUMBER(*,0) DEFAULT -1, 
	"DT" TIMESTAMP (6), 
	"OPERATION" CHAR(1 CHAR), 
	"OLD_VAL" "XMLTYPE", 
	"NEW_VAL" "XMLTYPE", 
	"TAG" VARCHAR2(100 CHAR), 
	"TABLE_NAME" VARCHAR2(30 CHAR)
   ) 
  PARTITION BY RANGE ("DT") INTERVAL (INTERVAL'1'MONTH) 
 (PARTITION "P_0"  VALUES LESS THAN (TIMESTAMP' 2000-01-01 00:00:00') ); 
   COMMENT ON COLUMN "BWTA_LOG_METADATA"."SEQ" IS 'Primary key of changed record';
   COMMENT ON COLUMN "BWTA_LOG_METADATA"."SEQ2" IS 'Optional extension of key of changed record';
   COMMENT ON COLUMN "BWTA_LOG_METADATA"."DT" IS 'Timestamp of realized change';
   COMMENT ON COLUMN "BWTA_LOG_METADATA"."OPERATION" IS 'Operation (I,U,D)';
   COMMENT ON COLUMN "BWTA_LOG_METADATA"."OLD_VAL" IS 'Old value of record XML element';
   COMMENT ON COLUMN "BWTA_LOG_METADATA"."NEW_VAL" IS 'New value of record XML element';
   COMMENT ON COLUMN "BWTA_LOG_METADATA"."TABLE_NAME" IS 'Table of the change';
--------------------------------------------------------
--  DDL for Table BWTA_LOG_ROUND
--------------------------------------------------------
  CREATE TABLE "BWTA_LOG_ROUND" 
   (	"SEQ" NUMBER, 
	"HEAP_SEQ" NUMBER DEFAULT -1, 
	"EFFECTIVE_DATE" DATE, 
	"START_DT" DATE, 
	"END_DT" DATE
   ) 
  PARTITION BY RANGE ("SEQ") INTERVAL (10000) 
 (PARTITION "P_0"  VALUES LESS THAN (1) );
   COMMENT ON COLUMN "BWTA_LOG_ROUND"."SEQ" IS 'Sequence key of round';
   COMMENT ON COLUMN "BWTA_LOG_ROUND"."HEAP_SEQ" IS 'Sequence key of heap';
   COMMENT ON COLUMN "BWTA_LOG_ROUND"."EFFECTIVE_DATE" IS 'Effective date of round';
   COMMENT ON COLUMN "BWTA_LOG_ROUND"."START_DT" IS 'Start date and time of round';
   COMMENT ON COLUMN "BWTA_LOG_ROUND"."END_DT" IS 'End date and time of round - indicates completed rounds' ;
   COMMENT ON TABLE "BWTA_LOG_ROUND"  IS 'Round of the batch execution';
--------------------------------------------------------
--  DDL for Table BWTA_LOG_TASK
--------------------------------------------------------
  CREATE TABLE "BWTA_LOG_TASK" 
   (	"TASK_SEQ" NUMBER, 
	"ROUND_SEQ" NUMBER, 
	"STATUS" VARCHAR2(10), 
	"START_DT" DATE, 
	"END_DT" DATE, 
	"ERROR_MSG" VARCHAR2(4000)
   ) 
  PARTITION BY RANGE ("ROUND_SEQ") INTERVAL (1) 
 (PARTITION "P_0"  VALUES LESS THAN (1) ); 
   COMMENT ON COLUMN "BWTA_LOG_TASK"."TASK_SEQ" IS 'Sequence key of process';
   COMMENT ON COLUMN "BWTA_LOG_TASK"."ROUND_SEQ" IS 'Sequence key of round';
   COMMENT ON COLUMN "BWTA_LOG_TASK"."STATUS" IS 'Status of process (ACTIVE, ERROR, DONE, SUSPEND, SKIP, WAIT)';
   COMMENT ON COLUMN "BWTA_LOG_TASK"."START_DT" IS 'Start date and time of process execution or time to wait for';
   COMMENT ON COLUMN "BWTA_LOG_TASK"."END_DT" IS 'End date and time of process execution';
   COMMENT ON COLUMN "BWTA_LOG_TASK"."ERROR_MSG" IS 'Error message for the ERROR status';
   COMMENT ON TABLE "BWTA_LOG_TASK"  IS 'Process execution log';
--------------------------------------------------------
--  DDL for Table BWTA_LOG_TASK_H
--------------------------------------------------------
  CREATE TABLE "BWTA_LOG_TASK_H" 
   (	"TASK_SEQ" NUMBER, 
	"ROUND_SEQ" NUMBER, 
	"STATUS" VARCHAR2(10), 
	"START_DT" DATE, 
	"END_DT" DATE, 
	"ERROR_MSG" VARCHAR2(4000), 
	"TS" TIMESTAMP (6)
   ) 
  PARTITION BY RANGE ("ROUND_SEQ") INTERVAL (1) 
 (PARTITION "P_0"  VALUES LESS THAN (1) ); 
   COMMENT ON COLUMN "BWTA_LOG_TASK_H"."TASK_SEQ" IS 'Sequence key of process';
   COMMENT ON COLUMN "BWTA_LOG_TASK_H"."ROUND_SEQ" IS 'Sequence key of round';
   COMMENT ON COLUMN "BWTA_LOG_TASK_H"."STATUS" IS 'Status of process (ACTIVE, ERROR, DONE, SUSPEND, SKIP, WAIT)';
   COMMENT ON COLUMN "BWTA_LOG_TASK_H"."START_DT" IS 'Start date and time of process execution or time to wait for';
   COMMENT ON COLUMN "BWTA_LOG_TASK_H"."END_DT" IS 'End date and time of process execution';
   COMMENT ON COLUMN "BWTA_LOG_TASK_H"."ERROR_MSG" IS 'Error message for the ERROR status';
   COMMENT ON COLUMN "BWTA_LOG_TASK_H"."TS" IS 'Timestamp of the change';
   COMMENT ON TABLE "BWTA_LOG_TASK_H"  IS 'Process execution log';
--------------------------------------------------------
--  DDL for Table BWTA_LOG_THREAD
--------------------------------------------------------
  CREATE TABLE "BWTA_LOG_THREAD" 
   (	"SEQ" NUMBER, 
	"ROUND_SEQ" NUMBER, 
	"STATUS" VARCHAR2(10), 
	"TASK_SEQ" NUMBER, 
	"START_DT" DATE, 
	"COMMAND" VARCHAR2(100), 
	"ERROR_MSG" VARCHAR2(2000)
   ); 
   COMMENT ON COLUMN "BWTA_LOG_THREAD"."SEQ" IS 'Sequence key of thread';
   COMMENT ON COLUMN "BWTA_LOG_THREAD"."ROUND_SEQ" IS 'Sequence key of round';
   COMMENT ON COLUMN "BWTA_LOG_THREAD"."STATUS" IS 'Status of thread (ACTIVE, INACTIVE, SLEEP)';
   COMMENT ON COLUMN "BWTA_LOG_THREAD"."TASK_SEQ" IS 'Sequence key of active task for the ACTIVE status';
   COMMENT ON COLUMN "BWTA_LOG_THREAD"."START_DT" IS 'Start date of current activity';
   COMMENT ON COLUMN "BWTA_LOG_THREAD"."COMMAND" IS 'command for thread - STOP to stop thread after current activity';
   COMMENT ON COLUMN "BWTA_LOG_THREAD"."ERROR_MSG" IS 'Error message for the ERROR status';
   COMMENT ON TABLE "BWTA_LOG_THREAD"  IS 'Thread of execution';
--------------------------------------------------------
--  DDL for Table BWTA_RES
--------------------------------------------------------
  CREATE TABLE "BWTA_RES" 
   (	"SEQ" NUMBER, 
	"ID" VARCHAR2(100), 
	"NOTE" VARCHAR2(500), 
	"AMOUNT" NUMBER DEFAULT 100, 
	"PENDING" NUMBER(1,0) DEFAULT 0
   ); 
   COMMENT ON COLUMN "BWTA_RES"."SEQ" IS 'Sequence key of resource';
   COMMENT ON COLUMN "BWTA_RES"."ID" IS 'ID of resource';
   COMMENT ON COLUMN "BWTA_RES"."NOTE" IS 'Description of resource';
   COMMENT ON COLUMN "BWTA_RES"."AMOUNT" IS 'Total amount of resource (e.g. 100 [%])';
   COMMENT ON COLUMN "BWTA_RES"."PENDING" IS '0..resource released after end of process, 1..resource should be released by negative consumption';
   COMMENT ON TABLE "BWTA_RES"  IS 'Resource definition';
--------------------------------------------------------
--  DDL for Table BWTA_TASK
--------------------------------------------------------
  CREATE TABLE "BWTA_TASK" 
   (	"SEQ" NUMBER, 
	"HEAP_SEQ" NUMBER DEFAULT -1, 
	"ID" VARCHAR2(100), 
	"NOTE" VARCHAR2(500), 
	"EXEC_COND" VARCHAR2(2000), 
	"SKIP_COND" VARCHAR2(2000), 
	"EXEC_FLAG" NUMBER(*,0), 
	"SKIP_FLAG" NUMBER(*,0), 
	"EXEC_CODE" VARCHAR2(2000), 
	"PRIORITY" NUMBER DEFAULT 50, 
	"AVG_DURATION" NUMBER, 
	"CNT_DURATION" NUMBER(*,0)
   ); 
   COMMENT ON COLUMN "BWTA_TASK"."SEQ" IS 'Sequence key of task';
   COMMENT ON COLUMN "BWTA_TASK"."HEAP_SEQ" IS 'Sequence key of heap';
   COMMENT ON COLUMN "BWTA_TASK"."ID" IS 'ID of process';
   COMMENT ON COLUMN "BWTA_TASK"."NOTE" IS 'Description of task';
   COMMENT ON COLUMN "BWTA_TASK"."EXEC_COND" IS 'Condition code of execution to block task based on external condition';
   COMMENT ON COLUMN "BWTA_TASK"."SKIP_COND" IS 'Condition code of skip to skip task based on external condition';
   COMMENT ON COLUMN "BWTA_TASK"."EXEC_FLAG" IS 'Flag of execution to block task';
   COMMENT ON COLUMN "BWTA_TASK"."SKIP_FLAG" IS 'Flag of skip to skip task';
   COMMENT ON COLUMN "BWTA_TASK"."EXEC_CODE" IS 'Execution PL/SQL code';
   COMMENT ON COLUMN "BWTA_TASK"."PRIORITY" IS 'Priority of execution (less is more important)';
   COMMENT ON COLUMN "BWTA_TASK"."AVG_DURATION" IS 'Average duration of process based on statistics';
   COMMENT ON COLUMN "BWTA_TASK"."CNT_DURATION" IS 'Count of runs involved in statistics';
   COMMENT ON TABLE "BWTA_TASK"  IS 'Process (task) to be run';
--------------------------------------------------------
--  DDL for Table BWTA_TASK_REL
--------------------------------------------------------
  CREATE TABLE "BWTA_TASK_REL" 
   (	"SEQ1" NUMBER, 
	"SEQ2" NUMBER, 
	"SKIP_FLAG" NUMBER(1,0)
   ); 
   COMMENT ON COLUMN "BWTA_TASK_REL"."SEQ1" IS 'Sequence key of dependent task';
   COMMENT ON COLUMN "BWTA_TASK_REL"."SEQ2" IS 'Sequence key of the predecessor task';
   COMMENT ON COLUMN "BWTA_TASK_REL"."SKIP_FLAG" IS 'Skip flag to disable dependency';
   COMMENT ON TABLE "BWTA_TASK_REL"  IS 'Relation between processes - predecessor specification';
--------------------------------------------------------
--  DDL for Table BWTA_TASK_RES
--------------------------------------------------------
  CREATE TABLE "BWTA_TASK_RES" 
   (	"TASK_SEQ" NUMBER, 
	"RES_SEQ" NUMBER, 
	"AMOUNT" NUMBER
   ); 
   COMMENT ON COLUMN "BWTA_TASK_RES"."TASK_SEQ" IS 'Sequence key of task';
   COMMENT ON COLUMN "BWTA_TASK_RES"."RES_SEQ" IS 'Sequence key of resource';
   COMMENT ON COLUMN "BWTA_TASK_RES"."AMOUNT" IS 'Consumption of specified resource by the process';
   COMMENT ON TABLE "BWTA_TASK_RES"  IS 'Relation between processes - predecessor specification';
--------------------------------------------------------
--  DDL for Indexes
--------------------------------------------------------
  CREATE UNIQUE INDEX "BWTA_LOG_ERR_PK" ON "BWTA_LOG_ERR" ("ROUND_SEQ", "TASK_SEQ", "ERR_ID", "DT") LOCAL;
  CREATE UNIQUE INDEX "BWTA_TASK_U1" ON "BWTA_TASK" ("ID", "HEAP_SEQ");
  CREATE UNIQUE INDEX "BWTA_RES_U1" ON "BWTA_RES" ("ID");
  CREATE UNIQUE INDEX "BWTA_LOG_ROUND_PK" ON "BWTA_LOG_ROUND" ("SEQ") LOCAL;
  CREATE UNIQUE INDEX "BWTA_HEAP_UK" ON "BWTA_HEAP" ("ID");
  CREATE UNIQUE INDEX "BWTA_TASK_RES_PK" ON "BWTA_TASK_RES" ("TASK_SEQ", "RES_SEQ");
  CREATE UNIQUE INDEX "BWTA_LOG_METADATA_PK" ON "BWTA_LOG_METADATA" ("SEQ", "SEQ2", "DT", "OPERATION") LOCAL;
  CREATE UNIQUE INDEX "BWTA_TASK_REL_PK" ON "BWTA_TASK_REL" ("SEQ1", "SEQ2");
  CREATE UNIQUE INDEX "BWTA_ERR_PK" ON "BWTA_ERR" ("ID");
  CREATE UNIQUE INDEX "BWTA_RES_PK" ON "BWTA_RES" ("SEQ");
  CREATE UNIQUE INDEX "BWTA_LOG_TASK_PK" ON "BWTA_LOG_TASK" ("TASK_SEQ", "ROUND_SEQ") LOCAL;
  CREATE UNIQUE INDEX "BWTA_LOG_THREAD_PK" ON "BWTA_LOG_THREAD" ("SEQ");
  CREATE UNIQUE INDEX "BWTA_BATCH_PK" ON "BWTA_HEAP" ("SEQ");
  CREATE UNIQUE INDEX "BWTA_TASK_PK" ON "BWTA_TASK" ("SEQ");
--------------------------------------------------------
--  Constraints for Table BWTA_LOG_METADATA
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_METADATA" ADD CONSTRAINT "BWTA_LOG_METADATA_PK" PRIMARY KEY ("SEQ", "SEQ2", "DT", "OPERATION") ENABLE;
  ALTER TABLE "BWTA_LOG_METADATA" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "BWTA_LOG_METADATA" MODIFY ("SEQ2" NOT NULL ENABLE);
  ALTER TABLE "BWTA_LOG_METADATA" MODIFY ("DT" NOT NULL ENABLE);
  ALTER TABLE "BWTA_LOG_METADATA" MODIFY ("OPERATION" NOT NULL ENABLE);
  ALTER TABLE "BWTA_LOG_METADATA" MODIFY ("TABLE_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BWTA_LOG_ROUND
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_ROUND" ADD CONSTRAINT "BWTA_LOG_ROUND_PK" PRIMARY KEY ("SEQ") ENABLE;
  ALTER TABLE "BWTA_LOG_ROUND" MODIFY ("HEAP_SEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BWTA_HEAP
--------------------------------------------------------
  ALTER TABLE "BWTA_HEAP" ADD CONSTRAINT "BWTA_HEAP_PK" PRIMARY KEY ("SEQ") ENABLE;
  ALTER TABLE "BWTA_HEAP" ADD CONSTRAINT "BWTA_HEAP_UK" UNIQUE ("ID") ENABLE;
  ALTER TABLE "BWTA_HEAP" MODIFY ("STAT_ROUND_SEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BWTA_TASK_RES
--------------------------------------------------------
  ALTER TABLE "BWTA_TASK_RES" ADD CONSTRAINT "BWTA_TASK_RES_PK" PRIMARY KEY ("TASK_SEQ", "RES_SEQ") ENABLE;
--------------------------------------------------------
--  Constraints for Table BWTA_LOG_THREAD
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_THREAD" ADD CONSTRAINT "BWTA_LOG_THREAD_PK" PRIMARY KEY ("SEQ") ENABLE;
--------------------------------------------------------
--  Constraints for Table BWTA_ERR
--------------------------------------------------------
  ALTER TABLE "BWTA_ERR" ADD CONSTRAINT "BWTA_ERR_PK" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table BWTA_LOG_ERR
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_ERR" ADD CONSTRAINT "BWTA_LOG_ERR_PK" PRIMARY KEY ("ROUND_SEQ", "TASK_SEQ", "ERR_ID", "DT") ENABLE;
  ALTER TABLE "BWTA_LOG_ERR" MODIFY ("DT" NOT NULL ENABLE);
  ALTER TABLE "BWTA_LOG_ERR" MODIFY ("ROUND_SEQ" NOT NULL ENABLE);
  ALTER TABLE "BWTA_LOG_ERR" MODIFY ("TASK_SEQ" NOT NULL ENABLE);
  ALTER TABLE "BWTA_LOG_ERR" MODIFY ("ERR_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BWTA_TASK
--------------------------------------------------------
  ALTER TABLE "BWTA_TASK" ADD CONSTRAINT "BWTA_TASK_PK" PRIMARY KEY ("SEQ") ENABLE;
  ALTER TABLE "BWTA_TASK" ADD CONSTRAINT "BWTA_TASK_U1" UNIQUE ("ID", "HEAP_SEQ") ENABLE;
  ALTER TABLE "BWTA_TASK" MODIFY ("HEAP_SEQ" NOT NULL ENABLE);
  ALTER TABLE "BWTA_TASK" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BWTA_TASK" MODIFY ("PRIORITY" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BWTA_RES
--------------------------------------------------------
  ALTER TABLE "BWTA_RES" ADD CONSTRAINT "BWTA_RES_PK" PRIMARY KEY ("SEQ") ENABLE;
  ALTER TABLE "BWTA_RES" ADD CONSTRAINT "BWTA_RES_U1" UNIQUE ("ID") ENABLE;
  ALTER TABLE "BWTA_RES" MODIFY ("AMOUNT" NOT NULL ENABLE);
  ALTER TABLE "BWTA_RES" MODIFY ("PENDING" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BWTA_LOG_TASK
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_TASK" ADD CONSTRAINT "BWTA_LOG_TASK_PK" PRIMARY KEY ("TASK_SEQ", "ROUND_SEQ") ENABLE;
--------------------------------------------------------
--  Constraints for Table BWTA_TASK_REL
--------------------------------------------------------
  ALTER TABLE "BWTA_TASK_REL" ADD CONSTRAINT "BWTA_TASK_REL_PK" PRIMARY KEY ("SEQ1", "SEQ2") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BWTA_LOG_ERR
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_ERR" ADD CONSTRAINT "BWTA_LOG_ERR_FK" FOREIGN KEY ("ROUND_SEQ")
	  REFERENCES "BWTA_LOG_ROUND" ("SEQ") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BWTA_LOG_ROUND
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_ROUND" ADD CONSTRAINT "BWTA_LOG_ROUND_FK" FOREIGN KEY ("HEAP_SEQ")
	  REFERENCES "BWTA_HEAP" ("SEQ") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BWTA_LOG_TASK
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_TASK" ADD CONSTRAINT "BWTA_LOG_TASK_FK" FOREIGN KEY ("ROUND_SEQ")
	  REFERENCES "BWTA_LOG_ROUND" ("SEQ") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BWTA_LOG_THREAD
--------------------------------------------------------
  ALTER TABLE "BWTA_LOG_THREAD" ADD CONSTRAINT "BWTALOG_THREAD_FK2" FOREIGN KEY ("TASK_SEQ")
	  REFERENCES "BWTA_TASK" ("SEQ") ENABLE;
  ALTER TABLE "BWTA_LOG_THREAD" ADD CONSTRAINT "BWTA_LOG_THREAD_FK1" FOREIGN KEY ("ROUND_SEQ")
	  REFERENCES "BWTA_LOG_ROUND" ("SEQ") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BWTA_TASK
--------------------------------------------------------
  ALTER TABLE "BWTA_TASK" ADD CONSTRAINT "BWTA_PROC_FK" FOREIGN KEY ("HEAP_SEQ")
	  REFERENCES "BWTA_HEAP" ("SEQ") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BWTA_TASK_REL
--------------------------------------------------------
  ALTER TABLE "BWTA_TASK_REL" ADD CONSTRAINT "BWTA_PROC_REL_FK1" FOREIGN KEY ("SEQ1")
	  REFERENCES "BWTA_TASK" ("SEQ") ON DELETE CASCADE ENABLE;
  ALTER TABLE "BWTA_TASK_REL" ADD CONSTRAINT "BWTA_PROC_REL_FK2" FOREIGN KEY ("SEQ2")
	  REFERENCES "BWTA_TASK" ("SEQ") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BWTA_TASK_RES
--------------------------------------------------------
  ALTER TABLE "BWTA_TASK_RES" ADD CONSTRAINT "BWTA_PROC_RES_FK1" FOREIGN KEY ("TASK_SEQ")
	  REFERENCES "BWTA_TASK" ("SEQ") ON DELETE CASCADE ENABLE;
  ALTER TABLE "BWTA_TASK_RES" ADD CONSTRAINT "BWTA_PROC_RES_FK2" FOREIGN KEY ("RES_SEQ")
	  REFERENCES "BWTA_RES" ("SEQ") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  DDL for Trigger BWTA_HEAP_TRG
--------------------------------------------------------
  CREATE OR REPLACE TRIGGER "BWTA_HEAP_TRG" before insert or update on BWTA_HEAP
  for each row 
begin
  IF (:NEW.seq IS NULL) THEN 
    Select BWTA_HEAP_SEQ.nextval into :new.seq from dual;
  end if;
end;
/
ALTER TRIGGER "BWTA_HEAP_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger BWTA_LOG_ROUND_TRG
--------------------------------------------------------
  CREATE OR REPLACE TRIGGER "BWTA_LOG_ROUND_TRG" before insert or update on BWTA_LOG_ROUND
  for each row 
begin
  if (:new.seq is null) then 
    Select BWTA_LOG_ROUND_SEQ.nextval into :new.seq from dual;
  end if;
end;
/
ALTER TRIGGER "BWTA_LOG_ROUND_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger BWTA_LOG_TASK_TRG
--------------------------------------------------------
  CREATE OR REPLACE TRIGGER "BWTA_LOG_TASK_TRG" before update or delete on BWTA_LOG_TASK
  for each row 
begin
    INSERT INTO BWTA_LOG_TASK_H(task_seq,round_seq,status,start_dt,end_dt,error_msg,ts)        
    values(:old.task_seq,:old.round_seq,:old.status,:old.start_dt,:old.end_dt,:old.error_msg,systimestamp);
end;
/
ALTER TRIGGER "BWTA_LOG_TASK_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger BWTA_LOG_THREAD_TRG
--------------------------------------------------------
  CREATE OR REPLACE TRIGGER "BWTA_LOG_THREAD_TRG" before insert on BWTA_LOG_THREAD 
  for each row  
begin 
  if (:new.seq is null) then  
    Select BWTA_LOG_THREAD_SEQ.nextval into :new.seq from dual; 
  end if; 
end; 
/
ALTER TRIGGER "BWTA_LOG_THREAD_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger BWTA_RES_TRG
--------------------------------------------------------
  CREATE OR REPLACE TRIGGER "BWTA_RES_TRG" before insert or update on BWTA_RES
  for each row 
begin
  if (:new.seq is null) then 
    Select BWTA_RES_SEQ.nextval into :new.seq from dual;
  end if;
end;
/
ALTER TRIGGER "BWTA_RES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger BWTA_TASK_TRG
--------------------------------------------------------
  CREATE OR REPLACE TRIGGER "BWTA_TASK_TRG" before insert or update on BWTA_TASK
  for each row 
begin
  IF (:NEW.seq IS NULL) THEN 
    Select BWTA_TASK_SEQ.nextval into :new.seq from dual;
  end if;
end;
/
ALTER TRIGGER "BWTA_TASK_TRG" ENABLE;
--------------------------------------------------------
--  DML for BWTA_HEAP default
--------------------------------------------------------
Insert into BWTA_HEAP (SEQ,ID,NOTE,STAT_ROUND_SEQ) values ('-1','DEFAULT','Default batch process','-1');
--------------------------------------------------------
--  DML for BWTA_ERR data
--------------------------------------------------------
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-600,2,0.000694444444444444444444444444444444444445,0,1);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-3113,3,0.000694444444444444444444444444444444444445,1,1);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-1651,5,0.00694444444444444444444444444444444444445,1,3);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-1652,5,0.00694444444444444444444444444444444444445,1,3);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-30036,5,0.00694444444444444444444444444444444444445,1,3);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-54,2,0.0104166666666666666666666666666666666667,1,1);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-1555,2,0.0104166666666666666666666666666666666667,2,1);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-8103,2,0.003472222222222222222222222222222222222225,0,1);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-4061,2,0.003472222222222222222222222222222222222225,0,1);
Insert into BWTA_ERR (ID,ATMPT_CNT,DELAY_DAY,PROLONG_KOEF,DIVERS_MOD) values (-10632,2,0.003472222222222222222222222222222222222225,0,1);
--------------------------------------------------------
