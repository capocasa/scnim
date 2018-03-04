

import
  Types, World, SndBuf, msg_iter

type
  BufGenFunc* = proc (world: ptr World; buf: ptr SndBuf; msg: ptr msg_iter)
  BufGen* {.bycopy.} = object
    #mBufGenName*: array[kSCNameLen, int32]
    mBufGenName*: array[8, int32]
    mHash*: int32
    mBufGenFunc*: BufGenFunc



#proc BufGen_Create*(inName: cstring; inFunc: BufGenFunc): bool
