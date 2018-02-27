
import
  SC_Types, SC_Rate, SC_SndBuf, SC_RGen

## -#ifdef SUPERNOVA
## -namespace nova
## -{
## -class spin_lock;
## -class padded_rw_spinlock;
## -}
## -#endif

type
  InterfaceTable* = object
  Group = object
  HiddenWorld* = object
  World* {.bycopy.} = object
    hw*: ptr HiddenWorld        ##  a pointer to private implementation, not available to plug-ins.
    ##  a pointer to the table of function pointers that implement the plug-ins'
    ##  interface to the server.
    ft*: ptr InterfaceTable     ##  data accessible to plug-ins :
    mSampleRate*: cdouble
    mBufLength*: cint
    mBufCounter*: cint
    mNumAudioBusChannels*: uint32
    mNumControlBusChannels*: uint32
    mNumInputs*: uint32
    mNumOutputs*: uint32       ##  vector of samples for all audio busses
    mAudioBus*: ptr cfloat      ##  vector of samples for all control busses
    mControlBus*: ptr cfloat ##  these tell if a bus has been written to during a control period
                          ##  if the value is equal to mBufCounter then the buss has been touched
                          ##  this control period.
    mAudioBusTouched*: ptr int32
    mControlBusTouched*: ptr int32
    mNumSndBufs*: uint32
    mSndBufs*: ptr SndBuf
    mSndBufsNonRealTimeMirror*: ptr SndBuf
    mSndBufUpdates*: ptr SndBufUpdates
    mTopGroup*: ptr Group
    mFullRate*: Rate
    mBufRate*: Rate
    mNumRGens*: uint32
    mRGen*: ptr RGen
    mNumUnits*: uint32
    mNumGraphs*: uint32
    mNumGroups*: uint32
    mSampleOffset*: cint       ##  offset in the buffer of current event time.
    mNRTLock*: pointer
    mNumSharedControls*: uint32
    mSharedControls*: ptr cfloat
    mRealTime*: bool
    mRunning*: bool
    mDumpOSC*: cint
    mDriverLock*: pointer
    mSubsampleOffset*: cfloat  ##  subsample accurate offset in the buffer of current event time.
    mVerbosity*: cint
    mErrorNotification*: cint
    mLocalErrorNotification*: cint
    mRendezvous*: bool         ##  Allow user to disable Rendezvous
    mRestrictedPath*: cstring ##  OSC commands to read/write data can only do it within this path, if specified
                            ## -#ifdef SUPERNOVA
                            ## -	nova::padded_rw_spinlock * mAudioBusLocks;
                            ## -	nova::spin_lock * mControlBusLock;
                            ## -#endif
  

proc World_GetBuf*(inWorld: ptr World; index: uint32): ptr SndBuf {.inline.} =
  var offset = if index > inWorld.mNumSndBufs: 0'u32 else: index
  return cast[ptr SndBuf](cast[uint32](inWorld.mSndBufs) + offset)

proc World_GetNRTBuf*(inWorld: ptr World; index: uint32): ptr SndBuf {.inline.} =
  var offset = if index > inWorld.mNumSndBufs: 0'u32 else: index
  return cast[ptr SndBuf](cast[uint32](inWorld.mSndBufsNonRealTimeMirror) + offset)

type
  LoadPlugInFunc* = proc (a2: ptr InterfaceTable)
  UnLoadPlugInFunc* = proc ()

