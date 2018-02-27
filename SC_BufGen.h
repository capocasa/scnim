
#include "SC_Types.h"

typedef void (*BufGenFunc)(struct World *world, struct SndBuf *buf, struct sc_msg_iter *msg);

struct BufGen
{
	int32 mBufGenName[kSCNameLen];
	int32 mHash;

	BufGenFunc mBufGenFunc;
};

bool BufGen_Create(const char *inName, BufGenFunc inFunc);

