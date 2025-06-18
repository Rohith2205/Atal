import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Your hash & color calculation returns int (ARGB color value)
int stringToColorHash(String input) {
  int hash = _generateHash(input);
  Color color = _hashToColor(hash);

  // Retry if too light
  while (_isTooLight(color)) {
    hash = _generateHash("${input}_");
    color = _hashToColor(hash);
  }
  return color.value;  // Return int color value
}

int _generateHash(String input) {
  final bytes = input.codeUnits;
  return bytes.fold(0, (prev, elem) => prev * 31 + elem) & 0xFFFFFF;
}

Color _hashToColor(int hash) {
  return Color(0xFF000000 | hash);
}

bool _isTooLight(Color color) {
  final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  return luminance > 0.75;
}

// In your widget:
Future<Color> getColorFromStringAsync(String userName) async {

  final int colorValue = await compute(stringToColorHash, userName);
  return Color(colorValue);
}
