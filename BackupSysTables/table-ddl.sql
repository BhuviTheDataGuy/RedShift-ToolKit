--DROP TABLE systable.dba_stl_alert_event_log;
CREATE TABLE IF NOT EXISTS systable.dba_stl_alert_event_log
(
	userid INTEGER   ENCODE az64
	,query INTEGER   ENCODE az64
	,slice INTEGER   ENCODE az64
	,segment INTEGER   ENCODE az64
	,step INTEGER   ENCODE az64
	,pid INTEGER   ENCODE az64
	,xid BIGINT   ENCODE az64
	,event CHAR(1024)   ENCODE lzo
	,solution CHAR(200)   ENCODE lzo
	,event_time TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
);

--DROP TABLE systable.dba_stl_ddltext;
CREATE TABLE IF NOT EXISTS systable.dba_stl_ddltext
(
	userid INTEGER   ENCODE az64
	,xid BIGINT   ENCODE az64
	,pid INTEGER   ENCODE az64
	,"label" CHAR(320)   ENCODE lzo
	,starttime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,endtime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,"sequence" INTEGER   ENCODE az64
	,text VARCHAR(65000)   ENCODE lzo
);

--DROP TABLE systable.dba_stl_explain;
CREATE TABLE IF NOT EXISTS systable.dba_stl_explain
(
	serid INTEGER   ENCODE az64
	query INTEGER   ENCODE az64
	nodeid INTEGER   ENCODE az64
	parentid INTEGER   ENCODE az64
	plannode VARCHAR(65000)   ENCODE lzo
	info VARCHAR(65000)   ENCODE lzo
);

--DROP TABLE systable.dba_stl_query;
CREATE TABLE IF NOT EXISTS systable.dba_stl_query
(
	userid INTEGER   ENCODE az64
	,query INTEGER   ENCODE az64
	,"label" CHAR(320)   ENCODE lzo
	,xid BIGINT   ENCODE az64
	,pid INTEGER   ENCODE az64
	,"database" CHAR(32)   ENCODE lzo
	,querytxt VARCHAR(65000)   ENCODE lzo
	,starttime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,endtime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,aborted INTEGER   ENCODE az64
	,insert_pristine INTEGER   ENCODE az64
	,concurrency_scaling_status INTEGER   ENCODE az64
);

--DROP TABLE systable.dba_stl_query_metrics;
CREATE TABLE IF NOT EXISTS systable.dba_stl_query_metrics
(
	userid INTEGER   ENCODE az64
	,service_class INTEGER   ENCODE az64
	,query INTEGER   ENCODE az64
	,segment INTEGER   ENCODE az64
	,step_type INTEGER   ENCODE az64
	,starttime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,slices INTEGER   ENCODE az64
	,max_rows BIGINT   ENCODE az64
	,"rows" BIGINT   ENCODE az64
	,max_cpu_time BIGINT   ENCODE az64
	,cpu_time BIGINT   ENCODE az64
	,max_blocks_read INTEGER   ENCODE az64
	,blocks_read BIGINT   ENCODE az64
	,max_run_time BIGINT   ENCODE az64
	,run_time BIGINT   ENCODE az64
	,max_blocks_to_disk BIGINT   ENCODE az64
	,blocks_to_disk BIGINT   ENCODE az64
	,step INTEGER   ENCODE az64
	,max_query_scan_size BIGINT   ENCODE az64
	,query_scan_size BIGINT   ENCODE az64
	,query_priority INTEGER   ENCODE az64
	,query_queue_time BIGINT   ENCODE az64
	,service_class_name CHAR(64)   ENCODE lzo
);

--DROP TABLE systable.dba_stl_querytext;
CREATE TABLE IF NOT EXISTS systable.dba_stl_querytext
(
	userid INTEGER   ENCODE az64
	,xid BIGINT   ENCODE az64
	,pid INTEGER   ENCODE az64
	,query INTEGER   ENCODE az64
	,"sequence" INTEGER   ENCODE az64
	,text VARCHAR(65000)   ENCODE lzo
);

--DROP TABLE systable.dba_stl_utilitytext;
CREATE TABLE IF NOT EXISTS systable.dba_stl_utilitytext
(
	userid INTEGER   ENCODE az64
	,xid BIGINT   ENCODE az64
	,pid INTEGER   ENCODE az64
	,"label" CHAR(320)   ENCODE lzo
	,starttime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,endtime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,"sequence" INTEGER   ENCODE az64
	,text VARCHAR(65000)   ENCODE lzo
);

