
// From InterfaceTable
//
class ScopeBufferHnd
{
	void *internalData;
	float *data;
	uint32 channels;
	uint32 maxFrames;

	float *channel_data( uint32 channel ) {
		return data + (channel * maxFrames);
	}

	operator bool ()
	{
		return internalData != 0;
	}
};

