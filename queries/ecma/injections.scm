; extends
(template_string (string_fragment) @injection.content
  (#match? @injection.content "([sS][eE][lL][eE][cC][tT].*[fF][rR][oO][mM]|[dD][eE][lL][eE][tT][eE].*[fF][rR][oO][mM]|[iI][nN][sS][eE][rR][tT].*[iI][nN][tT][oO]|[uU][pP][dD][aA][tT][eE].*([sS][eE][tT]|[fF][rR][oO][mM]))")
  (#set! injection.language "sql"))
