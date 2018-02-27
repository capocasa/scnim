import
  SC_Node, SC_Rate, SC_SndBuf

## 
##  changes to this struct likely also mean that a change is needed for
##     static const int sc_api_version = x;
##  value in SC_InterfaceTable.h file.
## 

type
  Unit* = object 
  Wire* = object 
  RGen* = object 
  Graph* {.bycopy.} = object
    mNode*: Node
    mNumWires*: uint32
    mWire*: ptr Wire
    mNumControls*: uint32
    mControls*: ptr cfloat
    mMapControls*: ptr ptr cfloat
    mAudioBusOffsets*: ptr int32 ##  try this for setting the rate of a control
    mControlRates*: ptr cint
    mNumUnits*: uint32
    mUnits*: ptr ptr Unit
    mNumCalcUnits*: uint32
    mCalcUnits*: ptr ptr Unit    ##  excludes i-rate units.
    mSampleOffset*: cint
    mRGen*: ptr RGen
    mLocalAudioBusUnit*: ptr Unit
    mLocalControlBusUnit*: ptr Unit
    mSubsampleOffset*: cfloat
    mLocalSndBufs*: ptr SndBuf
    localBufNum*: cint
    localMaxBufNum*: cint

