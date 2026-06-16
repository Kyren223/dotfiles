; extends
([(identifier) (type_identifier) (true) (false)] @keyword
  (#any-of? @keyword
   "kr_proc" "inlined"
   "lt_proc" "lt_inline" "lt_global" "lt_packed" "lt_noreturn"
   "u8" "u16" "u32" "u64"
   "i8" "i16" "i32" "i64" "i128"
   "f32" "f64"
   "b8" "b16" "b32" "b64"
   "rune" "usize" "isize" "uptr" "iptr"
   "true" "false" "null" "void")
  (#set! "priority" 200))
