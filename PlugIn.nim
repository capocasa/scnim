

import
  World, Graph, Unit, Wire, InterfaceTable, Unroll, InlineUnaryOp, InlineBinaryOp,
  BoundsMacros, RGen, DemandUnit, clz, sc_msg_iter, Alloca

when defined(_WIN32):
  when not defined(__GNUC__):
    template __attribute__*(x: untyped): void =
      nil

  when not defined(NAN):
    const
      NAN* = quiet_NaN()