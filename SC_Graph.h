#include "SC_Node.h"
#include "SC_Rate.h"
#include "SC_SndBuf.h"

/*
 changes to this struct likely also mean that a change is needed for
    static const int sc_api_version = x;
 value in SC_InterfaceTable.h file.
 */
struct Graph
{

  Unit** = object

	Node mNode;

	uint32 mNumWires;
	struct Wire *mWire;

	uint32 mNumControls;
	float *mControls;
	float **mMapControls;
	int32 *mAudioBusOffsets;

	// try this for setting the rate of a control
	int *mControlRates;

	uint32 mNumUnits;
	struct Unit **mUnits;

	uint32 mNumCalcUnits;
	struct Unit **mCalcUnits; // excludes i-rate units.

	int mSampleOffset;
	struct RGen* mRGen;

	struct Unit *mLocalAudioBusUnit;
	struct Unit *mLocalControlBusUnit;

	float mSubsampleOffset;

	SndBuf *mLocalSndBufs;
	int localBufNum;
	int localMaxBufNum;
};
typedef struct Graph Graph;

