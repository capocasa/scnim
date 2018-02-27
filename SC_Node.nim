import
  SC_Types

type
  World* = object
  NodeDef* = object
  Group* = object
  NodeCalcFunc* = proc (inNode: ptr Node)
  Node* {.bycopy.} = object
    mID*: int32
    mHash*: int32
    mWorld*: ptr World
    mDef*: ptr NodeDef
    mCalcFunc*: NodeCalcFunc
    mPrev*: ptr Node
    mNext*: ptr Node
    mParent*: ptr Group
    mIsGroup*: int32


const
  kNode_Go* = 0
  kNode_End* = 1
  kNode_On* = 2
  kNode_Off* = 3
  kNode_Move* = 4
  kNode_Info* = 5
