import
  SC_Types

type
  
  World* = object
  SndBuf* = object
  sc_msg_iter* = object
  
  BufGenFunc* = proc (world: ptr World; buf: ptr SndBuf; msg: ptr sc_msg_iter)
  BufGen* {.bycopy.} = object
    mBufGenName*: array[kSCNameLen, int32]
    mHash*: int32
    mBufGenFunc*: BufGenFunc


proc BufGen_Create*(inName: cstring; inFunc: BufGenFunc): bool {.importc: "BufGen_Create".}

