#include "SC_Types.h"

struct Wire
{
	struct Unit *mFromUnit;
	int32 mCalcRate;
	float32 *mBuffer;
	float32 mScalarValue;
};
typedef struct Wire Wire;

