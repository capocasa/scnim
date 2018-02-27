
include
  sndfile_stub;

type
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

proc PhaseFrac*(inPhase: uint32): cfloat
proc PhaseFrac1*(inPhase: uint32): cfloat
proc lookup*(table: ptr cfloat; phase: int32; mask: int32): cfloat
const
  xlobits* = 14
  xlobits1* = 13

proc lookupi*(table: ptr cfloat; phase: uint32; mask: uint32): cfloat
proc lookupi2*(table: ptr cfloat; phase: uint32; mask: uint32): cfloat
proc lookupi1*(table0: ptr cfloat; table1: ptr cfloat; pphase: uint32; lomask: int32): cfloat
proc lininterp*(x: cfloat; a: cfloat; b: cfloat): cfloat
proc cubicinterp*(x: cfloat; y0: cfloat; y1: cfloat; y2: cfloat; y3: cfloat): cfloat
