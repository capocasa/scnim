

import
  Types, Rate, SndBuf, RGen

when defined(SUPERNOVA):
  discard "forward decl of spin_lock"
  discard "forward decl of padded_rw_spinlock"
type
  Group* = object
  InterfaceTable* = object
  HiddenWorld* = object
  World* {.bycopy.} = object
    mSampleRate*: cdouble
    mBufLength*: cint
    mBufCounter*: cint
    mNumAudioBusChannels*: uint32
    mNumControlBusChannels*: uint32
    mNumInputs*: uint32
    mNumOutputs*: uint32
    mAudioBus*: ptr cfloat
    mControlBus*: ptr cfloat
    mAudioBusTouched*: ptr int32
    mControlBusTouched*: ptr int32
    mNumSndBufs*: uint32
    mSndBufs*: ptr SndBuf
    mSndBufsNonRealTimeMirror*: ptr SndBuf
    mSndBufUpdates*: ptr SndBufUpdates
    mFullRate*: Rate
    mBufRate*: Rate
    mNumRGens*: uint32
    mRGen*: ptr RGen
    mNumUnits*: uint32
    mNumGraphs*: uint32
    mNumGroups*: uint32
    mSampleOffset*: cint
    mNRTLock*: pointer
    mNumSharedControls*: uint32
    mSharedControls*: ptr cfloat
    mRealTime*: bool
    mRunning*: bool
    mDumpOSC*: cint
    mDriverLock*: pointer
    mSubsampleOffset*: cfloat
    mVerbosity*: cint
    mErrorNotification*: cint
    mLocalErrorNotification*: cint
    mRendezvous*: bool
    mRestrictedPath*: cstring


var hw*: ptr HiddenWorld

var ft*: ptr InterfaceTable

var mTopGroup*: ptr Group

proc World_GetBuf*(inWorld: ptr World; index: uint32): ptr SndBuf {.inline.} =
  let b = cast[uint32](inWorld.mNumSndBufs)
  let i = if index > b: 0'u32 else: index
  return cast[ptr SndBuf](b + i)

proc World_GetNRTBuf*(inWorld: ptr World; index: uint32): ptr SndBuf {.inline.} =
  let b = cast[uint32](inWorld.mNumSndBufs)
  let i = if index > b: 0'u32 else: index
  let c = cast[uint32](inWorld.mSndBufsNonRealTimeMirror)
  return cast[ptr SndBuf](c + i)

type
  LoadPlugInFunc* = proc (a2: ptr InterfaceTable)
  UnLoadPlugInFunc* = proc ()
