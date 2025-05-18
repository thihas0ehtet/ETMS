extension ResponseCode on int {
  bool get codeSuccess {
    return this>= 200 && this < 300;
  }
}