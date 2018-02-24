/*
	SuperCollider real time audio synthesis system
    Copyright (c) 2002 James McCartney. All rights reserved.
	http://www.audiosynth.com

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
*/

#ifndef _SC_SynthInterfaceTable_
#def _SC_SynthInterfaceTable_

static const int sc_api_version = 2;

#include "SC_Types.h"
#include "SC_SndBuf.h"
#include "SC_Unit.h"
#include "SC_BufGen.h"
#include "SC_FifoMsg.h"
#include "SC_fftlib.h"
#include "SC_Export.h"

typedef	struct SF_INFO SF_INFO ;

struct World;

typedef bool (*AsyncStageFn)(World *inWorld, void* cmdData);
typedef void (*AsyncFreeFn)(World *inWorld, void* cmdData);

struct ScopeBufferHnd
{
	void *internalData;
	float *data;
	uint32 channels;
	uint32 maxFrames;

	float *channel_data( uint32 channel ); 

	operator bool ();
};

struct InterfaceTable
{
	unsigned int mSineSize;
	float32 *mSineWavetable;
	float32 *mSine;
	float32 *mCosecant;

	// call printf for debugging. should not use in finished code.
	int (*fPrint)(const char *fmt, ...);

	// get a seed for a random number generator
	int32 (*fRanSeed)();

	// define a unit def
	bool (*fDefineUnit)(const char *inUnitClassName, size_t inAllocSize,
			UnitCtorFunc inCtor, UnitDtorFunc inDtor, uint32 inFlags);

	// define a command  /cmd
	bool (*fDefinePlugInCmd)(const char *inCmdName, PlugInCmdFunc inFunc, void* inUserData);

	// define a command for a unit generator  /u_cmd
	bool (*fDefineUnitCmd)(const char *inUnitClassName, const char *inCmdName, UnitCmdFunc inFunc);

	// define a buf gen
	bool (*fDefineBufGen)(const char *inName, BufGenFunc inFunc);

	// clear all of the unit's outputs.
	void (*fClearUnitOutputs)(Unit *inUnit, int inNumSamples);

	// non real time memory allocation
	void* (*fNRTAlloc)(size_t inSize);
	void* (*fNRTRealloc)(void *inPtr, size_t inSize);
	void  (*fNRTFree)(void *inPtr);

	// real time memory allocation
	void* (*fRTAlloc)(World *inWorld, size_t inSize);
	void* (*fRTRealloc)(World *inWorld, void *inPtr, size_t inSize);
	void  (*fRTFree)(World *inWorld, void *inPtr);

	// call to set a Node to run or not.
	void (*fNodeRun)(struct Node* node, int run);

	// call to stop a Graph after the next buffer.
	void (*fNodeEnd)(struct Node* graph);

	// send a trigger from a Node to clients
	void (*fSendTrigger)(struct Node* inNode, int triggerID, float value);

	// send a reply message from a Node to clients
	void (*fSendNodeReply)(struct Node* inNode, int replyID, const char* cmdName, int numArgs, const float* values);

	// sending messages between real time and non real time levels.
	bool (*fSendMsgFromRT)(World *inWorld, struct FifoMsg  inMsg);
	bool (*fSendMsgToRT)(World *inWorld, struct FifoMsg  inMsg);

	// libsndfile support
	int (*fSndFileFormatInfoFromStrings)(SF_INFO *info,
		const char *headerFormatString, const char *sampleFormatString);

	// get nodes by id
	struct Node* (*fGetNode)(World *inWorld, int inID);
	struct Graph* (*fGetGraph)(World *inWorld, int inID);

	void (*fNRTLock)(World *inWorld);
	void (*fNRTUnlock)(World *inWorld);

	bool mUnused0;

	void (*fGroup_DeleteAll)(struct Group* group);
	void (*fDoneAction)(int doneAction, struct Unit *unit);

	int (*fDoAsynchronousCommand)
		(
			World *inWorld,
			void* replyAddr,
			const char* cmdName,
			void *cmdData,
			AsyncStageFn stage2, // stage2 is non real time
			AsyncStageFn stage3, // stage3 is real time - completion msg performed if stage3 returns true
			AsyncStageFn stage4, // stage4 is non real time - sends done if stage4 returns true
			AsyncFreeFn cleanup,
			int completionMsgSize,
			void* completionMsgData
		);


	// fBufAlloc should only be called within a BufGenFunc
	int (*fBufAlloc)(SndBuf *inBuf, int inChannels, int inFrames, double inSampleRate);

