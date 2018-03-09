
import
  PlugIn,InterfaceTable,Unit,ptrmath
  
proc api_version(): int {.cdecl,exportc,dynlib.} =
  return sc_api_version;

proc server_type(): ServerType {.cdecl,exportc,dynlib.}=
  return when defined(SUPERNOVA): sc_server_supernova else: sc_server_scsynth

var ft: ptr InterfaceTable

proc next(unit: ptr Unit, numSamples: cint) {.cdecl,exportc,dynlib.} =
  var
    input = unit.mInBuf[]
    output = unit.mOutBuf[]

  for i in 0..numSamples:
    output[i] = input[i]

proc ctor (unit: ptr Unit) {.cdecl,exportc,dynlib.} =
  unit.mCalcFunc = next

proc load(inTable: ptr InterfaceTable) {.cdecl,exportc,dynlib.} =
  ft = inTable;
  discard ft.fDefineUnit("Example", sizeof(Unit.Unit), ctor, nil, 0'u32)

