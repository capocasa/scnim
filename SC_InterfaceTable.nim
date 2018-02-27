var sc_api_version*: cint = 3

import
  SC_Types, SC_SndBuf, SC_Unit, SC_BufGen, SC_FifoMsg, SC_fftlib, SC_Export

type
  World* {.bycopy.} = object
  
  AsyncStageFn* = proc (inWorld: ptr World; cmdData: pointer): bool
  AsyncFreeFn* = proc (inWorld: ptr World; cmdData: pointer)
  ScopeBufferHnd* {.bycopy.} = object
    internalData*: pointer
    data*: ptr cfloat
    channels*: uint32
    maxFrames*: uint32         ## -	float *channel_data( uint32 channel ) {
                     ## -		return data + (channel * maxFrames);
                     ## -	}
                     ## -
                     ## -	operator bool ()
                     ## -	{
                     ## -		return internalData != 0;
                     ## -	}
  
  InterfaceTable* {.bycopy.} = object
    mSineSize*: cuint
    mSineWavetable*: ptr float32
    mSine*: ptr float32
    mCosecant*: ptr float32     ##  call printf for debugging. should not use in finished code.
    fPrint*: proc (fmt: cstring): cint {.varargs.} ##  get a seed for a random number generator
    fRanSeed*: proc (): int32    ##  define a unit def
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
                                                       ## -bool (*fSendMsgFromRT)(World *inWorld, struct FifoMsg& inMsg);
                                                       ## -bool (*fSendMsgToRT)(World *inWorld, struct FifoMsg& inMsg);
                                                       ##  libsndfile support
    fSndFileFormatInfoFromStrings*: proc (info: ptr SF_INFO;
                                        headerFormatString: cstring;
                                        sampleFormatString: cstring): cint ##  get nodes by id
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
                                              ## -struct scfft * (*fSCfftCreate)(size_t fullsize, size_t winsize, SCFFT_WindowFunction wintype,
                                              ## -				 float *indata, float *outdata, SCFFT_Direction forward, SCFFT_Allocator & alloc);
    fSCfftDoFFT*: proc (f: ptr scfft)
    fSCfftDoIFFT*: proc (f: ptr scfft) ##  destroy any resources held internally.
                                  ## -void (*fSCfftDestroy)(scfft *f, SCFFT_Allocator & alloc);
                                  ##  Get scope buffer. Returns the maximum number of possile frames.
                                  ## -bool (*fGetScopeBuffer)(World *inWorld, int index, int channels, int maxFrames, ScopeBufferHnd &);
                                  ## -void (*fPushScopeBuffer)(World *inWorld, ScopeBufferHnd &, int frames);
                                  ## -void (*fReleaseScopeBuffer)(World *inWorld, ScopeBufferHnd &);
  

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
  SC_GetNode* = (ft.fGetNode[])
  SC_GetGraph* = (ft.fGetGraph[])
  NRTLock* = (ft.fNRTLock[])
  NRTUnlock* = (ft.fNRTUnlock[])
  BufAlloc* = (ft.fBufAlloc[])
  GroupDeleteAll* = (ft.fGroup_DeleteAll[])
  SndFileFormatInfoFromStrings* = (ft.fSndFileFormatInfoFromStrings[])
  DoAsynchronousCommand* = (ft.fDoAsynchronousCommand[])

type
  SC_ServerType* = enum
    sc_server_scsynth = 0, sc_server_supernova = 1


when defined(STATIC_PLUGINS):
  ## -	#define PluginLoad(name) void name##_Load(InterfaceTable *inTable)
else:
  when defined(SUPERNOVA):
    ## -#define SUPERNOVA_CHECK C_LINKAGE SC_API_EXPORT int server_type(void) { return sc_server_supernova; }
  else:
    ## -#define SUPERNOVA_CHECK C_LINKAGE SC_API_EXPORT int server_type(void) { return sc_server_scsynth; }
  template PluginLoad*(name: untyped): void =
    ## -C_LINKAGE SC_API_EXPORT int api_version(void) { return sc_api_version; }		\
    ## -SUPERNOVA_CHECK																\
    ## -C_LINKAGE SC_API_EXPORT void load(InterfaceTable *inTable)
    nil

const
  scfft_create* = (ft.fSCfftCreate[])
  scfft_dofft* = (ft.fSCfftDoFFT[])
  scfft_doifft* = (ft.fSCfftDoIFFT[])
  scfft_destroy* = (ft.fSCfftDestroy[])

## -class SCWorld_Allocator:
## -	public SCFFT_Allocator
## -{
## -	InterfaceTable * ft;
## -	World * world;
## -
## -public:
## -	SCWorld_Allocator(InterfaceTable * ft, World * world):
## -		ft(ft), world(world)
## -	{}
## -
## -	virtual void* alloc(size_t size)
## -	{
## -		return RTAlloc(world, size);
## -	}
## -
## -	virtual void free(void* ptr)
## -	{
## -		RTFree(world, ptr);
## -	}
## -};
## -
