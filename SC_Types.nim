
type
  SCErr* = cint
#  int64* = int64_t
#  uint64* = uint64_t
#  int32* = int32_t
#  uint32* = uint32_t
#  int16* = int16_t
#  uint16* = uint16_t
#  int8* = int8_t
#  uint8* = uint8_t
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
