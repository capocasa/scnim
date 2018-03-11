

import
  Endian, Types, BoundsMacros, Hash

type
  RGen* {.bycopy.} = object
    s1*: uint32
    s2*: uint32
    s3*: uint32


#[

proc init*(this: var RGen; seed: uint32)
proc trand*(this: var RGen): uint32
proc irand*(this: var RGen; scale: int32): int32
proc irand2*(this: var RGen; scale: int32): int32
proc ilinrand*(this: var RGen; scale: int32): int32
proc ibilinrand*(this: var RGen; scale: int32): int32
proc fcoin*(this: var RGen): cfloat
proc frand*(this: var RGen): cfloat
proc frand2*(this: var RGen): cfloat
proc frand0*(this: var RGen): cfloat
proc frand8*(this: var RGen): cfloat
proc flinrand*(this: var RGen): cfloat
proc fbilinrand*(this: var RGen): cfloat
proc fsum3rand*(this: var RGen): cfloat
proc drand*(this: var RGen): cdouble
proc drand2*(this: var RGen; scale: cdouble): cdouble
proc linrand*(this: var RGen; scale: cdouble): cdouble
proc bilinrand*(this: var RGen; scale: cdouble): cdouble
proc exprandrng*(this: var RGen; lo: cdouble; hi: cdouble): cdouble
proc exprand*(this: var RGen; scale: cdouble): cdouble
proc biexprand*(this: var RGen; scale: cdouble): cdouble
proc sum3rand*(this: var RGen; scale: cdouble): cdouble

proc init*(this: var RGen; seed: uint32) {.inline.} =
  seed = cast[uint32](Hash(cast[cint](seed)))
  s1 = 1243598713 xor seed
  if s1 < 2: s1 = 1243598713
  s2 = 3093459404'i64 xor seed
  if s2 < 8: s2 = 3093459404'i64
  s3 = 1821928721 xor seed
  if s3 < 16: s3 = 1821928721

proc trand*(s1: var uint32; s2: var uint32; s3: var uint32): uint32 {.inline.} =


  s1 = ((s1 and (uint32) - 2) shl 12) xor (((s1 shl 13) xor s1) shr 19)
  s2 = ((s2 and (uint32) - 8) shl 4) xor (((s2 shl 2) xor s2) shr 25)
  s3 = ((s3 and (uint32) - 16) shl 17) xor (((s3 shl 3) xor s3) shr 11)
  return s1 xor s2 xor s3

proc trand*(this: var RGen): uint32 {.inline.} =


  s1 = ((s1 and (uint32) - 2) shl 12) xor (((s1 shl 13) xor s1) shr 19)
  s2 = ((s2 and (uint32) - 8) shl 4) xor (((s2 shl 2) xor s2) shr 25)
  s3 = ((s3 and (uint32) - 16) shl 17) xor (((s3 shl 3) xor s3) shr 11)
  return s1 xor s2 xor s3

proc drand*(this: var RGen): cdouble {.inline.} =
  when BYTE_ORDER == BIG_ENDIAN:
    type
      INNER_C_STRUCT_1115050212 {.bycopy.} = object
        hi: uint32
        lo: uint32

    var du: tuple[i: INNER_C_STRUCT_1115050212, f: cdouble]
  else:
    type
      INNER_C_STRUCT_2676224610 {.bycopy.} = object
        lo: uint32
        hi: uint32

    var du: tuple[i: INNER_C_STRUCT_2676224610, f: cdouble]

  du.i.hi = 0x41300000
  du.i.lo = trand()
  return du.f - 1048576.0

proc frand*(this: var RGen): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3F800000 or (trand() shr 9)
  return u.f - 1.0

proc frand0*(this: var RGen): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3F800000 or (trand() shr 9)
  return u.f

proc frand2*(this: var RGen): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x40000000 or (trand() shr 9)
  return u.f - 3.0

proc frand8*(this: var RGen): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3E800000 or (trand() shr 9)
  return u.f - 0.375

proc fcoin*(this: var RGen): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3F800000 or (0x80000000 and trand())
  return u.f

proc flinrand*(this: var RGen): cfloat {.inline.} =
  var a: cfloat = frand()
  var b: cfloat = frand()
  return sc_min(a, b)

proc fbilinrand*(this: var RGen): cfloat {.inline.} =
  var a: cfloat = frand()
  var b: cfloat = frand()
  return a - b

proc fsum3rand*(this: var RGen): cfloat {.inline.} =
  return (frand() + frand() + frand() - 1.5) * 0.666666667

proc irand*(this: var RGen; scale: int32): int32 {.inline.} =
  return cast[int32](floor(scale * drand()))

proc irand2*(this: var RGen; scale: int32): int32 {.inline.} =
  return cast[int32](floor((2.0 * scale + 1.0) * drand() - scale))

proc ilinrand*(this: var RGen; scale: int32): int32 {.inline.} =
  var a: int32 = irand(scale)
  var b: int32 = irand(scale)
  return sc_min(a, b)

proc linrand*(this: var RGen; scale: cdouble): cdouble {.inline.} =
  var a: cdouble = drand()
  var b: cdouble = drand()
  return sc_min(a, b) * scale

proc ibilinrand*(this: var RGen; scale: int32): int32 {.inline.} =
  var a: int32 = irand(scale)
  var b: int32 = irand(scale)
  return a - b

proc bilinrand*(this: var RGen; scale: cdouble): cdouble {.inline.} =
  var a: cdouble = drand()
  var b: cdouble = drand()
  return (a - b) * scale

proc exprandrng*(this: var RGen; lo: cdouble; hi: cdouble): cdouble {.inline.} =
  return lo * exp(log(hi div lo) * drand())

proc exprand*(this: var RGen; scale: cdouble): cdouble {.inline.} =
  var z: cdouble
  while (z = drand()) == 0.0: discard
  return -(log(z) * scale)

proc biexprand*(this: var RGen; scale: cdouble): cdouble {.inline.} =
  var z: cdouble
  while (z = drand2(1.0)) == 0.0 or z == -1.0: discard
  if z > 0.0: z = log(z)
  else: z = -log(-z)
  return z * scale

proc sum3rand*(this: var RGen; scale: cdouble): cdouble {.inline.} =
  return (drand() + drand() + drand() - 1.5) * 0.666666667 * scale

proc drand*(s1: var uint32; s2: var uint32; s3: var uint32): cdouble {.inline.} =
  type
    INNER_C_STRUCT_969760104 {.bycopy.} = object
      hi: uint32
      lo: uint32

  var u: tuple[i: INNER_C_STRUCT_969760104, f: cdouble]
  u.i.hi = 0x41300000
  u.i.lo = trand(s1, s2, s3)
  return u.f - 1048576.0

proc frand*(s1: var uint32; s2: var uint32; s3: var uint32): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3F800000 or (trand(s1, s2, s3) shr 9)
  return u.f - 1.0

proc frand0*(s1: var uint32; s2: var uint32; s3: var uint32): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3F800000 or (trand(s1, s2, s3) shr 9)
  return u.f

proc frand2*(s1: var uint32; s2: var uint32; s3: var uint32): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x40000000 or (trand(s1, s2, s3) shr 9)
  return u.f - 3.0

proc frand8*(s1: var uint32; s2: var uint32; s3: var uint32): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3E800000 or (trand(s1, s2, s3) shr 9)
  return u.f - 0.375

proc fcoin*(s1: var uint32; s2: var uint32; s3: var uint32): cfloat {.inline.} =
  var u: tuple[i: uint32, f: cfloat]
  u.i = 0x3F800000 or (0x80000000 and trand(s1, s2, s3))
  return u.f

]#

