; Digraph
:R0:digraph::
(
+{Home}digraph {{}+{End}
+{Home}    layout="circo"; {#} dot, neato, fdp, twopi, circo+{End}
+{Home}    edge [color="{#}999999"];+{End}
+{Home}    node [style="filled"; color="{#}333333"; fontcolor="{#}ffffff"];+{End}

+{Home}    "Observation" -> "Question";+{End}
+{Home}    "Question" -> "Hypothesis";+{End}
+{Home}    "Hypothesis" -> "Experiment";+{End}
+{Home}    "Experiment" -> "Analyze";+{End}
+{Home}    "Analyze" -> "Conclusion";+{End}
+{Home}    "Conclusion" -> "Observation";+{End}
+{Home}{}}+{End}
)

; Graph
:R0:graph::
(
+{Home}graph {{}+{End}
+{Home}    layout="circo"; {#} dot, neato, fdp, twopi, circo+{End}
+{Home}    edge [color="{#}999999"];+{End}
+{Home}    node [style="filled"; color="{#}333333"; fontcolor="{#}ffffff"];+{End}

+{Home}    "Observation" -- "Question";+{End}
+{Home}    "Question" -- "Hypothesis";+{End}
+{Home}    "Hypothesis" -- "Experiment";+{End}
+{Home}    "Experiment" -- "Analyze";+{End}
+{Home}    "Analyze" -- "Conclusion";+{End}
+{Home}    "Conclusion" -- "Observation";+{End}
+{Home}{}}+{End}
)
