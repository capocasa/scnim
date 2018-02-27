

const
  calc_ScalarRate* = 0
  calc_BufRate* = 1
  calc_FullRate* = 2
  calc_DemandRate* = 3

type
  Rate* {.bycopy.} = object
    mSampleRate*: cdouble
    mSampleDur*: cdouble
    mBufDuration*: cdouble
    mBufRate*: cdouble
    mSlopeFactor*: cdouble
    mRadiansPerSample*: cdouble
    mBufLength*: cint
    mFilterLoops*: cint
    mFilterRemain*: cint
    mFilterSlope*: cdouble

