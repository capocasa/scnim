#include "SC_Types.h"

typedef void (*NodeCalcFunc)(struct Node *inNode);

struct Node
{
	int32 mID;
	int32 mHash;

	struct World *mWorld;
	struct NodeDef *mDef;
	NodeCalcFunc mCalcFunc;

	struct Node *mPrev, *mNext;
	struct Group *mParent;

	int32 mIsGroup;
};
typedef struct Node Node;

enum { kNode_Go, kNode_End, kNode_On, kNode_Off, kNode_Move, kNode_Info };

