

template sc_abs*(a: untyped): untyped =
  abs(a)

template sc_max*(a, b: untyped): untyped =
  (if ((a) > (b)): (a) else: (b))

template sc_min*(a, b: untyped): untyped =
  (if ((a) < (b)): (a) else: (b))

proc sc_clip*[T; U; V](x: T; lo: U; hi: V): T {.inline.} =
  return max(min(x, cast[T](hi)), cast[T](lo))
