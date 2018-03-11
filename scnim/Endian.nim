const
  LITTLE_ENDIAN* = 1234
  BIG_ENDIAN* = 4321
  BYTE_ORDER* = LITTLE_ENDIAN
#[
proc sc_htonl*(x: cuint): cuint {.inline.} =
  when BYTE_ORDER == LITTLE_ENDIAN:
    var s: ptr cuchar = cast[ptr cuchar](addr(x))
    return cast[cuint]((s[0] shl 24 or s[1] shl 16 or s[2] shl 8 or s[3]))
  else:
    return x

proc sc_htons*(x: cushort): cushort {.inline.} =
  when BYTE_ORDER == LITTLE_ENDIAN:
    var s: ptr cuchar = cast[ptr cuchar](addr(x))
    return cast[cushort]((s[0] shl 8 or s[1]))
  else:
    return x

proc sc_ntohl*(x: cuint): cuint {.inline.} =
  return sc_htonl(x)

proc sc_ntohs*(x: cushort): cushort {.inline.} =
  return sc_htons(x)
]#

