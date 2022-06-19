:R0:sel::
(
+{Home}select *
+{Home}from
+{Home}order by 1 desc;
+{Home}{Up 2}{End}{Space}^{Space}
)

:R0:sel100::
(
+{Home}select *
+{Home}from
+{Home}order by 1 desc
+{Home}offset 0 rows
+{Home}fetch next 100 rows only;
+{Home}{Up 4}{End}{Space}^{Space}
)

:R0:merge::
(
+{Home}merge into target t
+{Home}using source s on (t.id = s.id)
+{Home}when matched then
+{Home}    update set
+{Home}        col1 = s.col1,
+{Home}        col2 = s.col2
+{Home}when not matched then
+{Home}    insert (col1, col2)
+{Home}    values (s.col1, s.col2);
+{Home}{Delete}{Up 9}{End}{Left 2}+^{Left}
)
