

var sc_api_version: cint = 3

export sc_api_version

import
  Types, SndBuf, Unit, BufGen, FifoMsg, fftlib, Export, Node, sndfile_stub, World 

type
  scfft = object
  
  AsyncStageFn* = proc (inWorld: ptr World; cmdData: pointer): bool {.cdecl.}
  AsyncFreeFn* = proc (inWorld: ptr World; cmdData: pointer) {.cdecl.}

include
  ScopeBuffer

type
  InterfaceTable* {.bycopy} = object
    mSineSize*: cuint
    mSineWavetable*: ptr Types.float32
    mSine*: ptr Types.float32
    mCosecant*: ptr Types.float32
    fPrint*: proc (fmt: cstring): cint {.cdecl,varargs.}
    fRanSeed*: proc (): int32 {.cdecl.}
    fDefineUnit*: proc (inUnitClassName: cstring; inAllocSize: csize; 
                      inCtor: UnitCtorFunc; inDtor: UnitDtorFunc; inFlags: uint32): bool {.cdecl.}
    fDefinePlugInCmd*: proc (inCmdName: cstring; inFunc: PlugInCmdFunc; 
                           inUserData: pointer): bool {.cdecl.}
    fDefineUnitCmd*: proc (inUnitClassName: cstring; inCmdName: cstring; 
                         inFunc: UnitCmdFunc): bool {.cdecl.}
    fDefineBufGen*: proc (inName: cstring; inFunc: BufGenFunc): bool {.cdecl.} 
    fClearUnitOutputs*: proc (inUnit: ptr Unit; inNumSamples: cint) {.cdecl.}
    fNRTAlloc*: proc (inSize: csize): pointer {.cdecl.}
    fNRTRealloc*: proc (inPtr: pointer; inSize: csize): pointer {.cdecl.}
    fNRTFree*: proc (inPtr: pointer) {.cdecl.}
    fRTAlloc*: proc (inWorld: ptr World; inSize: csize): pointer {.cdecl.}
    fRTRealloc*: proc (inWorld: ptr World; inPtr: pointer; inSize: csize): pointer {.cdecl.}
    fRTFree*: proc (inWorld: ptr World; inPtr: pointer) {.cdecl.}
    fNodeRun*: proc (node: ptr Node; run: cint) {.cdecl.}
    fNodeEnd*: proc (graph: ptr Node) {.cdecl.}
    fSendTrigger*: proc (inNode: ptr Node; triggerID: cint; value: cfloat) {.cdecl.}
    fSendNodeReply*: proc (inNode: ptr Node; replyID: cint; cmdName: cstring; 
                         numArgs: cint; values: ptr cfloat) {.cdecl.} 
    fSendMsgFromRT*: proc (inWorld: ptr World; inMsg: FifoMsg): bool {.cdecl.}
    fSendMsgToRT*: proc (inWorld: ptr World; inMsg: FifoMsg): bool {.cdecl.}
    fSndFileFormatInfoFromStrings*: proc (info: ptr SF_INFO; 
                                        headerFormatString: cstring;
                                        sampleFormatString: cstring): cint  {.cdecl.}
    fGetNode*: proc (inWorld: ptr World; inID: cint): ptr Node {.cdecl.}
    fGetGraph*: proc (inWorld: ptr World; inID: cint): ptr Graph {.cdecl.}
    fNRTLock*: proc (inWorld: ptr World) {.cdecl.}
    fNRTUnlock*: proc (inWorld: ptr World) {.cdecl.}
    mUnused0*: bool
    fGroup_DeleteAll*: proc (group: ptr Group) {.cdecl.}
    fDoneAction*: proc (doneAction: cint; unit: ptr Unit) {.cdecl.}
    fDoAsynchronousCommand*: proc (inWorld: ptr World; replyAddr: pointer; 
                                 cmdName: cstring; cmdData: pointer;
                                 stage2: AsyncStageFn; stage3: AsyncStageFn;
                                 stage4: AsyncStageFn; cleanup: AsyncFreeFn;
                                 completionMsgSize: cint;
                                 completionMsgData: pointer): cint {.cdecl.}
    fBufAlloc*: proc (inBuf: ptr SndBuf; inChannels: cint; inFrames: cint; 
                    inSampleRate: cdouble): cint {.cdecl.}
    fSCfftCreate*: proc (fullsize: csize; winsize: csize;
                       wintype: SCFFT_WindowFunction; indata: ptr cfloat;
                       outdata: ptr cfloat; forward: SCFFT_Direction;
                       alloc: SCFFT_Allocator): ptr scfft {.cdecl.} 
    fSCfftDoFFT*: proc (f: ptr scfft) {.cdecl.}
    fSCfftDoIFFT*: proc (f: ptr scfft) {.cdecl.}
    fSCfftDestroy*: proc (f: ptr scfft; alloc: SCFFT_Allocator) {.cdecl.}
    fGetScopeBuffer*: proc (inWorld: ptr World; index: cint; channels: cint; 
                          maxFrames: cint; a6: ScopeBufferHnd): bool {.cdecl.}
    fPushScopeBuffer*: proc (inWorld: ptr World; a3: ScopeBufferHnd; frames: cint) {.cdecl.}
    fReleaseScopeBuffer*: proc (inWorld: ptr World; a3: ScopeBufferHnd) {.cdecl.}

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

