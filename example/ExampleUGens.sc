Example : PureUGen {
  *ar {
    arg in;
    ^this.multiNew('audio', in) 
  }
  *kr {
    arg in;
    ^this.multiNew('control', in)
  }
}


