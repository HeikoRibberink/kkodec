import std/num/int64

import hlib/ds/bytesb
import hlib/ext/int64

fun main()
  // This examples shows that `string.bytes` is not a one-to-one
  // transformation, which may cause problems when one uses invalid strings.
  // See `string.h` in kklib/ for more info.
  val a = bytesb/empty().append(0xF3.int64).bytes.string
  val b = a.bytes
  val c = b.string
  a.trace-show
  c.trace-show
  a == c