--DROP TABLE systable.dba_stl_vacuum;
CREATE TABLE IF NOT EXISTS systable.dba_stl_vacuum
(
	userid INTEGER   ENCODE az64
	,xid BIGINT   ENCODE az64
	,table_id INTEGER   ENCODE az64
	,status CHAR(30)   ENCODE lzo
	,"rows" BIGINT   ENCODE az64
	,sortedrows BIGINT   ENCODE az64
	,"blocks" INTEGER   ENCODE az64
	,max_merge_partitions INTEGER   ENCODE az64
	,eventtime TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
);

--DROP TABLE systable.dba_stl_wlm_query;
CREATE TABLE IF NOT EXISTS systable.dba_stl_wlm_query
(
	userid INTEGER   ENCODE az64
	,xid BIGINT   ENCODE az64
	,task INTEGER   ENCODE az64
	,query INTEGER   ENCODE az64
	,service_class INTEGER   ENCODE az64
	,slot_count INTEGER   ENCODE az64
	,service_class_start_time TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,queue_start_time TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,queue_end_time TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,total_queue_time BIGINT   ENCODE az64
	,exec_start_time TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,exec_end_time TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,total_exec_time BIGINT   ENCODE az64
	,service_class_end_time TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,final_state CHAR(16)   ENCODE lzo
	,est_peak_mem BIGINT   ENCODE az64
	,query_priority CHAR(20)   ENCODE lzo
	,service_class_name CHAR(64)   ENCODE lzo
);

--DROP TABLE systable.dba_svl_query_summary;
CREATE TABLE IF NOT EXISTS systable.dba_svl_query_summary
(
	userid INTEGER   ENCODE az64
	,query INTEGER   ENCODE az64
	,stm INTEGER   ENCODE az64
	,seg INTEGER   ENCODE az64
	,step INTEGER   ENCODE az64
	,maxtime BIGINT   ENCODE az64
	,avgtime BIGINT   ENCODE az64
	,"rows" BIGINT   ENCODE az64
	,bytes BIGINT   ENCODE az64
	,rate_row DOUBLE PRECISION   ENCODE RAW
	,rate_byte DOUBLE PRECISION   ENCODE RAW
	,"label" VARCHAR(164)   ENCODE lzo
	,is_diskbased CHAR(1)   ENCODE lzo
	,workmem BIGINT   ENCODE az64
	,is_rrscan CHAR(1)   ENCODE lzo
	,is_delayed_scan CHAR(1)   ENCODE lzo
	,rows_pre_filter BIGINT   ENCODE az64
);

--DROP TABLE systable.dba_svv_table_info;
CREATE TABLE IF NOT EXISTS systable.dba_svv_table_info
(
	date DATE   ENCODE az64
	,"database" VARCHAR(200)   ENCODE lzo
	,"schema" VARCHAR(200)   ENCODE lzo
	,table_id INTEGER   ENCODE az64
	,"table" VARCHAR(200)   ENCODE lzo
	,encoded VARCHAR(200)   ENCODE lzo
	,"diststyle" VARCHAR(200)   ENCODE lzo
	,sortkey1 VARCHAR(200)   ENCODE lzo
	,max_varchar INTEGER   ENCODE az64
	,sortkey1_enc VARCHAR(200)   ENCODE lzo
	,sortkey_num INTEGER   ENCODE az64
	,size BIGINT   ENCODE az64
	,pct_used NUMERIC(18,0)   ENCODE az64
	,empty BIGINT   ENCODE az64
	,unsorted NUMERIC(18,0)   ENCODE az64
	,stats_off NUMERIC(18,0)   ENCODE az64
	,tbl_rows NUMERIC(18,0)   ENCODE az64
	,skew_sortkey1 NUMERIC(18,0)   ENCODE az64
	,skew_rows NUMERIC(18,0)   ENCODE az64
	,estimated_visible_rows NUMERIC(18,0)   ENCODE az64
	,risk_event VARCHAR(200)   ENCODE lzo
	,vacuum_sort_benefit NUMERIC(18,0)   ENCODE az64
)
;