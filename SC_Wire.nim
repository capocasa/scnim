import
  SC_Types

type
  Wire* {.bycopy.} = object
    mFromUnit*: ptr Unit
    mCalcRate*: int32
    mBuffer*: ptr float32
    mScalarValue*: float32

