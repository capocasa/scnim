
import scnim

proc api_version(): int {.cdecl,exportc,dynlib.} =
  return sc_api_version;

proc server_type(): ServerType {.cdecl,exportc,dynlib.}=
  return when defined(SUPERNOVA): sc_server_supernova else: sc_server_scsynth

var ft: ptr InterfaceTable

type
  Example = object of Unit

proc next(unit: ptr Example, numSamples: cint) {.cdecl,exportc,dynlib.} =
  var
    input = unit.mInBuf[]
    output = unit.mOutBuf[]

  for i in 0..numSamples:
    output[i] = input[i]

proc ctor(unit: ptr Example) {.cdecl,exportc,dynlib.} =
  unit.mCalcFunc = cast[UnitCalcFunc](next)

proc load(inTable: ptr InterfaceTable) {.cdecl,exportc,dynlib.} =
  ft = inTable;
  discard ft.fDefineUnit("Example", sizeof(Example), cast[UnitCtorFunc](ctor), nil, 0'u32)

