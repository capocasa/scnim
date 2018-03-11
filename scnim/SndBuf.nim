
type
  SNDFILEag = object
  SNDFILE* = SNDFILEag
  SndBuf* {.bycopy.} = object
    samplerate*: cdouble
    sampledur*: cdouble
    data*: ptr cfloat
    channels*: cint
    samples*: cint
    frames*: cint
    mask*: cint
    mask1*: cint
    coord*: cint
    sndfile*: ptr SNDFILE

  SndBufUpdates* {.bycopy.} = object
    reads*: cint
    writes*: cint


const
  coord_None* = 0
  coord_Complex* = 1
  coord_Polar* = 2

proc PhaseFrac*(inPhase: uint32): cfloat {.inline.} =
  var u: tuple[itemp: uint32, ftemp: cfloat]
  u.itemp = 0x3F800000'u32 or (0x007FFF80'u32 and ((inPhase) shl 7))
  return u.ftemp - 1.0

proc PhaseFrac1*(inPhase: uint32): cfloat {.inline.} =
  var u: tuple[itemp: uint32, ftemp: cfloat]
  u.itemp = 0x3F800000'u32 or (0x007FFF80'u32 and ((inPhase) shl 7))
  return u.ftemp

proc lookup*(table: ptr cfloat; phase: int32; mask: int32): cfloat {.inline.} =
#[todo
  return table[(phase shr 16) and mask]
]#
  return 0;

const
  xlobits* = 14
  xlobits1* = 13

proc lookupi*(table: ptr cfloat; phase: uint32; mask: uint32): cfloat {.inline.} =
#[todo
  var frac: cfloat = PhaseFrac(phase)
  var tbl: ptr cfloat = table + ((phase shr 16) and mask)
  var a: cfloat = tbl[0]
  var b: cfloat = tbl[1]
  return a + frac * (b - a)
]#
  return 0;

proc lookupi2*(table: ptr cfloat; phase: uint32; mask: uint32): cfloat {.inline.} =
#[todo
  var frac: cfloat = PhaseFrac1(phase)
  var tbl: ptr cfloat = table + ((phase shr 16) and mask)
  var a: cfloat = tbl[0]
  var b: cfloat = tbl[1]
  return a + frac * b
]#
  return 0;

proc lookupi1*(table0: ptr cfloat; table1: ptr cfloat; pphase: uint32; lomask: int32): cfloat {.
    inline.} =
#[todo
  var pfrac: cfloat = PhaseFrac1(pphase)
  var index: uint32 = ((pphase shr xlobits1) and lomask)
  var val1: cfloat = cast[ptr cfloat]((cast[cstring](table0) + index))[]
  var val2: cfloat = cast[ptr cfloat]((cast[cstring](table1) + index))[]
  return val1 + val2 * pfrac
]#
  return 0;

proc lininterp*(x: cfloat; a: cfloat; b: cfloat): cfloat {.inline.} =
#[todo
  return a + x * (b - a)
]#
  return 0;

proc cubicinterp*(x: cfloat; y0: cfloat; y1: cfloat; y2: cfloat; y3: cfloat): cfloat {.
    inline.} =
#[todo
  var c0: cfloat = y1
  var c1: cfloat = 0.5 * (y2 - y0)
  var c2: cfloat = y0 - 2.5 * y1 + 2.0 * y2 - 0.5 * y3
  var c3: cfloat = 0.5 * (y3 - y0) + 1.5 * (y1 - y2)
  return ((c3 * x + c2) * x + c1) * x + c0
]#
  return 0;
