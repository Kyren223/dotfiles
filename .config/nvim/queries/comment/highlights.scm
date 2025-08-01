((tag
  (name) @comment.todo @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.todo "TODO" "WIP"))

("text" @comment.todo @nospell
  (#any-of? @comment.todo "TODO" "WIP"))

((tag
  (name) @comment.note @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.note "NOTE" "INFO" "DOCS" "TEST"))

("text" @comment.note @nospell
  (#any-of? @comment.note "NOTE" "INFO" "DOCS" "TEST"))

((tag
  (name) @comment.perf @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.perf "PERF" "OPTIMIZE"))

("text" @comment.perf @nospell
  (#any-of? @comment.perf "PERF" "OPTIMIZE"))

((tag
  (name) @comment.warning @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.warning "HACK" "WARNING" "WARN" "SECURITY" "SECURE"))

("text" @comment.warning @nospell
  (#any-of? @comment.warning "HACK" "WARNING" "WARN" "SECURITY" "SECURE"))

((tag
  (name) @comment.error @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.error "FIXME" "FIX" "BUG" "ERROR" "UNSAFE" "SAFETY"))

("text" @comment.error @nospell
  (#any-of? @comment.error "FIXME" "FIX" "BUG" "ERROR" "UNSAFE" "SAFETY"))

; Issue number (#123)
("text" @number
  (#lua-match? @number "^#[0-9]+$"))

(uri) @string.special.url @nospell
