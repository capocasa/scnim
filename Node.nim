

import
  Types, World

type
  NodeDef* = object
  NodeCalcFunc* = proc (inNode: ptr Node)
  Node* {.bycopy.} = object
    mID*: int32
    mHash*: int32
    mCalcFunc*: NodeCalcFunc
    mIsGroup*: int32


var mWorld*: ptr World

var mDef*: ptr NodeDef

var
  mPrev*: ptr Node
  mNext*: ptr Node

var mParent*: ptr Group


const
  kNode_Go* = 0
  kNode_End* = 1
  kNode_On* = 2
  kNode_Off* = 3
  kNode_Move* = 4
  kNode_Info* = 5
