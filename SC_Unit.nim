
type
  
  UnitDef* = object
  
  UnitCtorFunc* = proc (inUnit: ptr Unit)
  UnitDtorFunc* = proc (inUnit: ptr Unit)
  UnitCalcFunc* = proc (inThing: ptr Unit; inNumSamples: cint)
  SC_Unit_Extensions* {.bycopy.} = object
    todo*: ptr cfloat

  World* = object
  Graph* = object
  Wire* = object
  Rate* = object

  Unit* {.bycopy.} = object
    mWorld*: ptr World
    mUnitDef*: ptr UnitDef
    mParent*: ptr Graph
    mNumInputs*: uint32
    mNumOutputs*: uint32       ##  changed from uint16 for synthdef ver 2
    mCalcRate*: int16
    mSpecialIndex*: int16      ##  used by unary and binary ops
    mParentIndex*: int16
    mDone*: int16
    mInput*: ptr ptr Wire
    mOutput*: ptr ptr Wire
    mRate*: ptr Rate
    mExtensions*: ptr SC_Unit_Extensions ## future proofing and backwards compatibility; used to be SC_Dimension struct pointer
    mInBuf*: ptr ptr cfloat
    mOutBuf*: ptr ptr cfloat
    mCalcFunc*: UnitCalcFunc
    mBufLength*: cint


const
  kUnitDef_CantAliasInputsToOutputs* = 1
