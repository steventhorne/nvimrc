; Comments
(comment) @comment

; Functions
(command_identifier) @function

; Parameters
(command
  (block
    (string) @parameter))
(command
  (word) @parameter)

; Variables
; () @variable
variable_declaration: (command
  name: (word) @variable)
(variable_reference) @variable

; Punctuation
"$" @punctuation
"#" @punctuation
