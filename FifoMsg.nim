
import
  World

type
  FifoMsgFunc* = proc (a2: ptr FifoMsg)
  FifoMsg* {.bycopy.} = object
    mPerformFunc*: FifoMsgFunc
    mFreeFunc*: FifoMsgFunc
    mData*: pointer


proc constructFifoMsg*(): FifoMsg {.constructor.} =
  discard

#proc Set*(this: var FifoMsg; inWorld: ptr World; inPerform: FifoMsgFunc;
#         inFree: FifoMsgFunc; inData: pointer)
#proc Perform*(this: var FifoMsg)
#proc Free*(this: var FifoMsg)
var mWorld*: ptr World

#[
proc Set*(this: var FifoMsg; inWorld: ptr World; inPerform: FifoMsgFunc; inFree: FifoMsgFunc; inData: pointer) {.inline} =
  mWorld = inWorld
  mPerformFunc = inPerform
  mFreeFunc = inFree
  mData = inData

proc Perform*(this: var FifoMsg) {.inline.} =
  if mPerformFunc: (mPerformFunc)(this)
  
proc Free*(this: var FifoMsg) {.inline.} =
  if mFreeFunc: (mFreeFunc)(this)
]#

