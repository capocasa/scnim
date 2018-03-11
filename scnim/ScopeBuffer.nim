##  From InterfaceTable
## 

type
  ScopeBufferHnd* {.bycopy.} = object
    internalData*: pointer
    data*: ptr cfloat
    channels*: uint32
    maxFrames*: uint32


#proc channel_data*(this: var ScopeBufferHnd; channel: uint32): ptr cfloat =
#  return data + (channel * maxFrames)

#converter `bool`*(this: var ScopeBufferHnd): bool =
#  return internalData != 0
