
enum { calc_ScalarRate, calc_BufRate, calc_FullRate, calc_DemandRate };

struct Rate
{
	double mSampleRate; // samples per second
	double mSampleDur;  // seconds per sample
	double mBufDuration; // seconds per buffer
	double mBufRate;	// buffers per second
	double mSlopeFactor;  // 1. / NumSamples
	double mRadiansPerSample; // 2pi / SampleRate
	int mBufLength;	// length of the buffer
	// second order filter loops are often unrolled by 3
	int mFilterLoops, mFilterRemain;
	double mFilterSlope;
};
typedef struct Rate Rate;

