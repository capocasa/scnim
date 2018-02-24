
import SC_Unit

var sc_api_version*: cint = 2


type
  World* {.bycopy.} = object
  
type
  AsyncStageFn* = proc (inWorld: ptr World; cmdData: pointer): bool
  AsyncFreeFn* = proc (inWorld: ptr World; cmdData: pointer)
type
  ScopeBufferHnd* {.bycopy.} = object
    internalData*: pointer
    data*: ptr cfloat
    channels*: uint32
    maxFrames*: uint32
    channel_data*: proc (channel: uint32): ptr cfloat
#    bool*: proc (): operator

type
  InterfaceTable* {.bycopy.} = object
    mSineSize*: cuint
    mSineWavetable*: ptr float32
    mSine*: ptr float32
    mCosecant*: ptr float32   ##  call printf for debugging. should not use in finished code.
    fPrint*: proc (fmt: cstring): cint {.varargs.} ##  get a seed for a random number generator
    fRanSeed*: proc (): int32  ##  define a unit def
    fDefineUnit*: proc (inUnitClassName: cstring; inAllocSize: csize;
                      inCtor: UnitCtorFunc; inDtor: UnitDtorFunc; inFlags: uint32): bool ##  define a command  /cmd
    fDefinePlugInCmd*: proc (inCmdName: cstring; inFunc: PlugInCmdFunc;
                           inUserData: pointer): bool ##  define a command for a unit generator  /u_cmd
    fDefineUnitCmd*: proc (inUnitClassName: cstring; inCmdName: cstring;
                         inFunc: UnitCmdFunc): bool ##  define a buf gen
    fDefineBufGen*: proc (inName: cstring; inFunc: BufGenFunc): bool ##  clear all of the unit's outputs.
    fClearUnitOutputs*: proc (inUnit: ptr Unit; inNumSamples: cint) ##  non real time memory allocation
    fNRTAlloc*: proc (inSize: csize): pointer
    fNRTRealloc*: proc (inPtr: pointer; inSize: csize): pointer
    fNRTFree*: proc (inPtr: pointer) ##  real time memory allocation
    fRTAlloc*: proc (inWorld: ptr World; inSize: csize): pointer
    fRTRealloc*: proc (inWorld: ptr World; inPtr: pointer; inSize: csize): pointer
    fRTFree*: proc (inWorld: ptr World; inPtr: pointer) ##  call to set a Node to run or not.
    fNodeRun*: proc (node: ptr Node; run: cint) ##  call to stop a Graph after the next buffer.
    fNodeEnd*: proc (graph: ptr Node) ##  send a trigger from a Node to clients
    fSendTrigger*: proc (inNode: ptr Node; triggerID: cint; value: cfloat) ##  send a reply message from a Node to clients
    fSendNodeReply*: proc (inNode: ptr Node; replyID: cint; cmdName: cstring;
                         numArgs: cint; values: ptr cfloat) ##  sending messages between real time and non real time levels.
    fSendMsgFromRT*: proc (inWorld: ptr World; inMsg: FifoMsg): bool
    fSendMsgToRT*: proc (inWorld: ptr World; inMsg: FifoMsg): bool ##  libsndfile support
    fSndFileFormatInfoFromStrings*: proc (info: ptr SF_INFO;
        headerFormatString: cstring; sampleFormatString: cstring): cint ##  get nodes by id
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
                                 completionMsgData: pointer): cint ##  fBufAlloc should only be called within a BufGenFunc
    ##  stage2 is non real time
    ##  stage3 is real time - completion msg performed if stage3 returns true
    ##  stage4 is non real time - sends done if stage4 returns true
    fBufAlloc*: proc (inBuf: ptr SndBuf; inChannels: cint; inFrames: cint;
                    inSampleRate: cdouble): cint ##  To initialise a specific FFT, ensure your input and output buffers exist. Internal data structures
                                              ##  will be allocated using the alloc object,
                                              ##  Both "fullsize" and "winsize" should be powers of two (this is not checked internally).
    fSCfftCreate*: proc (fullsize: csize; winsize: csize;
                       wintype: SCFFT_WindowFunction; indata: ptr cfloat;
                       outdata: ptr cfloat; forward: SCFFT_Direction;
                       alloc: SCFFT_Allocator): ptr scfft
    fSCfftDoFFT*: proc (f: ptr scfft)
    fSCfftDoIFFT*: proc (f: ptr scfft) ##  destroy any resources held internally.
    fSCfftDestroy*: proc (f: ptr scfft; alloc: SCFFT_Allocator) ##  Get scope buffer. Returns the maximum number of possile frames.
    fGetScopeBuffer*: proc (inWorld: ptr World; index: cint; channels: cint;
                          maxFrames: cint; a6: ScopeBufferHnd): bool
    fPushScopeBuffer*: proc (inWorld: ptr World; a3: ScopeBufferHnd; frames: cint)
    fReleaseScopeBuffer*: proc (inWorld: ptr World; a3: ScopeBufferHnd)

type
  SC_ServerType* = enum
    sc_server_scsynth = 0, sc_server_supernova = 1
