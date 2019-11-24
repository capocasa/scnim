
switch("deadCodeElim", "on")
switch("gc", "none")
switch("out", "ExampleUGens.so")
switch("app", "lib")

task build, "build":
  setCommand("cpp")

