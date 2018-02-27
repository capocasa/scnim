const
  calc_ScalarRate* = 0
  calc_BufRate* = 1
  calc_FullRate* = 2
  calc_DemandRate* = 3

type
  Rate* {.bycopy.} = object
    mSampleRate*: cdouble      ##  samples per second
    mSampleDur*: cdouble       ##  seconds per sample
    mBufDuration*: cdouble     ##  seconds per buffer
    mBufRate*: cdouble         ##  buffers per second
    mSlopeFactor*: cdouble     ##  1. / NumSamples
    mRadiansPerSample*: cdouble ##  2pi / SampleRate
    mBufLength*: cint          ##  length of the buffer
                    ##  second order filter loops are often unrolled by 3
    mFilterLoops*: cint
    mFilterRemain*: cint
    mFilterSlope*: cdouble

