
(fork {s.bootSync;
  x.free;x={
    var input, output;
    input = DC.ar(1.234);
    input.poll(2, "input");
    output = Example.ar(input);
    output.poll(2, "output");
  }.play;
})

