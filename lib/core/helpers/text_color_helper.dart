import 'package:flutter/material.dart';

Color getContrastingTextColor(Gradient gradient) {
  if (gradient is LinearGradient) {
    // Take average color of gradient
    int r = 0, g = 0, b = 0;

    for (var color in gradient.colors) {
      r += color.red;
      g += color.green;
      b += color.blue;
    }

    int count = gradient.colors.length;

    Color averageColor = Color.fromARGB(
      255,
      (r / count).round(),
      (g / count).round(),
      (b / count).round(),
    );

    double luminance = averageColor.computeLuminance();

    return luminance > 0.4 ? Colors.black : Colors.white;
  }

  return Colors.white;
}
