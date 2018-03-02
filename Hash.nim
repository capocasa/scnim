

import
  Types, Endian

#[

proc Hash*(inKey: cstring): int32 {.inline.} =
  var hash: int32 = 0
  while inKey[]:
    inc(hash, inc(inKey)[])
    inc(hash, hash shl 10)
    hash = hash xor hash shr 6

  inc(hash, hash shl 3)
  hash = hash xor hash shr 11
  inc(hash, hash shl 15)
  return hash


proc Hash*(inKey: cstring; outLength: ptr csize): int32 {.inline.} =
  var origKey: cstring = inKey
  var hash: int32 = 0
  while inKey[]:
    inc(hash, inc(inKey)[])
    inc(hash, hash shl 10)
    hash = hash xor hash shr 6

  inc(hash, hash shl 3)
  hash = hash xor hash shr 11
  inc(hash, hash shl 15)
  outLength[] = inKey - origKey
  return hash


proc Hash*(inKey: cstring; inLength: int32): int32 {.inline.} =
  var hash: int32 = 0
  var i: cint = 0
  while i < inLength:
    inc(hash, inc(inKey)[])
    inc(hash, hash shl 10)
    hash = hash xor hash shr 6
    inc(i)

  inc(hash, hash shl 3)
  hash = hash xor hash shr 11
  inc(hash, hash shl 15)
  return hash


proc Hash*(inKey: int32): int32 {.inline.} =
  var hash: uint32 = cast[uint32](inKey)
  inc(hash, not (hash shl 15))
  hash = hash xor hash shr 10
  inc(hash, hash shl 3)
  hash = hash xor hash shr 6
  inc(hash, not (hash shl 11))
  hash = hash xor hash shr 16
  return cast[int32](hash)

proc Hash64*(inKey: int64): int64 {.inline.} =
  var hash: uint64 = cast[uint64](inKey)
  inc(hash, not (hash shl 32))
  hash = hash xor (hash shr 22)
  inc(hash, not (hash shl 13))
  hash = hash xor (hash shr 8)
  inc(hash, (hash shl 3))
  hash = hash xor (hash shr 15)
  inc(hash, not (hash shl 27))
  hash = hash xor (hash shr 31)
  return cast[int64](hash)

proc Hash*(inKey: ptr int32; inLength: int32): int32 {.inline.} =
  var hash: int32 = 0
  var i: cint = 0
  while i < inLength:
    hash = Hash(hash + inc(inKey)[])
    inc(i)

  return hash

when BYTE_ORDER == LITTLE_ENDIAN:
  var kLASTCHAR*: int32 = 0xFF000000
else:
  var kLASTCHAR*: int32 = 0x000000FF
proc Hash*(inKey: ptr int32): int32 {.inline.} =
  var hash: int32 = 0
  var c: int32
  while true:
    c = inc(inKey)[]
    hash = Hash(hash + c)
    if not (c and kLASTCHAR): break
  return hash

]#

