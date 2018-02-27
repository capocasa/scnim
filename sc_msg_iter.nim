import
  SC_Endian, SC_Types

##  return the ptr to the byte after the OSC string.

proc OSCstrskip*(str: cstring): cstring {.inline.} =
  ## 	while (str[3]) { str += 4; }
  ## 	return str + 4;
  while true:
    inc(str, 4)
    if not str[-1]: break
  return str

##  returns the number of bytes (including padding) for an OSC string.

proc OSCstrlen*(strin: cstring): csize {.inline.} =
  return OSCstrskip(strin) - strin

##  returns a float, converting an int if necessary

proc OSCfloat*(inData: cstring): float32 {.inline.} =
  var elem: elem32
  elem.u = sc_ntohl(cast[ptr uint32](inData)[])
  return elem.f

proc OSCint*(inData: cstring): int32 {.inline.} =
  return cast[int32](sc_ntohl(cast[ptr uint32](inData)[]))

proc OSCtime*(inData: cstring): int64 {.inline.} =
  return (cast[int64](sc_ntohl(cast[ptr uint32](inData)[])) shl 32) +
      (sc_ntohl(cast[ptr uint32]((inData + 4))[]))

proc OSCdouble*(inData: cstring): float64 {.inline.} =
  var slot: elem64
  slot.i = (cast[int64](sc_ntohl(cast[ptr uint32](inData)[])) shl 32) +
      (sc_ntohl(cast[ptr uint32]((inData + 4))[]))
  return slot.f

type
  sc_msg_iter* {.bycopy.} = object
    data*: cstring
    rdpos*: cstring
    endpos*: cstring
    tags*: cstring
    size*: cint
    count*: cint
    sc_msg_iter*: proc ()
    sc_msg_iter*: proc (inSize: cint; inData: cstring)
    init*: proc (inSize: cint; inData: cstring)
    gett*: proc (defaultValue: int64 = 1): int64
    geti*: proc (defaultValue: int32 = 0): int32
    getf*: proc (defaultValue: float32 = 0.0): float32
    getd*: proc (defaultValue: float64 = 0.0): float64
    gets*: proc (defaultValue: cstring = 0): cstring
    gets4*: proc (defaultValue: cstring = 0): ptr int32
    getbsize*: proc (): csize
    getb*: proc (outData: cstring; inSize: csize)
    skipb*: proc ()
    remain*: proc (): csize      ## -{ return endpos - rdpos; }
    nextTag*: proc (defaultTag: char = 'f'): char ## -{ return tags ? tags[count] : defaultTag; }
  
