; extends
((raw_string_literal) @injection.content
  (#match? @injection.content "([sS][eE][lL][eE][cC][tT].*[fF][rR][oO][mM]|[dD][eE][lL][eE][tT][eE].*[fF][rR][oO][mM]|[iI][nN][sS][eE][rR][tT].*[iI][nN][tT][oO]|[uU][pP][dD][aA][tT][eE].*([sS][eE][tT]|[fF][rR][oO][mM]))")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))