	// To initialise a specific FFT, ensure your input and output buffers exist. Internal data structures
	// will be allocated using the alloc object,
	// Both "fullsize" and "winsize" should be powers of two (this is not checked internally).
	struct scfft * (*fSCfftCreate)(size_t fullsize, size_t winsize, SCFFT_WindowFunction wintype,
					 float *indata, float *outdata, SCFFT_Direction forward, SCFFT_Allocator alloc);

	void (*fSCfftDoFFT)(scfft *f);
	void (*fSCfftDoIFFT)(scfft *f);

	// destroy any resources held internally.
	void (*fSCfftDestroy)(scfft *f, SCFFT_Allocator alloc);

	// Get scope buffer. Returns the maximum number of possile frames.
	bool (*fGetScopeBuffer)(World *inWorld, int index, int channels, int maxFrames, ScopeBufferHnd );
	void (*fPushScopeBuffer)(World *inWorld, ScopeBufferHnd , int frames);
	void (*fReleaseScopeBuffer)(World *inWorld, ScopeBufferHnd );
};

typedef struct InterfaceTable InterfaceTable;

#def Print (*ft->fPrint)
#def RanSeed (*ft->fRanSeed)
#def NodeEnd (*ft->fNodeEnd)
#def NodeRun (*ft->fNodeRun)
#def DefineUnit (*ft->fDefineUnit)
#def DefinePlugInCmd (*ft->fDefinePlugInCmd)
#def DefineUnitCmd (*ft->fDefineUnitCmd)
#def DefineBufGen (*ft->fDefineBufGen)
#def ClearUnitOutputs (*ft->fClearUnitOutputs)
#def SendTrigger (*ft->fSendTrigger)
#def SendNodeReply (*ft->fSendNodeReply)
#def SendMsgFromRT (*ft->fSendMsgFromRT)
#def SendMsgToRT (*ft->fSendMsgToRT)
#def DoneAction (*ft->fDoneAction)

#def NRTAlloc (*ft->fNRTAlloc)
#def NRTRealloc (*ft->fNRTRealloc)
#def NRTFree (*ft->fNRTFree)

#def RTAlloc (*ft->fRTAlloc)
#def RTRealloc (*ft->fRTRealloc)
#def RTFree (*ft->fRTFree)

#def SC_GetNode (*ft->fGetNode)
#def SC_GetGraph (*ft->fGetGraph)

#def NRTLock (*ft->fNRTLock)
#def NRTUnlock (*ft->fNRTUnlock)

#def BufAlloc (*ft->fBufAlloc)

#def GroupDeleteAll (*ft->fGroup_DeleteAll)

#def SndFileFormatInfoFromStrings (*ft->fSndFileFormatInfoFromStrings)

#def DoAsynchronousCommand (*ft->fDoAsynchronousCommand)

#def DefineSimpleUnit(name) \
	(*ft->fDefineUnit)(#name, sizeof(name), (UnitCtorFunc)&name##_Ctor, 0, 0);

#def DefineDtorUnit(name) \
	(*ft->fDefineUnit)(#name, sizeof(name), (UnitCtorFunc)&name##_Ctor, \
	(UnitDtorFunc)&name##_Dtor, 0);

#def DefineSimpleCantAliasUnit(name) \
	(*ft->fDefineUnit)(#name, sizeof(name), (UnitCtorFunc)&name##_Ctor, 0, kUnitDef_CantAliasInputsToOutputs);

#def DefineDtorCantAliasUnit(name) \
	(*ft->fDefineUnit)(#name, sizeof(name), (UnitCtorFunc)&name##_Ctor, \
	(UnitDtorFunc)&name##_Dtor, kUnitDef_CantAliasInputsToOutputs);

typedef enum {
    sc_server_scsynth = 0,
    sc_server_supernova = 1
} SC_ServerType;

#ifdef STATIC_PLUGINS
	#def PluginLoad(name) void name##_Load(InterfaceTable *inTable)
#else
	#ifdef SUPERNOVA
	#def SUPERNOVA_CHECK C_LINKAGE SC_API_EXPORT int server_type(void) { return sc_server_supernova; }
	#else
	#def SUPERNOVA_CHECK C_LINKAGE SC_API_EXPORT int server_type(void) { return sc_server_scsynth; }
	#endif

	#def PluginLoad(name) 														\
		C_LINKAGE SC_API_EXPORT int api_version(void) { return sc_api_version; }		\
		SUPERNOVA_CHECK																\
		C_LINKAGE SC_API_EXPORT void load(InterfaceTable *inTable)
#endif

#def scfft_create (*ft->fSCfftCreate)
#def scfft_dofft (*ft->fSCfftDoFFT)
#def scfft_doifft (*ft->fSCfftDoIFFT)
#def scfft_destroy (*ft->fSCfftDestroy)



#endif
