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

#include "SC_Types.h"
#include "SC_SndBuf.h"

typedef void (*UnitCtorFunc)(struct Unit* inUnit);
typedef void (*UnitDtorFunc)(struct Unit* inUnit);

typedef void (*UnitCalcFunc)(struct Unit *inThing, int inNumSamples);

struct SC_Unit_Extensions {
	float * todo;
};

struct Unit
{
	struct World *mWorld;
	struct UnitDef *mUnitDef;
	struct Graph *mParent;
	uint32 mNumInputs, mNumOutputs; // changed from uint16 for synthdef ver 2
	int16 mCalcRate;
	int16 mSpecialIndex;		// used by unary and binary ops
	int16 mParentIndex;
	int16 mDone;
	struct Wire **mInput, **mOutput;
	struct Rate *mRate;
	SC_Unit_Extensions* mExtensions; //future proofing and backwards compatibility; used to be SC_Dimension struct pointer
	float **mInBuf, **mOutBuf;

	UnitCalcFunc mCalcFunc;
	int mBufLength;
};

typedef struct Unit Unit;

enum {
	kUnitDef_CantAliasInputsToOutputs = 1
};

