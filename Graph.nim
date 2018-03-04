

import
  Node, Rate, SndBuf, Wire, Unit, RGen


type
  Graph* {.bycopy.} = object
    mNode*: Node
    mNumWires*: uint32
    mNumControls*: uint32
    mControls*: ptr cfloat
    mMapControls*: ptr ptr cfloat
    mAudioBusOffsets*: ptr int32
    mControlRates*: ptr cint
    mNumUnits*: uint32
    mNumCalcUnits*: uint32
    mSampleOffset*: cint
    mSubsampleOffset*: cfloat
    mLocalSndBufs*: ptr SndBuf
    localBufNum*: cint
    localMaxBufNum*: cint


var mWire*: ptr Unit.Wire

var mUnits*: ptr ptr Unit

var mCalcUnits*: ptr ptr Unit

var mRGen*: ptr RGen

var mLocalAudioBusUnit*: ptr Unit

var mLocalControlBusUnit*: ptr Unit

