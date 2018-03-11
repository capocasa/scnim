

import
  Types, SndBuf

type
  msg_iter = object
  World = object
  UnitDef* = object
  Graph* = object
  Wire* = object
  Rate* = object
  UnitCtorFunc* = proc (inUnit: ptr Unit) {.cdecl.}
  UnitDtorFunc* = proc (inUnit: ptr Unit) {.cdecl.}
  UnitCalcFunc* = proc (inThing: ptr Unit; inNumSamples: cint) {.cdecl}
  Unit_Extensions* {.bycopy.} = object
    todo*: ptr cfloat

  Unit* {.bycopy,inheritable,pure.} = object
    mWorld*: ptr World
    mUnitDef*: ptr UnitDef
    mParent*: ptr Graph
    mNumInputs*: uint32
    mNumOutputs*: uint32
    mCalcRate*: int16
    mSpecialIndex*: int16
    mParentIndex*: int16
    mDone*: int16
    mInput: ptr ptr Wire
    mOutput: ptr ptr Wire
    mRate: ptr Rate
    mExtensions*: ptr Unit_Extensions
    mInBuf*: ptr ptr cfloat
    mOutBuf*: ptr ptr cfloat
    mCalcFunc*: proc (inThing: ptr Unit; inNumSamples: cint) {.cdecl.}
    mBufLength*: cint


var mWorld*: ptr World

var mUnitDef*: ptr UnitDef

var mParent*: ptr Graph

var
  mInput*: ptr ptr Wire
  mOutput*: ptr ptr Wire

var mRate*: ptr Rate


const
  kUnitDef_CantAliasInputsToOutputs* = 1

#when defined(_WIN32):

template IN*(index: untyped): untyped =
  (unit.mInBuf[index])

template OUT*(index: untyped): untyped =
  (unit.mOutBuf[index])


template IN0*(index: untyped): untyped =
  (IN(index)[0])

template OUT0*(index: untyped): untyped =
  (OUT(index)[0])


template INRATE*(index: untyped): untyped =
  (unit.mInput[index].mCalcRate)


template INBUFLENGTH*(index: untyped): untyped =
  (unit.mInput[index].mFromUnit.mBufLength)


template SETCALC*(`func`: untyped): untyped =
  (unit.mCalcFunc = (UnitCalcFunc) and `func`)


#[
const
  SAMPLERATE* = (unit.mRate.mSampleRate)
  SAMPLEDUR* = (unit.mRate.mSampleDur)
  BUFLENGTH* = (unit.mBufLength)
  BUFRATE* = (unit.mRate.mBufRate)
  BUFDUR* = (unit.mRate.mBufDuration)
  FULLRATE* = (unit.mWorld.mFullRate.mSampleRate)
  FULLBUFLENGTH* = (unit.mWorld.mFullRate.mBufLength)
]#

