
# define LITTLE_ENDIAN 1234
# define BIG_ENDIAN 4321
# define BYTE_ORDER LITTLE_ENDIAN


static inline unsigned int sc_htonl(unsigned int x)
{
#if BYTE_ORDER == LITTLE_ENDIAN
	unsigned char *s = (unsigned char *)&x;
	return (unsigned int)(s[0] << 24 | s[1] << 16 | s[2] << 8 | s[3]);
#else
	return x;
#endif
}

static inline unsigned short sc_htons(unsigned short x)
{
#if BYTE_ORDER == LITTLE_ENDIAN
	unsigned char *s = (unsigned char *) &x;
	return (unsigned short)(s[0] << 8 | s[1]);
#else
	return x;
#endif
}

static inline unsigned int sc_ntohl(unsigned int x)
{
	return sc_htonl(x);
}

static inline unsigned short sc_ntohs(unsigned short x)
{
	return sc_htons(x);
}


