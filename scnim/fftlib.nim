


const
  FFT_MINSIZE* = 8
  FFT_LOG2_MINSIZE* = 3
  FFT_MAXSIZE* = 32768
  FFT_LOG2_MAXSIZE* = 15


const
  FFT_ABSOLUTE_MAXSIZE* = 262144
  FFT_LOG2_ABSOLUTE_MAXSIZE* = 18
  FFT_LOG2_ABSOLUTE_MAXSIZE_PLUS1* = 19

#discard "forward decl of scfft"
type
  scfft = object
  SCFFT_Allocator* {.bycopy.} = object
  

#proc alloc*(this: var SCFFT_Allocator; size: csize): pointer
#proc free*(this: var SCFFT_Allocator; `ptr`: pointer)

type
  SCFFT_Direction* = enum
    kBackward = 0, kForward = 1



type
  SCFFT_WindowFunction* = enum
    kRectWindow = -1, kSineWindow = 0, kHannWindow = 1



#proc scfft_create*(fullsize: csize; winsize: csize; wintype: SCFFT_WindowFunction;
#                  indata: ptr cfloat; outdata: ptr cfloat; forward: SCFFT_Direction;
#                  alloc: var SCFFT_Allocator): ptr scfft

#proc scfft_dofft*(f: ptr scfft)
#proc scfft_doifft*(f: ptr scfft)

#proc scfft_destroy*(f: ptr scfft; alloc: var SCFFT_Allocator)
