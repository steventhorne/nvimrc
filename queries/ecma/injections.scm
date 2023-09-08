; extends
(((template_string) @_template_string
  (#match? @_template_string "([sS][eE][lL][eE][cC][tT].*[fF][rR][oO][mM]|[dD][eE][lL][eE][tT][eE].*[fF][rR][oO][mM]|[iI][nN][sS][eE][rR][tT].*[iI][nN][tT][oO]|[uU][pP][dD][aA][tT][eE].*([sS][eE][tT]|[fF][rR][oO][mM]))")) @sql
 (#offset! @sql 0 1 0 -1))
