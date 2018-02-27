
#include "SC_Endian.h"
#include "SC_Types.h"
#include <string.h>

// return the ptr to the byte after the OSC string.
inline const char* OSCstrskip(const char *str)
{
//	while (str[3]) { str += 4; }
//	return str + 4;
	do { str += 4; } while (str[-1]);
	return str;
}

// returns the number of bytes (including padding) for an OSC string.
inline size_t OSCstrlen(const char *strin)
{
	return OSCstrskip(strin) - strin;
}

// returns a float, converting an int if necessary
inline float32 OSCfloat(const char* inData)
{
	elem32 elem;
	elem.u = sc_ntohl(*(uint32*)inData);
	return elem.f;
}

inline int32 OSCint(const char* inData)
{
	return (int32)sc_ntohl(*(uint32*)inData);
}

inline int64 OSCtime(const char* inData)
{
	return ((int64)sc_ntohl(*(uint32*)inData) << 32) + (sc_ntohl(*(uint32*)(inData + 4)));
}

inline float64 OSCdouble(const char* inData)
{
	elem64 slot;
	slot.i = ((int64)sc_ntohl(*(uint32*)inData) << 32) + (sc_ntohl(*(uint32*)(inData + 4)));
	return slot.f;
}

struct sc_msg_iter
{
	const char *data, *rdpos, *endpos, *tags;
	int size, count;
	
	void sc_msg_iter();
	void sc_msg_iter(int inSize, const char* inData);
	void init(int inSize, const char* inData);
	int64 gett(int64 defaultValue = 1);
	int32 geti(int32 defaultValue = 0);
	float32 getf(float32 defaultValue = 0.f);
	float64 getd(float64 defaultValue = 0.f);
	const char *gets(const char* defaultValue = 0);
	int32 *gets4(char* defaultValue = 0);
	size_t getbsize();
	void getb(char* outData, size_t inSize);
	void skipb();
	size_t remain();
//-{ return endpos - rdpos; }

    char nextTag(char defaultTag = 'f');
//-{ return tags ? tags[count] : defaultTag; }
};

