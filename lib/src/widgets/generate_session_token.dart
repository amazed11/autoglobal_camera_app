import 'dart:math';

String? getSessionToken() {
  var random = Random.secure();
  var values = List<int>.generate(16, (i) => random.nextInt(256));
  values[6] = (values[6] & 0x0f) | 0x40;
  values[8] = (values[8] & 0x3f) | 0x80;
  var buffer = StringBuffer();
  for (var value in values) {
    buffer.write(value.toRadixString(16).padLeft(2, '0'));
  }
  var uuid = buffer.toString();
  return uuid;
}
