

import
  Endian, Types

#[
proc OSCstrskip*(str: cstring): cstring {.inline.} =
  while true:
    inc(str, 4)
    if not str[-1]: break
  return str


proc OSCstrlen*(strin: cstring): csize {.inline.} =
  return OSCstrskip(strin) - strin


proc OSCfloat*(inData: cstring): float32 {.inline.} =
  var elem: elem32
  elem.u = ntohl(cast[ptr uint32](inData)[])
  return elem.f

proc OSCint*(inData: cstring): int32 {.inline.} =
  return cast[int32](ntohl(cast[ptr uint32](inData)[]))

proc OSCtime*(inData: cstring): int64 {.inline.} =
  return (cast[int64](ntohl(cast[ptr uint32](inData)[])) shl 32) +
      (ntohl(cast[ptr uint32]((inData + 4))[]))

proc OSCdouble*(inData: cstring): float64 {.inline.} =
  var slot: elem64
  slot.i = (cast[int64](ntohl(cast[ptr uint32](inData)[])) shl 32) +
      (ntohl(cast[ptr uint32]((inData + 4))[]))
  return slot.f

]#

type
  msg_iter* {.bycopy.} = object
    data*: cstring
    rdpos*: cstring
    endpos*: cstring
    tags*: cstring
    size*: cint
    count*: cint


#proc constructsc_msg_iter*(): msg_iter {.constructor.}
#proc constructsc_msg_iter*(inSize: cint; inData: cstring): msg_iter {.constructor.}
#proc init*(this: var msg_iter; inSize: cint; inData: cstring)
#proc gett*(this: var msg_iter; defaultValue: int64 = 1): int64
#proc geti*(this: var msg_iter; defaultValue: int32 = 0): int32
#proc getf*(this: var msg_iter; defaultValue: Types.float32 = 0.0): Types.float32
#proc getd*(this: var msg_iter; defaultValue: Types.float64 = 0.0): Types.float64
#proc gets*(this: var msg_iter; defaultValue: cstring = ""): cstring
#proc gets4*(this: var msg_iter; defaultValue: cstring = ""): ptr int32
#proc getbsize*(this: var msg_iter): csize
#proc getb*(this: var msg_iter; outData: cstring; inSize: csize)
#proc skipb*(this: var msg_iter)

#proc remain*(this: var msg_iter): csize =
#  return endpos - rdpos

#proc nextTag*(this: var msg_iter; defaultTag: char = 'f'): char =
#  return if tags: tags[count] else: defaultTag


