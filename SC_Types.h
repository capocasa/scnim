
#include <stddef.h>
#include <stdint.h>

typedef int SCErr;

typedef  int64_t  int64;
typedef uint64_t uint64;

typedef  int32_t  int32;
typedef uint32_t uint32;

typedef  int16_t  int16;
typedef uint16_t uint16;

typedef  int8_t  int8;
typedef uint8_t uint8;

typedef float float32;
typedef double float64;

typedef union {
	uint32 u;
	int32 i;
	float32 f;
} elem32;

typedef union {
	uint64 u;
	int64 i;
	float64 f;
} elem64;

const unsigned int kSCNameLen = 8;
const unsigned int kSCNameByteLen = 8 * sizeof(int32);

