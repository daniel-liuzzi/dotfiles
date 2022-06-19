; Switch current session to another schema
:R0:oschema::
(
+{Home}alter session set current_schema = ;{Left}
)

; Query tables
:R0:otbls::
(
+{Home}select table_name
+{Home}from user_tables
+{Home}where table_name like upper('%%')
+{Home}order by table_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query tables (all users)
:R0:otblsa::
(
+{Home}select owner, table_name
+{Home}from all_tables
+{Home}where owner like upper('%%') and table_name like upper('%%')
+{Home}order by owner, table_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query views
:R0:oviews::
(
+{Home}select view_name
+{Home}from user_views
+{Home}where view_name like upper('%%')
+{Home}order by view_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query views (all users)
:R0:oviewsa::
(
+{Home}select owner, view_name
+{Home}from all_views
+{Home}where owner like upper('%%') and view_name like upper('%%')
+{Home}order by owner, view_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query table columns
:R0:ocols::
(
+{Home}select
+{Home}    table_name,
+{Home}    column_name,
+{Home}    data_type,
+{Home}    case
+{Home}        when data_type in ('NUMBER') then
+{Home}            case
+{Home}                when data_precision is not null and data_scale is not null then
+{Home}                    '(' || data_precision || ',' || data_scale || ')'
+{Home}                when data_precision is not null then
+{Home}                    '(' || data_precision || ')'
+{Home}            end
+{Home}        when data_type in ('CHAR', 'VARCHAR2') then
+{Home}            '(' || char_length || case char_used when 'C' then ' CHAR' end || ')'
+{Home}        when data_type in ('NCHAR', 'NVARCHAR2') then
+{Home}            '(' || char_length || ')'
+{Home}        when data_type in ('RAW', 'UROWID') then
+{Home}            '(' || data_length || ')'
+{Home}    end data_size,
+{Home}    case nullable when 'N' then ' NOT NULL' end data_null
+{Home}from user_tab_columns
+{Home}where
+{Home}    table_name in (select table_name from user_tables) and
+{Home}    table_name like upper('%%') and
+{Home}    column_name like upper('%%')
+{Home}order by table_name, column_id;
+{Home}{Up 2}{End}{Left 3}
)

; Query table columns (all users)
:R0:ocolsa::
(
+{Home}select owner, table_name, column_id, column_name, data_type, data_length, data_precision, data_scale, nullable
+{Home}from all_tab_columns
+{Home}where
+{Home}    owner like upper('%%') and
+{Home}    table_name in (select table_name from all_tables) and
+{Home}    table_name like upper('%%') and
+{Home}    column_name like upper('%%')
+{Home}order by owner, table_name, column_id;
+{Home}{Up 2}{End}{Left 3}
)

; Query users
:R0:ousers::
(
+{Home}select *
+{Home}from user_users
+{Home}where username like upper('%%')
+{Home}order by username;
+{Home}{Up 2}{End}{Left 3}
)

; Query users (all users)
:R0:ousersa::
(
+{Home}select *
+{Home}from all_users
+{Home}where username like upper('%%')
+{Home}order by username;
+{Home}{Up 2}{End}{Left 3}
)

; Get DDL
:R0:oddl::
(
+{Home}select object_type, object_name, dbms_metadata.get_ddl(object_type, object_name, owner) ddl
+{Home}from all_objects
+{Home}where
+{Home}    owner = sys_context('userenv', 'current_schema') and
+{Home}    object_type not in ('JOB', 'LOB', 'TABLE PARTITION') and
+{Home}    object_name like upper('%%')
+{Home}order by object_type, object_name;
+{Home}{Up 2}{End}{Left 2}+{Left 2}
)
