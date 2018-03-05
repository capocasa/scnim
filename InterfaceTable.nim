

var sc_api_version: cint = 3

export sc_api_version

import
  Types, SndBuf, Unit, BufGen, FifoMsg, fftlib, Export, Node, sndfile_stub, World 

type
  scfft = object
  
  AsyncStageFn* = proc (inWorld: ptr World; cmdData: pointer): bool
  AsyncFreeFn* = proc (inWorld: ptr World; cmdData: pointer)

include
  ScopeBuffer

type
  InterfaceTable* {.bycopy.} = object
    mSineSize*: cuint
    mSineWavetable*: ptr Types.float32
    mSine*: ptr Types.float32
    mCosecant*: ptr Types.float32
    fPrint*: proc (fmt: cstring): cint {.varargs.}
    fRanSeed*: proc (): int32
    fDefineUnit*: proc (inUnitClassName: cstring; inAllocSize: csize;
                      inCtor: UnitCtorFunc; inDtor: UnitDtorFunc; inFlags: uint32): bool
    fDefinePlugInCmd*: proc (inCmdName: cstring; inFunc: PlugInCmdFunc;
                           inUserData: pointer): bool
    fDefineUnitCmd*: proc (inUnitClassName: cstring; inCmdName: cstring;
                         inFunc: UnitCmdFunc): bool
    fDefineBufGen*: proc (inName: cstring; inFunc: BufGenFunc): bool
    fClearUnitOutputs*: proc (inUnit: ptr Unit; inNumSamples: cint)
    fNRTAlloc*: proc (inSize: csize): pointer
    fNRTRealloc*: proc (inPtr: pointer; inSize: csize): pointer
    fNRTFree*: proc (inPtr: pointer)
    fRTAlloc*: proc (inWorld: ptr World; inSize: csize): pointer
    fRTRealloc*: proc (inWorld: ptr World; inPtr: pointer; inSize: csize): pointer
    fRTFree*: proc (inWorld: ptr World; inPtr: pointer)
    fNodeRun*: proc (node: ptr Node; run: cint)
    fNodeEnd*: proc (graph: ptr Node)
    fSendTrigger*: proc (inNode: ptr Node; triggerID: cint; value: cfloat)
    fSendNodeReply*: proc (inNode: ptr Node; replyID: cint; cmdName: cstring;
                         numArgs: cint; values: ptr cfloat)
    fSendMsgFromRT*: proc (inWorld: ptr World; inMsg: FifoMsg): bool
    fSendMsgToRT*: proc (inWorld: ptr World; inMsg: FifoMsg): bool
    fSndFileFormatInfoFromStrings*: proc (info: ptr SF_INFO;
                                        headerFormatString: cstring;
                                        sampleFormatString: cstring): cint
    fGetNode*: proc (inWorld: ptr World; inID: cint): ptr Node
    fGetGraph*: proc (inWorld: ptr World; inID: cint): ptr Graph
    fNRTLock*: proc (inWorld: ptr World)
    fNRTUnlock*: proc (inWorld: ptr World)
    mUnused0*: bool
    fGroup_DeleteAll*: proc (group: ptr Group)
    fDoneAction*: proc (doneAction: cint; unit: ptr Unit)
    fDoAsynchronousCommand*: proc (inWorld: ptr World; replyAddr: pointer;
                                 cmdName: cstring; cmdData: pointer;
                                 stage2: AsyncStageFn; stage3: AsyncStageFn;
                                 stage4: AsyncStageFn; cleanup: AsyncFreeFn;
                                 completionMsgSize: cint;
                                 completionMsgData: pointer): cint
    fBufAlloc*: proc (inBuf: ptr SndBuf; inChannels: cint; inFrames: cint;
                    inSampleRate: cdouble): cint
    fSCfftCreate*: proc (fullsize: csize; winsize: csize;
                       wintype: SCFFT_WindowFunction; indata: ptr cfloat;
                       outdata: ptr cfloat; forward: SCFFT_Direction;
                       alloc: SCFFT_Allocator): ptr scfft
    fSCfftDoFFT*: proc (f: ptr scfft)
    fSCfftDoIFFT*: proc (f: ptr scfft)
    fSCfftDestroy*: proc (f: ptr scfft; alloc: SCFFT_Allocator)
    fGetScopeBuffer*: proc (inWorld: ptr World; index: cint; channels: cint;
                          maxFrames: cint; a6: ScopeBufferHnd): bool
    fPushScopeBuffer*: proc (inWorld: ptr World; a3: ScopeBufferHnd; frames: cint)
    fReleaseScopeBuffer*: proc (inWorld: ptr World; a3: ScopeBufferHnd)

#[
const
  Print* = (ft.fPrint[])
  RanSeed* = (ft.fRanSeed[])
  NodeEnd* = (ft.fNodeEnd[])
  NodeRun* = (ft.fNodeRun[])
  DefineUnit* = (ft.fDefineUnit[])
  DefinePlugInCmd* = (ft.fDefinePlugInCmd[])
  DefineUnitCmd* = (ft.fDefineUnitCmd[])
  DefineBufGen* = (ft.fDefineBufGen[])
  ClearUnitOutputs* = (ft.fClearUnitOutputs[])
  SendTrigger* = (ft.fSendTrigger[])
  SendNodeReply* = (ft.fSendNodeReply[])
  SendMsgFromRT* = (ft.fSendMsgFromRT[])
  SendMsgToRT* = (ft.fSendMsgToRT[])
  DoneAction* = (ft.fDoneAction[])
  NRTAlloc* = (ft.fNRTAlloc[])
  NRTRealloc* = (ft.fNRTRealloc[])
  NRTFree* = (ft.fNRTFree[])
  RTAlloc* = (ft.fRTAlloc[])
  RTRealloc* = (ft.fRTRealloc[])
  RTFree* = (ft.fRTFree[])
  GetNode* = (ft.fGetNode[])
  GetGraph* = (ft.fGetGraph[])
  NRTLock* = (ft.fNRTLock[])
  NRTUnlock* = (ft.fNRTUnlock[])
  BufAlloc* = (ft.fBufAlloc[])
  GroupDeleteAll* = (ft.fGroup_DeleteAll[])
  SndFileFormatInfoFromStrings* = (ft.fSndFileFormatInfoFromStrings[])
  DoAsynchronousCommand* = (ft.fDoAsynchronousCommand[])
]#

type
  ServerType* = enum
    sc_server_scsynth = 0, sc_server_supernova = 1


#[
const
  scfft_create* = (ft.fSCfftCreate[])
  scfft_dofft* = (ft.fSCfftDoFFT[])
  scfft_doifft* = (ft.fSCfftDoIFFT[])
  scfft_destroy* = (ft.fSCfftDestroy[])
]#

