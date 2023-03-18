:R0:funcs::
(
+{Home}select *
+{Home}from information_schema.routines
+{Home}where
+{Home}    routine_catalog like '%%' and
+{Home}    routine_schema like '%%' and
+{Home}    routine_name like '%%' and
+{Home}    routine_type = 'function'
+{Home}order by routine_catalog, routine_schema, routine_name;
+{Home}{Up 3}{End}{Left 6}
)

:R0:procs::
(
+{Home}select *
+{Home}from information_schema.routines
+{Home}where
+{Home}    routine_catalog like '%%' and
+{Home}    routine_schema like '%%' and
+{Home}    routine_name like '%%' and
+{Home}    routine_type = 'procedure'
+{Home}order by routine_catalog, routine_schema, routine_name;
+{Home}{Up 3}{End}{Left 6}
)

:R0:tbls::
(
+{Home}select *
+{Home}from information_schema.tables
+{Home}where
+{Home}    table_catalog like '%%' and
+{Home}    table_schema like '%%' and
+{Home}    table_name like '%%' and
+{Home}    table_type = 'base table'
+{Home}order by table_catalog, table_schema, table_name;
+{Home}{Up 3}{End}{Left 6}
)

:R0:views::
(
+{Home}select *
+{Home}from information_schema.tables
+{Home}where
+{Home}    table_catalog like '%%' and
+{Home}    table_schema like '%%' and
+{Home}    table_name like '%%' and
+{Home}    table_type = 'view'
+{Home}order by table_catalog, table_schema, table_name;
+{Home}{Up 3}{End}{Left 6}
)

:R0:cols::
(
+{Home}select *
+{Home}from information_schema.columns c
+{Home}inner join information_schema.tables t on
+{Home}    t.table_catalog = c.table_catalog and
+{Home}    t.table_schema = c.table_schema and
+{Home}    t.table_name = c.table_name
+{Home}where
+{Home}    t.table_type = 'base table' and
+{Home}    c.table_catalog like '%%' and
+{Home}    c.table_schema like '%%' and
+{Home}    c.table_name like '%%' and
+{Home}    c.column_name like '%%'
+{Home}order by c.table_catalog, c.table_schema, c.table_name, c.ordinal_position;
+{Home}{Up 3}{End}{Left 6}
)
