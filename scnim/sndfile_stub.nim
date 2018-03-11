

type
  SNDFILE_tag = object
  SNDFILE* = SNDFILE_tag


type
  sf_count_t* = cint

const
  SF_COUNT_MAX* = 0x7FFFFFFFFFFFFFFF'i64


type
  SF_INFO* {.bycopy.} = object
    frames*: sf_count_t
    samplerate*: cint
    channels*: cint
    format*: cint
    sections*: cint
    seekable*: cint

