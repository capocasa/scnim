

type
  SCErr* = cint
  float32* = cfloat
  float64* = cdouble
  elem32* {.bycopy.} = object {.union.}
    u*: uint32
    i*: int32
    f*: float32

  elem64* {.bycopy.} = object {.union.}
    u*: uint64
    i*: int64
    f*: float64


var kSCNameLen*: cuint = 8

var kSCNameByteLen*: cuint = 8 * sizeof((int32))

template sc_typeof_cast*(x: untyped): untyped =
  x