when defined(SUPERNOVA):
  type
    buffer_lock2* {.bycopy.}[shared1: static[bool]; shared2: static[bool]] = object
      buf1U*: ptr SndBuf
      buf2U*: ptr SndBuf

  proc constructbuffer_lock2*[shared1: static[bool]; shared2: static[bool]](
      buf1: ptr SndBuf; buf2: ptr SndBuf): buffer_lock2[shared1, shared2] {.constructor.} =
    if buf1 == buf2:
      lock1()
      return
    while true:
      lock1()
      if lock2(): return
      unlock1()

  proc destroybuffer_lock2*[shared1: static[bool]; shared2: static[bool]](
      this: var buffer_lock2[shared1, shared2]) {.destructor.} =
    unlock1()
    if buf1U != buf2U: unlock2()
  
  proc lock1*[shared1: static[bool]; shared2: static[bool]](
      this: var buffer_lock2[shared1, shared2]) =
    if buf1U.isLocal: return

    if not shared1: buf1U.lock.lock()
    else: buf1U.lock.lock_shared()
  
  proc lock2*[shared1: static[bool]; shared2: static[bool]](
      this: var buffer_lock2[shared1, shared2]): bool =
    if buf2U.isLocal: return true

    if not shared2: return buf2U.lock.try_lock()
    else: return buf2U.lock.try_lock_shared()
  
  proc unlock1*[shared1: static[bool]; shared2: static[bool]](
      this: var buffer_lock2[shared1, shared2]) =
    if buf1U.isLocal: return

    if not shared1: buf1U.lock.unlock()
    else: buf1U.lock.unlock_shared()
  
  proc unlock2*[shared1: static[bool]; shared2: static[bool]](
      this: var buffer_lock2[shared1, shared2]) =
    if buf2U.isLocal: return

    if not shared2: buf2U.lock.unlock()
    else: buf2U.lock.unlock_shared()
  
  type
    buffer_lock* {.bycopy.}[shared: static[bool]] = object
      bufU*: ptr SndBuf

  proc constructbuffer_lock*[shared: static[bool]](buf: ptr SndBuf): buffer_lock[
      shared] {.constructor.} =
    if not buf.isLocal:
      if shared: buf.lock.lock_shared()
      else: buf.lock.lock()
  
  proc destroybuffer_lock*[shared: static[bool]](this: var buffer_lock[shared]) {.
      destructor.} =
    if not bufU.isLocal:
      if shared: bufU.lock.unlock_shared()
      else: bufU.lock.unlock()
  
  template ACQUIRE_BUS_AUDIO*(index: untyped): untyped =
    unit.mWorld.mAudioBusLocks[index].lock()

  template ACQUIRE_BUS_AUDIO_SHARED*(index: untyped): untyped =
    unit.mWorld.mAudioBusLocks[index].lock_shared()

  template RELEASE_BUS_AUDIO*(index: untyped): untyped =
    unit.mWorld.mAudioBusLocks[index].unlock()

  template RELEASE_BUS_AUDIO_SHARED*(index: untyped): untyped =
    unit.mWorld.mAudioBusLocks[index].unlock_shared()

  template ACQUIRE_SNDBUF*(buf: untyped): void =
    while true:
      if not buf.isLocal: buf.lock.lock()
      if not false: break
  
  template ACQUIRE_SNDBUF_SHARED*(buf: untyped): void =
    while true:
      if not buf.isLocal: buf.lock.lock_shared()
      if not false: break
  
  template RELEASE_SNDBUF*(buf: untyped): void =
    while true:
      if not buf.isLocal: buf.lock.unlock()
      if not false: break
  
  template RELEASE_SNDBUF_SHARED*(buf: untyped): void =
    while true:
      if not buf.isLocal: buf.lock.unlock_shared()
      if not false: break
  
  template ACQUIRE_BUS_CONTROL*(index: untyped): untyped =
    unit.mWorld.mControlBusLock.lock()

  template RELEASE_BUS_CONTROL*(index: untyped): untyped =
    unit.mWorld.mControlBusLock.unlock()

else:
  template ACQUIRE_BUS_AUDIO*(index: untyped): void =
    nil

  template ACQUIRE_BUS_AUDIO_SHARED*(index: untyped): void =
    nil

  template RELEASE_BUS_AUDIO*(index: untyped): void =
    nil

  template RELEASE_BUS_AUDIO_SHARED*(index: untyped): void =
    nil

  template LOCK_SNDBUF*(buf: untyped): void =
    nil

  template LOCK_SNDBUF_SHARED*(buf: untyped): void =
    nil

  template LOCK_SNDBUF2*(buf1, buf2: untyped): void =
    nil

  template LOCK_SNDBUF2_SHARED*(buf1, buf2: untyped): void =
    nil

  template LOCK_SNDBUF2_EXCLUSIVE_SHARED*(buf1, buf2: untyped): void =
    nil

  template LOCK_SNDBUF2_SHARED_EXCLUSIVE*(buf1, buf2: untyped): void =
    nil

  template ACQUIRE_SNDBUF*(buf: untyped): void =
    nil

  template ACQUIRE_SNDBUF_SHARED*(buf: untyped): void =
    nil

  template RELEASE_SNDBUF*(buf: untyped): void =
    nil

  template RELEASE_SNDBUF_SHARED*(buf: untyped): void =
    nil

  template ACQUIRE_BUS_CONTROL*(index: untyped): void =
    nil

  template RELEASE_BUS_CONTROL*(index: untyped): void =
    nil


type
  UnitCmdFunc* = proc (unit: ptr Unit; args: ptr msg_iter) {.cdecl.}
  PlugInCmdFunc* = proc (inWorld: ptr World; inUserData: pointer; args: ptr msg_iter;
                      replyAddr: pointer) {.cdecl.}
