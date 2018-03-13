
scnim - Writing SuperCollider UGens using Nim
=============================================

Introduction
------------

*Nim* is an exciting new programming language. It is about as easy to work with as ruby, but it compiles to very efficient C code.

It also uses itself as a pre-processor, so you can generate huge blobs of efficient code without having to do a lot of copying and pasting by hand.

This seems to make it ideally suitable for writing realtime signal processing code, and, by extension, SuperCollider plugins.

This is a proof of concept that shows to see how well it holds up in practice- and it works really well!

How to use it
-------------

Installation

    nimble install scnim

This is what a simple SuperCollider plugin looks like written with scnim.

    # ExampleUGens.nim
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

This gets compiled into an intermediate C++ file that links up with SuperCollider like a normal UGen does, using the following command:

	  nim --gc=none --app=lib --out=ExampleUGens.so cpp ExampleUGens.nim

The example can also be found in the `examples` directory- see `examples/README.md` to compile and use the example on SuperCollier.

Most of the code is boilerplate- have a look at the `next` procedure to develop your code.

Realtime considerations
-----------------------

The same considerations apply when developing realtime code with Nim as with C++. Don't use features that allocate their own memory, prefer primitive types, keep it simple.

Nim normally uses a garbage collector, a system to automatically frees up that kind of memory. For UGen development, it is turned off using the `-gc=none` switch above. As a neat side effect, the compiler will warn you about using "garbage collected memory", so if you're not sure which feature you can use, you can just try it and see if you get any warnings.

Theoretically, Nim SuperCollider plugins should be just as fast as C code, and occasionally faster when delivering optimizations. From looking at the generated code, I can say this is most likely true.

Status
------

The code works and it's fast, so the proof of concept was a success!

The basics are present, so it can already be used to develop simple UGens by copying the example directory- but most more involved UGen features are still missing though.

Most of all, Nim-Code is usually considered "safe", which means that if your program compiles, it won't crash. This isn't the case yet for scnim- Nim is really good at creating language features, so it should be quite possible to hide away all the gritty details behind a very clean interface without sacrificing performance- but we haven't figured out yet how to do that.

Development
-----------

Most SuperCollider plugin headers were already automatically translated to nim, they require manual adapting though. This has been done for the basic features in the example above, but not yet for 

- Buffers
- Demand UGens
- Plugin commands
- Async commands
- Generator commands
- Supernova support

Nim does automatic dead code elimination if you add the `--deadCodeElim=on` switch to the compile command above. Still, when the features are implemented, some code cleanup and possibly optimization should be performed before declaring this stable.

Nim is cross-platform, so in principle, this will work on Windows, Linux and OSX. It has only been tested on Linux so far, so compile instructions need to be added for other platforms.

Some tooling to add dependencies would be helpful, possibly adapting `cmake`.

Contributions
-------------

All contributions are welcome, large and small!

(c) 2018 Carlo Capocasa. MIT License.

