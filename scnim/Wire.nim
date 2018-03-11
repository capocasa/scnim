

import
  Types, Unit

type
  Wire* {.bycopy.} = object
    mCalcRate*: int32
    mBuffer*: ptr Types.float32
    mScalarValue*: Types.float32


var mFromUnit*: ptr Unit

