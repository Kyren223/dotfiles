; extends
([(identifier) (type_identifier) (true) (false)] @keyword
  (#any-of? @keyword "fn" 
   "u8" "u16" "u32" "u64"
   "i8" "i16" "i32" "i64"
   "f32" "f64"
   "b8" "b32" "b64"
   "rune" "usize" "isize"
   "true" "false" "null" "void")
  (#set! "priority" 200))
